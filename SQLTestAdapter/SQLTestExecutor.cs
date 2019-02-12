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
        private SqlConnection m_conn;

        private object[] BuildParameters(MethodInfo testMethod)
        {
            
            ParameterInfo[] parameterInfo = testMethod.GetParameters();
            object[] parameters = new object[parameterInfo.Length];

            foreach (ParameterInfo p in parameterInfo)
            {
                parameters[p.Position] = p.Name;
            }

            return parameters;
        }

        public void RunTests(IEnumerable<string> sources, IRunContext runContext,
            IFrameworkHandle frameworkHandle)
        {
            Debugger.Launch();
            ExeConfigurationFileMap configMap = new ExeConfigurationFileMap();
            configMap.ExeConfigFilename = @"SQLTestAdapter.dll.config";
            Configuration config = ConfigurationManager.OpenMappedExeConfiguration(configMap, ConfigurationUserLevel.None);
            string connection = config.ConnectionStrings.ConnectionStrings["SQLTestAdapter.Properties.Settings.TestDataConnectionString"].ConnectionString;
            m_conn = new SqlConnection(connection);

            IEnumerable <TestCase> tests = SQLTestDiscoverer.GetTests(sources, null);
            RunTests(tests, runContext, frameworkHandle);
        }

        public void RunTests(IEnumerable<TestCase> tests, IRunContext runContext,
               IFrameworkHandle frameworkHandle)
        {
            m_cancelled = false;

            foreach (TestCase test in tests)
            {
                if (m_cancelled) break;

                Console.WriteLine("Running test:\t{0}", test.DisplayName);

                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls11;
                System.ServiceModel.BasicHttpBinding binding = new System.ServiceModel.BasicHttpBinding();
                binding.Security.Mode = System.ServiceModel.BasicHttpSecurityMode.Transport;
                binding.Security.Transport.ClientCredentialType = System.ServiceModel.HttpClientCredentialType.None;
                binding.MaxBufferSize = 64000000;
                binding.MaxReceivedMessageSize = 64000000;
                System.ServiceModel.EndpointAddress EndPoint = new System.ServiceModel.EndpointAddress("https://geapi.dqtelecharge.com/EAPI.svc");
                EAPIClient client = new EAPIClient(binding, EndPoint);

                //TestSuite


                MethodInfo testMethod = client.GetType().GetMethod("SignOn");
                var parameters = BuildParameters(testMethod);

                this.m_conn.Open();
                Debugger.Break();
                string oString = "Select * from application_method where method_name = @opName";
                SqlCommand oCmd = new SqlCommand(oString, this.m_conn);
                SqlParameter name = oCmd.Parameters.Add("@opName", SqlDbType.NVarChar, 15);
                name.SqlValue = test.DisplayName;
                int? appMethodId;

                using (SqlDataReader oReader = oCmd.ExecuteReader())
                {
                    oReader.Read();
                    appMethodId = oReader["application_method_id"] as int?;
                }

                oString = "select * from application_method_parameters where application_method_id = @ID";
                oCmd = new SqlCommand(oString, this.m_conn);
                SqlParameter id = oCmd.Parameters.Add("@ID", SqlDbType.Int);
                id.SqlValue = appMethodId;
                using (SqlDataReader oReader = oCmd.ExecuteReader())
                {
                    while (oReader.Read())
                    {
                        int.TryParse(oReader["Position"].ToString(), out int idx);
                        parameters[idx] = oReader["Value"].ToString().Trim();
                    }
                }        
                
                Type resultType = Type.GetType("SQLTestAdapter.EAPIServiceReference.SignOnResponse");
                dynamic ret = resultType;
                ret = testMethod.Invoke(client, parameters);

                Console.WriteLine("Token:\t{0}", ret.AuthToke.Value);

                TestResult testResult = new TestResult(test);
                testResult.Outcome = (TestOutcome)test.GetPropertyValue(TestResultProperties.Outcome);
                frameworkHandle.RecordResult(testResult);
            }

            this.m_conn.Close();
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
