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
using System.Runtime.CompilerServices;

namespace GenerateServiceOperations
{
    class Program
    {
        static void Main(string[] args)
        {
            //GenerateServiceOperationsFromAssembly();
            GenerateServiceOperationsFromEndpoint();
        }

        static void GenerateServiceOperationsFromAssembly()
        {
            string fileName = @"C:\Users\Jeremy\Code\JustTheServiceRef\JustTheServiceRef\bin\Debug\EAPI.dll";
            Assembly assembly = Assembly.LoadFrom(fileName);

            var client = assembly.GetType("Shubert.EApiWS.EAPIClient");
            var methods = client.GetRuntimeMethods();
            
            //Filter out async methods, untestable methods and special cases.
            foreach(MethodInfo m in methods)
            {
                //Is there a filter table?
                //Skip async operations.
                if (m.Name.Contains("SignOn") ||
                    m.Name.Contains("SignOff") ||
                    m.Name.Contains("StartNewSession") ||
                    m.Name.Contains("Ping") ||
                    m.Name.Contains("EndSession"))
                    continue;

                if (m.DeclaringType.Name != "EAPIClient")
                    continue;

                if (m.ReturnType == typeof(IAsyncResult))
                    continue;

                if (m.ReturnType.BaseType.Name == "Task")
                    continue;

                Console.WriteLine("Generating method {0}, return type {1}", m.Name, m.ReturnType.Name);

                ParameterInfo[] parameterInfo = m.GetParameters();

                foreach (ParameterInfo p in parameterInfo)
                {
                    var RunTimeMethods = p.ParameterType.GetRuntimeMethods();
                    var RunTimeFields = p.ParameterType.GetRuntimeProperties();

                    foreach (PropertyInfo fi in RunTimeFields)
                    {
                        Console.WriteLine("... {0}", fi.Name);
                    }
                }

                /*foreach (var returnField in m.ReturnType.GetRuntimeProperties())
                {
                    Console.WriteLine("<<< {0}", returnField.Name);
                }*/

                foreach (var returnProp in m.ReturnType.GetRuntimeProperties())
                {
                    Console.WriteLine("<<< {0}", returnProp.Name);
                    Console.WriteLine("\t*** {0}", returnProp.GetMethod.ReturnParameter);
                    //TODO is array?
                    //foreach (var returnPropProperty in returnProp.GetMethod.ReturnParameter.GetType().GetElementType().GetRuntimeProperties())
                    if (returnProp.GetMethod.ReturnParameter.ParameterType.IsArray)
                    {
                        foreach (var returnPropProperty in returnProp.GetMethod.ReturnParameter.ParameterType.GetElementType().GetRuntimeProperties())
                        {
                            Console.WriteLine("\t\t``` {0}", returnPropProperty.Name);
                        }
                    }
                    else
                    {
                        foreach (var returnPropProperty in returnProp.GetMethod.ReturnParameter.ParameterType.GetRuntimeProperties())
                        {
                            Console.WriteLine("\t\t``` {0}", returnPropProperty.Name);
                        }
                    }
                }
            }
        }

        static void GenerateServiceOperationsFromEndpoint()
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
                            if (m.Name.Contains("SignOn") ||
                                m.Name.Contains("SignOff") ||
                                m.Name.Contains("StartNewSession") ||
                                m.Name.Contains("Ping") ||
                                m.Name.Contains("EndSession"))
                                continue;

                            if (m.DeclaringType.Name != "EAPIClient")
                                continue;

                            if (m.ReturnType == typeof(IAsyncResult))
                                continue;

                            if (m.ReturnType.BaseType.Name == "Task")
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
                            int application_method_id = (int)sqlCmd.ExecuteScalar();

                            //Return type fields.
                            try
                            {
                                using (var sqlRespParmCmd = new SqlCommand())
                                {
                                    foreach (var returnProp in m.ReturnType.GetRuntimeProperties())
                                    {
                                        Console.WriteLine("<<< {0}", returnProp.Name);

                                        sqlRespParmCmd.Parameters.Clear();

                                        if (returnProp.GetMethod.ReturnParameter.ParameterType.IsArray)
                                        {
                                            sqlRespParmCmd.Parameters.Add(new SqlParameter("is_container", SqlDbType.Int) { Value = 1 });
                                        }
                                        else
                                        {
                                            sqlRespParmCmd.Parameters.Add(new SqlParameter("is_container", SqlDbType.Int) { Value = 0 });
                                        }

                                        sqlRespParmCmd.Connection = sqlConn;
                                        sqlRespParmCmd.CommandType = CommandType.StoredProcedure;
                                        sqlRespParmCmd.CommandText = "ag_application_method_response_parameters_ins";
                                        sqlRespParmCmd.Parameters.Add(new SqlParameter("application_method_id", SqlDbType.Int) { Value = application_method_id });
                                        sqlRespParmCmd.Parameters.Add(new SqlParameter("application_method_response_parameter_name", SqlDbType.VarChar) { Value = returnProp.Name });
                                        sqlRespParmCmd.Parameters.Add(new SqlParameter("position", SqlDbType.Int) { Value = 0 }); //TODO: does it need a position?
                                                                                                                                  //sqlRespParmCmd.Parameters.Add(new SqlParameter("value", SqlDbType.Int) { Value = null }); //TODO: So there is a need for a response definition so after an operation the response can be recorded and used for the next operation in the test sequence but there is a need for a history of responses so. Maybe there is definition response type and actual results are just serialized - but then how to extraxt those values for chaining.
                                        int application_method_response_id = (int)sqlRespParmCmd.ExecuteScalar();
                                        //
                                    }
                                }
                            }
                            catch (SqlException ex)
                            {
                                Debugger.Log(1, "SQL", ex.Message);
                                Console.WriteLine(ex.Message);
                            }

                            //Operation input parameters.
                            using (var sqlParmCmd = new SqlCommand())
                            {
                                sqlParmCmd.Connection = sqlConn;
                                sqlParmCmd.CommandType = CommandType.StoredProcedure;

                                ParameterInfo[] parameterInfo = m.GetParameters();
                                sqlParmCmd.CommandText = "ag_application_method_parameters_ins";

                                /*
                                 * For each method skip the token parameter info.
                                 * This type might have a different name for different APIs so there
                                 * should be a credentials table that has the names of the methods and types 
                                 * that should be skipped.
                                 */
                                foreach (ParameterInfo p in parameterInfo)
                                {
                                    if (p.Name == "Toke")
                                        continue;

                                    sqlParmCmd.Parameters.Clear();

                                    var RunTimeMethods = p.ParameterType.GetRuntimeMethods();
                                    var RunTimeProperties = p.ParameterType.GetRuntimeProperties();

                                    foreach (PropertyInfo fi in RunTimeProperties)
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
