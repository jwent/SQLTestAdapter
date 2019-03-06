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
using System.Runtime.Remoting;
using System.Web.Script.Serialization;

namespace SQLTestAdapter
{
    public class FilterParameter
    {
        public string _property;
        public string _type;
        public dynamic _value;

        public string property
        {
            get { return _property; }
            set { _property = value; }
        }

        public string type
        {
            get { return _type; }
            set { _type = value; }
        }

        public dynamic value
        {
            get { return _value; }
            set { _value = value; }
        }
    }

    public class DataContainer
    {
        public int? _id;
        public string _type;
        public int? _is_container;

        public string type
        {
            get { return _type; }
            set { _type = value; }
        }

        public int? isContainer
        {
            get { return _is_container; }
            set { _is_container = value; }
        }
        public int? id
        {
            get { return _id; }
            set { _id = value; }
        }
    }

    [ExtensionUri(SQLTestExecutor.ExecutorUriString)]
    public class SQLTestExecutor : ITestExecutor
    {
        static private SqlConnection m_sqlConn;

        /*
            Use a connected service.
            static private EAPIClient m_client;
         */
        

        static private object m_client;

        static EAPIClient m_ConnectedService = null;

        private string m_token;

        private dynamic m_session_token;

        private string m_endpoint;

        private int? m_methodId;

        private Assembly m_assembly;

        private MethodInfo m_testMethod;

        public void RunTests(IEnumerable<string> sources, IRunContext runContext, IFrameworkHandle frameworkHandle)
        {
            Debugger.Launch();

            IEnumerable<TestCase> tests = SQLTestDiscoverer.GetTests(sources, null);

            //TODO: Load from local dir.
            string fileName = @"EAPI.dll";
            m_assembly = Assembly.LoadFrom(fileName);

            GetConnectionStringAndTestEndPoint();

            GetServiceClientFromLoadedAssembly();

            m_sqlConn.Open();

            m_token = GetToken();

            RunTests(tests, runContext, frameworkHandle);

            m_sqlConn.Close();
        }

        public void RunTests(IEnumerable<TestCase> tests, IRunContext runContext, IFrameworkHandle frameworkHandle)
        {
            m_cancelled = false;

            foreach (TestCase test in tests)
            {
                if (m_cancelled) break;

                Console.WriteLine("Running test:\t{0}", test.DisplayName);

                /*if (test.DisplayName == "OfferDetails")
                    Debugger.Break();*/

                var returnType = GetServiceMethod(test);

                if (returnType == null)
                {
                    continue;
                }

                var parameters = GetServiceMethodParameters();

                dynamic result = RunServiceMethodTest(returnType, parameters);

                //If there is an error or no data was returned due to invalid input parameters
                //log result in test run table TODO: build test run table and allow users to choose tests for run.

                if (result == null)
                {
                    Debugger.Break();
                    continue;
                }

                /*((Shubert.EApiWS.BaseResponse)result).IsEmpty
                ((Shubert.EApiWS.BaseResponse)result).Response.Success
                ((Shubert.EApiWS.BaseResponse)result).Response.Error*/

                if (result.Response.Success)
                {
                    test.SetPropertyValue(TestResultProperties.Outcome, TestOutcome.Passed);
                    StoreTestResult(result);
                }
                else
                {
                    test.SetPropertyValue(TestResultProperties.Outcome, TestOutcome.Failed);
                }

                if (result.Response.Success && result.IsEmpty)
                {
                    test.SetPropertyValue(TestResultProperties.Outcome, TestOutcome.NotFound);
                }

                //TODO: bool passed = CheckExpectedResult(result);

                TestResult testResult = new TestResult(test);

                //TODO: set testResult.Messages and test case results.
                /*
                 *
                 */

                /*Console.WriteLine("{0}", test.CodeFilePath);
                Console.WriteLine("{0}", test.DisplayName);
                Console.WriteLine("{0}", test.ExecutorUri);
                Console.WriteLine("{0}", test.FullyQualifiedName);
                Console.WriteLine("{0}", test.Id);
                Console.WriteLine("{0}", test.LineNumber);
                Console.WriteLine("{0}", test.Source);*/

                


                Console.WriteLine("{0}", testResult.Outcome);
                /*
                    public enum UnitTestOutcome
                    
                    Aborted	6	        Test was aborted by the user.
                    Error	4	        There was a system error while we were trying to execute a test.
                    Failed	0	        Test was executed, but there were issues. Issues may involve exceptions or failed assertions.
                    Inconclusive 1      Test has completed, but we can't say if it passed or failed. May be used for aborted tests.
                    InProgress	3	    Test is currently executing.
                    NotRunnable	8	    Test cannot be executed.
                    Passed	2	        Test was executed without any issues.
                    Timeout	5	        The test timed out.
                    Unknown	7	
                */
                testResult.Outcome = (TestOutcome)test.GetPropertyValue(TestResultProperties.Outcome);
                frameworkHandle.RecordResult(testResult);
            }

            //m_sqlConn.Close();
        }

        /*
         * Special case: this must be called first since each method required the token to be passed.
         */
        private object[] BuildGetSecurityTokenParameters(MethodInfo signonMethod)
        {
            ParameterInfo[] parameterInfo = signonMethod.GetParameters();
            object[] parameters = new object[parameterInfo.Length];

            return parameters;
        }

        private string GetToken()
        {
            //SignOnResponse ret = m_client.SignOn("WePlann", "h9tbMi2n", "600409");
            MethodInfo signOnMethod = m_assembly.GetType("Shubert.EApiWS.EAPIClient").GetMethod("SignOn");

            //So if I generate a DLL from the endpoint signon has 3 parameters - 
            object[] parameters = new object[3];
            parameters[0] = "WePlann";
            parameters[1] = "h9tbMi2n";
            parameters[2] = "600409";

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
            //m_client = new EAPIClient(binding, EndPoint);

            object[] clientparms = new object[2];
            clientparms[0] = binding;
            clientparms[1] = EndPoint;

            Type t = m_assembly.GetType("Shubert.EApiWS.EAPIClient");
            object methodInstance = Activator.CreateInstance(t, clientparms);
            //methodReturnType = m_testMethod.Invoke(methodInstance, serviceInstanceMethodParameters);

            dynamic ret = signOnMethod.Invoke(methodInstance, parameters);
            return ret.AuthToke.Value;
        }

        private dynamic GetSessionTokenConnectedService()
        {
            SQLTestAdapter.EAPIServiceReference.AuthToken token = new SQLTestAdapter.EAPIServiceReference.AuthToken();
            token.Value = m_token;

            SQLTestAdapter.EAPIServiceReference.IpAddress ipAddress = new SQLTestAdapter.EAPIServiceReference.IpAddress();
            ipAddress.Value = "192.168.55.101";

            dynamic sessionResponse = m_ConnectedService.StartNewSession(token, null, ipAddress);

            return sessionResponse.SessionToke;
        }
        /*
        * Get the session token.
        */
        private dynamic GetSessionToken()
        {
            if (m_session_token != null)
            {
                return m_session_token;
            }
            else
            {
                Type AuthTokenType = m_assembly.GetType("Shubert.EApiWS.AuthToken");
                object AuthTokenInstance = Activator.CreateInstance(AuthTokenType);
                PropertyInfo AuthTokenProperty = AuthTokenInstance.GetType().GetProperty("Value");
                AuthTokenProperty.SetValue(AuthTokenInstance, m_token);

                Type IpAddressType = m_assembly.GetType("Shubert.EApiWS.IpAddress");
                object IpAddressInstance = Activator.CreateInstance(IpAddressType);
                PropertyInfo IpAddressProperty = IpAddressInstance.GetType().GetProperty("Value");
                //TODO: Set in config.
                IpAddressProperty.SetValue(IpAddressInstance, "192.168.55.101");

                MethodInfo StartNewSessionMethod = m_assembly.GetType("Shubert.EApiWS.EAPIClient").GetMethod("StartNewSession");

                object[] sessionParameters = new object[3];
                sessionParameters[0] = AuthTokenInstance;
                sessionParameters[1] = null;
                sessionParameters[2] = IpAddressInstance;

                dynamic sessionToken = StartNewSessionMethod.Invoke(m_client, sessionParameters);
                m_session_token = sessionToken.SessionToke;

                return m_session_token;
            }
        }

        /*
         * Use a Connected Service Reference.
         */

        private EAPIClient GetServiceClient()
        {
            if (m_ConnectedService == null)
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
                //TODO: Get endpoint from config file. Or maybe test context from DB.
                System.ServiceModel.EndpointAddress EndPoint = new System.ServiceModel.EndpointAddress("https://geapi.dqtelecharge.com/EAPI.svc");
                m_ConnectedService = new EAPIClient(binding, EndPoint);
                return m_ConnectedService;
            }
            else
            {
                return m_ConnectedService;
            }
        }

        /*
         * Use a loaded assembly.
         */
        private object GetServiceClientFromLoadedAssembly()
        {
            if (m_client == null)
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

                object[] serviceBindingParameters = new object[2];
                serviceBindingParameters[0] = binding;
                serviceBindingParameters[1] = EndPoint;

                Type t = m_assembly.GetType("Shubert.EApiWS.EAPIClient");
                m_client = Activator.CreateInstance(t, serviceBindingParameters);

                return m_client;
            }
            else
            {
                return m_client;
            }

        }

        private void GetConnectionStringAndTestEndPoint()
        {
            ExeConfigurationFileMap configMap = new ExeConfigurationFileMap();
            configMap.ExeConfigFilename = @"SQLTestAdapter.dll.config";

            try
            {
                Configuration config = ConfigurationManager.OpenMappedExeConfiguration(configMap, ConfigurationUserLevel.None);
                string connection = config.ConnectionStrings.ConnectionStrings["SQLTestAdapter.Properties.Settings.TestDataConnectionString"].ConnectionString;
                m_sqlConn = new SqlConnection(connection);
            }
            catch(Exception ex)
            {
                Console.WriteLine("Something:\t{0}", ex.Message);
                if (ex.Message == "Invalid attempt to read when no data is present.")
                    Debugger.Break();

            }
        }

        private bool CheckExpectedResult(dynamic retData)
        {

            var Response = retData.GetType().GetProperty("Response").GetValue(retData, null);

        //TODO: Log error in db.
/*
-		retData.GetType().GetProperty("Response").GetValue(retData, null)	{Shubert.EApiWS.ResponseMessage}	dynamic {Shubert.EApiWS.ResponseMessage}
		Error	"\r\nInvalid EapiShowId"	string
+		ExtensionData	{System.Runtime.Serialization.ExtensionDataObject}	System.Runtime.Serialization.ExtensionDataObject
		Success	false	bool
+		Non-Public members		
*/

            if (Response.Success == true)
                return true;
            else
                return false;
        }

        public string GetServiceMethod(TestCase methodName)
        {
            //m_testMethod = m_client.GetType().GetMethod(methodName.DisplayName);
            m_testMethod = m_assembly.GetType("Shubert.EApiWS.EAPIClient").GetMethod(methodName.DisplayName);

            string responseTypeStr;



            var sqlProc = new SqlCommand();
            sqlProc.Connection = m_sqlConn;
            sqlProc.CommandType = CommandType.StoredProcedure;
            sqlProc.CommandText = "ag_application_method_sel";
            sqlProc.Parameters.Add(new SqlParameter("application_method_name", SqlDbType.NVarChar) { Value = methodName.DisplayName });
            //var result = sqlProc.ExecuteNonQuery();

            //string oString = "select * from application_method where method_name = @opName";
            //SqlCommand sqlCmd = new SqlCommand(oString, m_sqlConn);
            //SqlParameter name = sqlCmd.Parameters.Add("@opName", SqlDbType.NVarChar, 15);
            //name.SqlValue = methodName.DisplayName;
            //var sql = sqlCmd.CommandText;
            //var result = sqlProc.ExecuteNonQuery();

            if (methodName.DisplayName == "NonPerformanceProducts")
                Debugger.Break();

            using (SqlDataReader oReader = sqlProc.ExecuteReader())
            {
                try
                {
                    var isRead = oReader.Read();
                    m_methodId = oReader["application_method_id"] as int?;
                    responseTypeStr = oReader["return_type"] as string;
                    return responseTypeStr;
                }
                catch (SqlException ex)
                {
                    Debugger.Log(1, "SQL", ex.Message);
                    Console.WriteLine(ex.Message);
                    Debugger.Break();
                    return null;
                }
                catch (Exception ex)
                {
                    Debugger.Log(1, "SQL", ex.Message);
                    Console.WriteLine(ex.Message);
                    if (ex.Message == "Invalid attempt to read when no data is present.")
                        Debugger.Break();
                    return null;
                }
            }

            return responseTypeStr;
        }

        public List<FilterParameter> GetServiceMethodParameters()
        {
            List<FilterParameter> filterParameters = new List<FilterParameter>();

            string oString = "select * from application_method_parameters where application_method_id = @ID";
            var sqlCmd = new SqlCommand(oString, m_sqlConn);
            SqlParameter id = sqlCmd.Parameters.Add("@ID", SqlDbType.Int);
            id.SqlValue = m_methodId;

            using (SqlDataReader oReader = sqlCmd.ExecuteReader())
            {
                while (oReader.Read())
                {
                    FilterParameter fp = new FilterParameter();
                    fp.property = oReader["application_method_parameter_name"] as string;
                    //TODO:in Generate create type field - create <int> for instance from type so can set correct parameter.
                    //fp.value = oReader["value"] as string;
                    fp.type = oReader["application_method_parameter_type"] as string;
                    fp.value = oReader["value"];
                    filterParameters.Add(fp);
                }
            }

            return filterParameters;
        }

        public dynamic RunServiceMethodTest(string responseTypeStr, List<FilterParameter> filterParameters)
        {
            dynamic methodReturnType = m_assembly.GetType("Shubert.EApiWS." + responseTypeStr);

            /*
             * All methods in versions of the EAPI take a session token as the first parameter and an input filter.
             * method call parameter structure must be programmatically determined here by an API type in the database.
             * - method(token, filter)
             */
            ParameterInfo[] parameterInfo = m_testMethod.GetParameters();

            /*
             * If just one parameter then probably not a regular service method.
             */
            if (parameterInfo.Length < 2)
                return null;

            Type filterType = parameterInfo[1].ParameterType;

            //Create instance of the filter type and set the value of it's parameters.
            object methodFilterInput = Activator.CreateInstance(parameterInfo[1].ParameterType);
            
            PropertyInfo property;

            foreach (FilterParameter p in filterParameters)
            {
                //Type t = m_assembly.GetType("Shubert.EApiWS.EAPIClient");
                //((System.Reflection.RuntimePropertyInfo)property).PropertyType = { Name = "ExtensionDataObject" FullName = "System.Runtime.Serialization.ExtensionDataObject"}

                property = filterType.GetProperty(p.property);

                /*if (property.PropertyType.FullName == "System.Runtime.Serialization.ExtensionDataObject")
                {
                    Debugger.Break();
                    //continue;
                }*/

                //if (property.PropertyType.Name != p.value.GetType().Name)//always string duh

                if (p.type == "System.String")
                    property.SetValue(methodFilterInput, p.value);
                if (p.type == "System.Int32")
                    property.SetValue(methodFilterInput, p.value.ToString());

                if (p.type != "System.String" && p.type != "System.Int32")
                {
                    //string do not have a parameterless constructor.
                    //if (p.value.GetType().Name == "DBNull")
                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    //object pType = Activator.CreateInstance(property.PropertyType);
                    Type pType = property.PropertyType;
                    //Type pType = m_assembly.GetType(p.type);
                    object serializedType = System.Runtime.Serialization.FormatterServices.GetUninitializedObject(pType);
                    var dType = serializer.DeserializeObject(p.value);
                    //var j = serializer.Deserialize<tt>(p.value);
                    property.SetValue(methodFilterInput, serializedType);
                    //Console.WriteLine("Unable to set type: {0}", p.value.GetType().Name);
                    //Debugger.Break();
                }

                //
            }

            var sessionToken = GetSessionToken();

            /*
             * Call the method with token and filter.
             */
            object[] serviceInstanceMethodParameters = new object[2];
            serviceInstanceMethodParameters[0] = sessionToken;
            serviceInstanceMethodParameters[1] = methodFilterInput;

            try
            {
                methodReturnType = m_testMethod.Invoke(m_client, serviceInstanceMethodParameters);
            }
            catch (Exception ex)
            {
                Console.WriteLine("{0}", ex.Message);
                if (ex.Message == "Invalid attempt to read when no data is present.")
                    Debugger.Break();

            }


            return methodReturnType;
        }

        public void StoreTestResult(dynamic methodReturnType)
        {
            var oString = "select * from application_method_response_parameters where application_method_id = @ID";
            var sqlCmd = new SqlCommand(oString, m_sqlConn);
            var id = sqlCmd.Parameters.Add("@ID", SqlDbType.Int);
            id.SqlValue = m_methodId;

            List<DataContainer> applicationMethodResponseParameterName = new List<DataContainer>();

            using (SqlDataReader oReader = sqlCmd.ExecuteReader())
            {
                while (oReader.Read())
                {
                    DataContainer dataContainer = new DataContainer();
                    dataContainer.id = oReader["application_method_response_id"] as int?;
                    dataContainer.type = oReader["application_method_response_parameter_name"] as string;
                    dataContainer.isContainer = oReader["is_container"] as int?;
                    applicationMethodResponseParameterName.Add(dataContainer);
                }
                
            }

            foreach (DataContainer p in applicationMethodResponseParameterName)
            {
                dynamic data = methodReturnType.GetType().GetProperty(p.type).GetValue(methodReturnType, null);

                if (data == null)
                    continue;

                try
                {
                    if (p.isContainer == 1)
                    {
                        var dataContainerProperties = data.GetType().GetElementType().GetProperties();

                        foreach (PropertyInfo dcp in dataContainerProperties)
                        {
                            var value = dcp.GetValue(data[0]); //TODO: Store all records.
                            var valueJSON = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(value);

                            using (var sqlProc = new SqlCommand())
                            {
                                sqlProc.Connection = m_sqlConn;
                                sqlProc.CommandType = CommandType.StoredProcedure;
                                sqlProc.CommandText = "ag_test_response_data_upd";
                                sqlProc.Parameters.Add(new SqlParameter("application_method_response_id", SqlDbType.Int) { Value = p.id });
                                sqlProc.Parameters.Add(new SqlParameter("response_data_parameter_name", SqlDbType.NVarChar) { Value = dcp.Name });
                                sqlProc.Parameters.Add(new SqlParameter("value", SqlDbType.NVarChar) { Value = valueJSON });
                                var result = sqlProc.ExecuteNonQuery();
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("{0}", ex.Message);
                    if (ex.Message == "Invalid attempt to read when no data is present.")
                        Debugger.Break();

                }

                var json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(data);
                /*
                 * Store results as JSON
                 */
                //Console.WriteLine("{0}", json);

                using (var sqlProc = new SqlCommand())
                {
                    sqlProc.Connection = m_sqlConn;
                    sqlProc.CommandType = CommandType.StoredProcedure;
                    sqlProc.CommandText = "ag_test_response_parameter_upd";
                    sqlProc.Parameters.Add(new SqlParameter("application_method_id", SqlDbType.Int) { Value = m_methodId });
                    sqlProc.Parameters.Add(new SqlParameter("application_method_response_parameter_name", SqlDbType.NVarChar) { Value = p.type });
                    sqlProc.Parameters.Add(new SqlParameter("value", SqlDbType.NVarChar) { Value = json });
                    var result = sqlProc.ExecuteNonQuery();
                }
            }

            //__debug(methodReturnType, data);
        }

        private void __debug(dynamic methodReturnType, dynamic datas)
        {
            /*
            * How to access properties.
            * If we were using the connected service we could use an actual compiled type.
            * typeof(SQLTestAdapter.EAPIServiceReference.ShowsResponse).ToString()
            */
            if ("Shubert.EApiWS.ShowsResponse" == methodReturnType.GetType().ToString())
            {
                foreach (dynamic data in datas)
                {
                    Console.WriteLine(data.GetType().GetProperty("ShowName").GetValue(data, null));
                }
            }
        }

        public void Cancel()
        {
            m_cancelled = true;
        }

        public const string ExecutorUriString = "executor://SQLTestExecutor/v1";
        public static readonly Uri ExecutorUri = new Uri(SQLTestExecutor.ExecutorUriString);
        private bool m_cancelled;
    }
}
