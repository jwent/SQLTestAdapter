using System;
using System.Configuration;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestPlatform.ObjectModel;
using Microsoft.VisualStudio.TestPlatform.ObjectModel.Adapter;
using System.Diagnostics;
using SQLTestAdapter.EAPIServiceReference;
using System.Security.Cryptography.X509Certificates;
using System.ServiceModel.Configuration;
using System.Reflection;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GenerateServiceOperations
{
    class Program
    {
        static void Main(string[] args)
        {
            System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls11;
            System.ServiceModel.BasicHttpBinding binding = new System.ServiceModel.BasicHttpBinding();
            binding.Security.Mode = System.ServiceModel.BasicHttpSecurityMode.Transport;
            binding.Security.Transport.ClientCredentialType = System.ServiceModel.HttpClientCredentialType.None;
            binding.MaxBufferSize = 64000000;
            binding.MaxReceivedMessageSize = 64000000;
            System.ServiceModel.EndpointAddress EndPoint = new System.ServiceModel.EndpointAddress("https://geapi.dqtelecharge.com/EAPI.svc");
            EAPIClient client = new EAPIClient(binding, EndPoint);

            MethodInfo[] testMethods = client.GetType().GetMethods();

            try
            {
                using (SqlConnection sqlConn = new SqlConnection("Data Source=LAPTOP-DHCHDQG6\\SQLEXPRESS;Initial Catalog=TestAutomation;Integrated Security=True"))
                {
                    //Open the database.
                    sqlConn.Open();
                    var result = false;

                    using (var sqlCmd = new SqlCommand())
                    {
                        foreach (MethodInfo m in testMethods)
                        {
                            //Skip async operations.
                            if (m.Name.Contains("Async"))
                                continue;

                            Console.WriteLine("Generating method {0}, return type {1}", m.Name, m.ReturnType.Name);

                            //Run the stored procedures.
                            sqlCmd.Connection = sqlConn;
                            sqlCmd.CommandType = CommandType.StoredProcedure;

                            //Methods
                            sqlCmd.CommandText = "ag_application_method_ins";
                            sqlCmd.Parameters.Clear();
                            sqlCmd.Parameters.Add(new SqlParameter("application_id", SqlDbType.Int) { Value = 1 });
                            sqlCmd.Parameters.Add(new SqlParameter("application_version_id", SqlDbType.Int) { Value = 1 });
                            sqlCmd.Parameters.Add(new SqlParameter("method_name", SqlDbType.VarChar) { Value = m.Name });
                            sqlCmd.Parameters.Add(new SqlParameter("return_type", SqlDbType.VarChar) { Value = m.ReturnType.Name });

                            //Return type fields.
                            foreach (var returnField in m.ReturnType.GetRuntimeFields())
                            {
                                Console.WriteLine("<<< {0}", returnField.Name);
                            }

                            int application_method_id = (int) sqlCmd.ExecuteScalar();

                            //Operation input parameters.
                            using (var sqlParmCmd = new SqlCommand())
                            {
                                sqlParmCmd.Connection = sqlConn;
                                sqlParmCmd.CommandType = CommandType.StoredProcedure;

                                ParameterInfo[] parameterInfo = m.GetParameters();
                                sqlParmCmd.CommandText = "ag_application_method_parameters_ins";
                                
                                foreach (ParameterInfo p in parameterInfo)
                                {
                                    sqlParmCmd.Parameters.Clear();

                                    var RunTimeMethods = p.ParameterType.GetRuntimeMethods();
                                    var RunTimeFields = p.ParameterType.GetRuntimeFields();

                                    foreach (FieldInfo fi in RunTimeFields)
                                    {
                                        sqlParmCmd.Parameters.Clear();
                                        Console.WriteLine("... {0}", fi.Name);
                                        sqlParmCmd.Parameters.Add(new SqlParameter("application_method_id", SqlDbType.Int) { Value = application_method_id });
                                        sqlParmCmd.Parameters.Add(new SqlParameter("application_method_parameter_name", SqlDbType.VarChar) { Value = fi.Name });
                                        sqlParmCmd.Parameters.Add(new SqlParameter("position", SqlDbType.Int) { Value = p.Position });
                                        result = sqlParmCmd.ExecuteNonQuery() > 0;
                                    }
                                }
                            }
                        }
                    }

                    sqlConn.Close();
                }
            }
            catch (SqlException ex)
            {
                Debugger.Log(1, "SQL", ex.Message);
                Console.WriteLine(ex.Message);
            }
        }
    }
}
