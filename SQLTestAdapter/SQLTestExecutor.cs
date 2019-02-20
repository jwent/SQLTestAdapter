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

namespace SQLTestAdapter
{
    public class FilterParameter
    {
        public string _property;
        public string _value;

        public string property
        {
            get { return _property; }
            set { _property = value; }
        }

        public string value
        {
            get { return _value; }
            set { _value = value; }
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
            //Debugger.Launch();

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

                var returnType = GetServiceMethod(test);

                var parameters = GetServiceMethodParameters();

                dynamic result = RunServiceMethodTest(returnType, parameters);

                StoreTestResult(result);

                bool passed = CheckExpectedResult(result);

                TestResult testResult = new TestResult(test);
                //TODO: set testResult.Messages and test case results.
                /*
                    {TestCase.CodeFilePath}
                    {TestCase.DisplayName}
                    {TestCase.ExecutorUri}
                    {TestCase.FullyQualifiedName}
                    {TestCase.Id}
                    {TestCase.LineNumber}
                    {TestCase.Source}
                    {TestResult.Outcome}

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

            m_sqlConn.Close();
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
            object[] parameters = new object[2];
            parameters[0] = "WePlann";
            parameters[1] = "h9tbMi2n";
            //parameters[2] = "600409";
            System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls11;
            System.ServiceModel.BasicHttpBinding binding = new System.ServiceModel.BasicHttpBinding();
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
                Console.WriteLine("Configuration file:\t{0}", ex.Message);
            }
        }

        private bool CheckExpectedResult(dynamic retData)
        {
            return true;
        }

        public string GetServiceMethod(TestCase methodName)
        {
            //m_testMethod = m_client.GetType().GetMethod(methodName.DisplayName);
            m_testMethod = m_assembly.GetType("Shubert.EApiWS.EAPIClient").GetMethod(methodName.DisplayName);

            string responseTypeStr;

            string oString = "select * from application_method where method_name = @opName";
            SqlCommand sqlCmd = new SqlCommand(oString, m_sqlConn);
            SqlParameter name = sqlCmd.Parameters.Add("@opName", SqlDbType.NVarChar, 15);
            name.SqlValue = methodName.DisplayName;

            using (SqlDataReader oReader = sqlCmd.ExecuteReader())
            {
                oReader.Read();
                m_methodId = oReader["application_method_id"] as int?;
                responseTypeStr = oReader["return_type"] as string;
            }

            return responseTypeStr;
        }

        public List<FilterParameter> GetServiceMethodParameters()
        {
            List<FilterParameter> filterParameters = new List<FilterParameter>();
            FilterParameter fp = new FilterParameter();

            string oString = "select * from application_method_parameters where application_method_id = @ID";
            var sqlCmd = new SqlCommand(oString, m_sqlConn);
            SqlParameter id = sqlCmd.Parameters.Add("@ID", SqlDbType.Int);
            id.SqlValue = m_methodId;

            using (SqlDataReader oReader = sqlCmd.ExecuteReader())
            {
                while (oReader.Read())
                {
                    fp.property = oReader["application_method_parameter_name"] as string;
                    fp.value = oReader["value"] as string;
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
            Type filterType = parameterInfo[1].ParameterType;

            //Create instance of the filter type and set the value of it's parameters.
            object methodFilterInput = Activator.CreateInstance(parameterInfo[1].ParameterType);
            
            PropertyInfo property;

            foreach (FilterParameter p in filterParameters)
            {
                property = filterType.GetProperty(p.property);
                property.SetValue(methodFilterInput, p.value);
            }

            var sessionToken = GetSessionToken();

            /*
             * Call the method with token and filter.
             */
            object[] serviceInstanceMethodParameters = new object[2];
            serviceInstanceMethodParameters[0] = sessionToken;
            serviceInstanceMethodParameters[1] = methodFilterInput;

            methodReturnType = m_testMethod.Invoke(m_client, serviceInstanceMethodParameters);

            return methodReturnType;
        }

        public void StoreTestResult(dynamic methodReturnType)
        {
            var oString = "select * from application_method_response_parameters where application_method_id = @ID";
            var sqlCmd = new SqlCommand(oString, m_sqlConn);
            var id = sqlCmd.Parameters.Add("@ID", SqlDbType.Int);
            id.SqlValue = m_methodId;
            string applicationMethodResponseParameterName;

            using (SqlDataReader oReader = sqlCmd.ExecuteReader())
            {
                oReader.Read();
                applicationMethodResponseParameterName = oReader["application_method_response_parameter_name"] as string;
            }

            dynamic datas = methodReturnType.GetType().GetProperty(applicationMethodResponseParameterName).GetValue(methodReturnType, null);

            __debug(methodReturnType, datas);
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
