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
    [ExtensionUri(SQLTestExecutor.ExecutorUriString)]
    public class SQLTestExecutor : ITestExecutor
    {
        static private SqlConnection m_sqlConn;
        static private EAPIClient m_client;
        private string m_token;
        private string m_endpoint;

        /*
         * Special case: this must be called first since each method required the token to be passed.
         */
        private object[] BuildGetSecurityTokenParameters(MethodInfo signonMethod)
        {
            ParameterInfo[] parameterInfo = signonMethod.GetParameters();
            object[] parameters = new object[parameterInfo.Length];

            foreach (ParameterInfo p in parameterInfo)
            {
                parameters[p.Position] = p.Name;
            }

            //TODO:stored procedure. How to determine login method?
            string oString = "Select * from application_method_parameters where application_method_id = @opName";
            SqlCommand sqlCmd = new SqlCommand(oString, m_sqlConn);
            SqlParameter name = sqlCmd.Parameters.Add("@opName", SqlDbType.NVarChar, 15);
            //name.SqlValue = signonMethod.Name;
            name.SqlValue = 723;

            using (SqlDataReader oReader = sqlCmd.ExecuteReader())
            {
                while (oReader.Read())
                {
                    int.TryParse(oReader["position"].ToString(), out int idx);
                    parameters[idx] = oReader["value"].ToString().Trim();
                }
            }

            return parameters;
        }

        private object[] BuildParameters(int? applicationMethodId)
        {
            List<string> parameters = new List<string>();

            using (var sqlCmd = new SqlCommand())
            {
                sqlCmd.Connection = m_sqlConn;
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.CommandText = "ag_application_method_parameters_sel";
                sqlCmd.Parameters.Add(new SqlParameter("application_method_id", SqlDbType.Int) { Value = applicationMethodId });

                using (SqlDataReader oReader = sqlCmd.ExecuteReader())
                {
                    while (oReader.Read())
                    {
                        //Is there any reason for the parameters to be refelcted out of order or inserted in the incorrect order
                        // in the db? we would have to write a sproc to return the number of parms.
                        //int.TryParse(oReader["position"].ToString(), out int idx);
                        string value = oReader["value"].ToString().Trim();
                        parameters.Add(value);
                    }

                }

                return parameters.ToArray();
            }
        }

        private string GetToken()
        {
            MethodInfo testMethod = m_client.GetType().GetMethod("SignOn");
            var parameters = BuildGetSecurityTokenParameters(testMethod);
            /*
             * Retrieve credentials from database. Signon should not be part of the discovery process
             * since we will always need a token to test so we can assume that this method will exist and we have to call it first. 
             * If the method name changes how are we to know that it is the signon method?
             */
            Type resultType = Type.GetType("SQLTestAdapter.EAPIServiceReference.SignOnResponse");
            dynamic ret = resultType;
            ret = testMethod.Invoke(m_client, parameters);
            //TODO: Use response parameters from sql to determine field name.
            Console.WriteLine("Token:\t{0}", ret.AuthToke.Value);
            m_token = ret.AuthToke.Value;
            return m_token;
        }

        /*
         * Even though we are reflecting service calls from an assembly built by the WSD we still need an endpoint to test.
         */
        private EAPIClient GetServiceClient()
        {
            if (m_client == null)
            {
                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls11;
                System.ServiceModel.BasicHttpBinding binding = new System.ServiceModel.BasicHttpBinding();
                binding.Security.Mode = System.ServiceModel.BasicHttpSecurityMode.Transport;
                binding.Security.Transport.ClientCredentialType = System.ServiceModel.HttpClientCredentialType.None;
                binding.MaxBufferSize = 64000000;
                binding.MaxReceivedMessageSize = 64000000;
                //TODO: Get endpoint from config file. Or maybe test context from DB.
                System.ServiceModel.EndpointAddress EndPoint = new System.ServiceModel.EndpointAddress("https://geapi.dqtelecharge.com/EAPI.svc");
                m_client = new EAPIClient(binding, EndPoint);
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
                //m_endpoint = config.ConnectionStrings.ConnectionStrings["SQLTestAdapter.Properties.Settings.APIEndpoint"].ConnectionString;
            }
            catch(Exception ex)
            {
                Console.WriteLine("Configuration file:\t{0}", ex.Message);
            }
        }

        /*
        private string GetResponseType(int applicationMethodId)
        {
            string oString = "select * from application_method_parameters where application_method_id = @ID";
            SqlCommand sqlCmd = new SqlCommand(oString, m_sqlConn);
            SqlParameter id = sqlCmd.Parameters.Add("@ID", SqlDbType.Int);
            id.SqlValue = applicationMethodId;

            using (SqlDataReader oReader = sqlCmd.ExecuteReader())
            {
                oReader.Read();
                applicationMethodId = oReader["application_method_id"] as int?;
            }

            return responseType;
        }
        */

        private bool CheckExpectedResult(dynamic retData)
        {
            return true;
        }

        public void RunTests(IEnumerable<string> sources, IRunContext runContext, IFrameworkHandle frameworkHandle)
        {
            Debugger.Launch();

            IEnumerable <TestCase> tests = SQLTestDiscoverer.GetTests(sources, null);

            GetConnectionStringAndTestEndPoint();
            GetServiceClient();
            m_sqlConn.Open();
            GetToken();
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

                //Credentials for APIs will vary so is there a table with instructions per API?
                //Also there is no guarantee that the method for retrieving a token will be first in the table.
                MethodInfo testMethod = m_client.GetType().GetMethod(test.DisplayName);
                //var parameters = BuildParameters(testMethod);

                string oString = "select * from application_method where method_name = @opName";
                SqlCommand sqlCmd = new SqlCommand(oString, m_sqlConn);
                SqlParameter name = sqlCmd.Parameters.Add("@opName", SqlDbType.NVarChar, 15);
                name.SqlValue = test.DisplayName;

                //Get method id to query input parameters for the method.
                int? applicationMethodId;
                string responseType;

                using (SqlDataReader oReader = sqlCmd.ExecuteReader())
                {
                    oReader.Read();
                    applicationMethodId = oReader["application_method_id"] as int?;
                    //responseType = oReader["response_type"] as string;
                }

                oString = "select * from application_method_parameters where application_method_id = @ID";
                sqlCmd = new SqlCommand(oString, m_sqlConn);
                SqlParameter id = sqlCmd.Parameters.Add("@ID", SqlDbType.Int);
                id.SqlValue = applicationMethodId;

                var parameters = BuildParameters(applicationMethodId);
                //Type resultType = Type.GetType(responseType);
                Type resultType = Type.GetType("SQLTestAdapter.EAPIServiceReference.SignOnResponse");

                dynamic retData = resultType;
                retData = testMethod.Invoke(m_client, parameters);

                bool result = CheckExpectedResult(retData);

                Debugger.Break();

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

        public void Cancel()
        {
            m_cancelled = true;
        }

        public const string ExecutorUriString = "executor://SQLTestExecutor/v1";
        public static readonly Uri ExecutorUri = new Uri(SQLTestExecutor.ExecutorUriString);
        private bool m_cancelled;
    }
}
