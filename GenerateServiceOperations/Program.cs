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
            string fileName = @"EAPI.dll";
            Assembly assembly = Assembly.LoadFrom(fileName);
            DataContractResolverShubert dcr = new DataContractResolverShubert(assembly);

            var client = assembly.GetType("Shubert.EApiWS.EAPIClient");
            var methods = client.GetRuntimeMethods();
            
            using (SqlConnection sqlConn = new SqlConnection("Data Source=LAPTOP-DHCHDQG6\\SQLEXPRESS;Initial Catalog=TestAutomation;Integrated Security=True"))
            {
                //Open the database.
                sqlConn.Open();
                var result = false;

                using (var sqlCmd = new SqlCommand())
                {

                }

                sqlConn.Close();
            }

            //Filter out async methods, untestable methods and special cases.
            foreach(MethodInfo m in methods)
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

                //AddTestMethodTypeToTable(m, sqlCmd, sqlConn);

                ParameterInfo[] parameterInfo = m.GetParameters();

                foreach (ParameterInfo p in parameterInfo)
                {
                    if (p.Name == "Toke" || p.Name == "token" || p.Name == "Token")
                        continue;

                    var RunTimeMethods = p.ParameterType.GetRuntimeMethods();
                    var RunTimeProperties = p.ParameterType.GetRuntimeProperties();

                    Type t = assembly.GetType(p.ParameterType.FullName);
                    dcr.serialize(t);

                    foreach (PropertyInfo fi in RunTimeProperties)
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

                    if (returnProp.GetMethod.ReturnParameter.ParameterType.IsArray)
                    {
                        foreach (var responseDataProperty in returnProp.GetMethod.ReturnParameter.ParameterType.GetElementType().GetRuntimeProperties())
                        {
                            Console.WriteLine("\t\t``` {0}", responseDataProperty.Name);
                        }
                    }
                    else
                    {
                        foreach (var responseDataProperty in returnProp.GetMethod.ReturnParameter.ParameterType.GetRuntimeProperties())
                        {
                            Console.WriteLine("\t\t``` {0}", responseDataProperty.Name);
                        }
                    }
                }
            }
        }

        static void GenerateServiceOperationsFromEndpoint()
        {
            System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls11;
            System.ServiceModel.BasicHttpBinding binding = new System.ServiceModel.BasicHttpBinding();
            binding.OpenTimeout = new TimeSpan(0, 5, 0);
            binding.CloseTimeout = new TimeSpan(0, 5, 0);
            binding.SendTimeout = new TimeSpan(0, 5, 0);
            binding.Security.Mode = System.ServiceModel.BasicHttpSecurityMode.Transport;
            binding.Security.Transport.ClientCredentialType = System.ServiceModel.HttpClientCredentialType.None;
            binding.MaxBufferSize = 64000000;
            binding.MaxReceivedMessageSize = 64000000;
            System.ServiceModel.EndpointAddress EndPoint = new System.ServiceModel.EndpointAddress("https://geapi.dqtelecharge.com/EAPI.svc");
            EAPIClient client = new EAPIClient(binding, EndPoint);

            string fileName = @"EAPI.dll";
            Assembly assembly = Assembly.LoadFrom(fileName);
            DataContractResolverShubert dcr = new DataContractResolverShubert(assembly);

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

                            /*if (m.Name.Contains("OfferDetails"))
                                Debugger.Break();*/

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
                                        List<PropertyInfo> dataProperty = new List<PropertyInfo>();

                                        Console.WriteLine("<<< {0}", returnProp.Name);
                                        Console.WriteLine("\t*** {0}", returnProp.GetMethod.ReturnParameter);

                                        sqlRespParmCmd.Parameters.Clear();

                                        /*if (returnProp.Name == "OfferDescription")
                                            Debugger.Break();*/

                                        //TODO:This is where would store types in the database. so application_response_parametername, application_response_type
                                        if (returnProp.GetMethod.ReturnParameter.ParameterType.IsArray)
                                        {
                                            
                                            sqlRespParmCmd.Parameters.Add(new SqlParameter("is_container", SqlDbType.Int) { Value = 1 });

                                            foreach (var returnDataProperty in returnProp.GetMethod.ReturnParameter.ParameterType.GetElementType().GetRuntimeProperties())
                                            {
                                                Console.WriteLine("\t\t``` {0}", returnDataProperty.Name);
                                                dataProperty.Add(returnDataProperty);
                                            }
                                        }
                                        else
                                        {
                                            sqlRespParmCmd.Parameters.Add(new SqlParameter("is_container", SqlDbType.Int) { Value = 0 });

                                            /*foreach (var returnDataProperty in returnProp.GetMethod.ReturnParameter.ParameterType.GetRuntimeProperties())
                                            {
                                                Console.WriteLine("\t\t``` {0}", returnDataProperty.Name);
                                                dataProperty.Add(returnDataProperty);
                                            }*/
                                        }

                                        sqlRespParmCmd.Connection = sqlConn;
                                        sqlRespParmCmd.CommandType = CommandType.StoredProcedure;
                                        sqlRespParmCmd.CommandText = "ag_application_method_response_parameters_ins";
                                        sqlRespParmCmd.Parameters.Add(new SqlParameter("application_method_id", SqlDbType.Int) { Value = application_method_id });
                                        sqlRespParmCmd.Parameters.Add(new SqlParameter("application_method_response_parameter_name", SqlDbType.VarChar) { Value = returnProp.Name });
                                        sqlRespParmCmd.Parameters.Add(new SqlParameter("position", SqlDbType.Int) { Value = 0 });
                                        int application_method_response_id = (int)sqlRespParmCmd.ExecuteScalar();

                                        foreach(var property in dataProperty)
                                        {
                                            AddResponseDataTypeToTable(application_method_response_id, property, sqlCmd, sqlConn);
                                        }
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

                                if (m.Name == "Contacts")
                                    Debugger.Break();

                                /*
                                 * For each method skip the token parameter info.
                                 * This type might have a different name for different APIs so there
                                 * should be a credentials table that has the names of the methods and types 
                                 * that should be skipped.
                                 */
                                foreach (ParameterInfo p in parameterInfo)
                                {
                                    if (p.Name == "Toke" || p.Name == "token" || p.Name == "Token")
                                        continue;

                                    sqlParmCmd.Parameters.Clear();

                                    var RunTimeMethods = p.ParameterType.GetRuntimeMethods();
                                    var RunTimeProperties = p.ParameterType.GetRuntimeProperties();

                                    foreach (PropertyInfo fi in RunTimeProperties)
                                    {
                                        if (fi.PropertyType.FullName.Contains("SQLTestAdapter.EAPIServiceReference.InquireINQUIRE"))
                                        {
                                            Debugger.Break();
                                        }

                                        sqlParmCmd.Parameters.Clear();
                                        Console.WriteLine("... {0}", fi.Name);
                                        sqlParmCmd.Parameters.Add(new SqlParameter("application_method_id", SqlDbType.Int) { Value = application_method_id });
                                        sqlParmCmd.Parameters.Add(new SqlParameter("application_method_name", SqlDbType.VarChar) { Value = m.Name });
                                        sqlParmCmd.Parameters.Add(new SqlParameter("application_method_parameter_name", SqlDbType.VarChar) { Value = fi.Name });
                                        sqlParmCmd.Parameters.Add(new SqlParameter("application_method_parameter_type", SqlDbType.VarChar) { Value = fi.PropertyType.FullName });
                                        sqlParmCmd.Parameters.Add(new SqlParameter("position", SqlDbType.Int) { Value = p.Position });

                                        /*
                                         * Here is how to serialize a struct!
                                         * object serializedType = System.Runtime.Serialization.FormatterServices.GetUninitializedObject(fi.PropertyType.GetElementType());
                                         * json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(serializedType);
                                         * 
                                         */

                                        /*
                                         * Serialize method parameter types for testing the service with actual data.
                                         * Values to be input via a UI.
                                         */
                                        //TODO: DEBUG:
                                        //Just fudge for this test.
                                        //Type t = assembly.GetType(p.ParameterType.FullName);
                                        Type t = assembly.GetType("Shubert.EApiWS." + p.ParameterType.Name);
                                        var xml = dcr.serialize(t);
                                        sqlParmCmd.Parameters.Add(new SqlParameter("value", SqlDbType.NVarChar) { Value = xml });
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
                Debugger.Break();
                Debugger.Log(1, "SQL", ex.Message);
                Console.WriteLine(ex.Message);
            }
        }//GeneratefromEndPoint

        void AddTestMethodTypeToTable(MethodInfo m, SqlCommand sqlCmd, SqlConnection sqlConn)
        {
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
        }

        static void AddResponseDataTypeToTable(int Id, PropertyInfo property, SqlCommand sqlCmd, SqlConnection sqlConn)
        {
            sqlCmd .Parameters.Clear();
            sqlCmd .Connection = sqlConn;
            sqlCmd .CommandType = CommandType.StoredProcedure;
            sqlCmd .CommandText = "ag_application_method_response_data_ins";
            sqlCmd .Parameters.Add(new SqlParameter("application_method_response_id", SqlDbType.Int) { Value = Id });
            sqlCmd .Parameters.Add(new SqlParameter("response_data_parameter_name", SqlDbType.VarChar) { Value = property.Name });
            var method_response_data_id = sqlCmd .ExecuteScalar();
        }                                                
    }
}
