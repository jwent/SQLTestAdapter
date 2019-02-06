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

            Debugger.Break();


            //Test
            //Assembly assem = typeof(SQLTestAdapter.EAPIServiceReference.EAPIClient).Assembly;
            //MethodInfo testMethod = assem.GetType(SQLTestAdapter.EAPIServiceReference.EAPIClient).GetMethod("Cities");
            MethodInfo testMethod = client.GetType().GetMethod("Shows");
            //TypeInfo t = typeof(Calendar).GetTypeInfo();
            //public SQLTestAdapter.EAPIServiceReference.ShowsResponse Shows(SQLTestAdapter.EAPIServiceReference.SessionToken Toke, SQLTestAdapter.EAPIServiceReference.ShowsFilter Filter)
            //Looking for SQLTestAdapter.EAPIServiceReference.ShowsFilter
            Type t = testMethod.GetType();
            var mes = t.GetMethods();
            TypeInfo ti = t.GetTypeInfo();

            //Type resultType = Type.GetType("SQLTestAdapter.EAPIServiceReference.Cities");
            //ParameterInfo[] parameterInfoz = resultType.GetMethod().GetParameters();
            //Assembly asm = Assembly.LoadFrom(@"C:\Users\Jeremy\Code\RealSQLTestAdapter\SQLTestAdapter\GenerateServiceOperations\EAPIWS.dll");
            //Type resultType = asm.GetType("Shows");
            //MethodInfo met = asm.GetType().GetMethod("Shows");
            //ParameterInfo[] parameterInfoz = resultType.GetMethod("City").GetParameters();
            ParameterInfo[] parameterInfoz = testMethod.GetParameters();
            foreach(ParameterInfo p in parameterInfoz)
            {
                var ttt = p.Name;
                var tty = p.ParameterType.GetRuntimeMethods();
                var ttx = p.ParameterType.GetRuntimeFields();
                //TypeInfo type_info = typeof(p.ParameterType.FullName);//p is avariable but used liek a type.
                //-((System.Reflection.TypeInfo)((System.Reflection.RuntimeParameterInfo)p).ParameterType).DeclaredMembers { System.Reflection.MemberInfo[17]}
                //System.Collections.Generic.IEnumerable < System.Reflection.MemberInfo > { System.Reflection.MemberInfo[]}


                //Console.WriteLine("Generating method {0}, return type {1}", m.Name, m.ReturnType.ToString());
            }
            //MemberInfo minfo = testMethod.MemberType();

            //- DeclaredMembers { System.Reflection.MemberInfo[17]}
            //System.Collections.Generic.IEnumerable < System.Reflection.MemberInfo > { System.Reflection.MemberInfo[]}

            //dynamic ret = resultType;


            MethodInfo[] testMethods = client.GetType().GetMethods();
            //TODO: Use common config file for db etc ...
            //ConfigurationManager.ConnectionStrings[1].ConnectionString

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
                            Console.WriteLine("Generating method {0}, return type {1}", m.Name, m.ReturnType.ToString());

                            //Run the stored procedures.
                            sqlCmd.Connection = sqlConn;
                            sqlCmd.CommandType = CommandType.StoredProcedure;

                            //Methods
                            sqlCmd.CommandText = "ag_application_method_ins";
                            sqlCmd.Parameters.Clear();
                            sqlCmd.Parameters.Add(new SqlParameter("application_id", SqlDbType.Int) { Value = 1 });
                            sqlCmd.Parameters.Add(new SqlParameter("application_version_id", SqlDbType.Int) { Value = 1 });
                            sqlCmd.Parameters.Add(new SqlParameter("method_name", SqlDbType.VarChar) { Value = m.Name });
                            sqlCmd.Parameters.Add(new SqlParameter("return_type", SqlDbType.VarChar) { Value = m.ReturnType.ToString() });
                            int application_method_id = (int) sqlCmd.ExecuteScalar();

                            //Parameters
                            using (var sqlParmCmd = new SqlCommand())
                            {
                                sqlParmCmd.Connection = sqlConn;
                                sqlParmCmd.CommandType = CommandType.StoredProcedure;

                                ParameterInfo[] parameterInfo = m.GetParameters();
                                sqlParmCmd.CommandText = "ag_application_method_parameters_ins";
                                
                                foreach (ParameterInfo p in parameterInfo)
                                {
                                    sqlParmCmd.Parameters.Clear();
                                    sqlParmCmd.Parameters.Add(new SqlParameter("application_method_id", SqlDbType.Int) { Value = application_method_id });
                                    sqlParmCmd.Parameters.Add(new SqlParameter("application_method_parameter_name", SqlDbType.VarChar) { Value = p.Name });
                                    sqlParmCmd.Parameters.Add(new SqlParameter("position", SqlDbType.Int) { Value = p.Position });
                                    result = sqlParmCmd.ExecuteNonQuery() > 0;
                                }
                            }
                            //string AssemblyType = "SQLTestAdapter.EAPIServiceReference" + m.ReturnType.ToString();

                        }
                    }

                    sqlConn.Close();
                }
            }
            catch (SqlException ex)
            {
                Debugger.Log(1, "SQL", ex.Message);
            }

        }
    }
}
