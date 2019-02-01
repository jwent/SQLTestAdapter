using System;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestPlatform.ObjectModel;
using Microsoft.VisualStudio.TestPlatform.ObjectModel.Adapter;
using System.Diagnostics;
using SQLTestAdapter.EAPIServiceReference;
using System.Security.Cryptography.X509Certificates;
using System.Configuration;
using System.ServiceModel.Configuration;
using System.Reflection;

namespace SQLTestAdapter
{
    [ExtensionUri(SQLTestExecutor.ExecutorUriString)]
    public class SQLTestExecutor : ITestExecutor
    {
        public void RunTests(IEnumerable<string> sources, IRunContext runContext,
            IFrameworkHandle frameworkHandle)
        {
            //Debugger.Launch();
            IEnumerable<TestCase> tests = SQLTestDiscoverer.GetTests(sources, null);
            RunTests(tests, runContext, frameworkHandle);
        }

        public void RunTests(IEnumerable<TestCase> tests, IRunContext runContext,
               IFrameworkHandle frameworkHandle)
        {
            m_cancelled = false;

            foreach (TestCase test in tests)
            {
                if (m_cancelled) break;

                //TODO: Perform tests.

                Console.WriteLine("Running test:\t{0}", test.DisplayName);

                Debugger.Launch();

                ExeConfigurationFileMap configMap = new ExeConfigurationFileMap();
                configMap.ExeConfigFilename = @"SQLTestAdapter.dll.config";
                Configuration config = ConfigurationManager.OpenMappedExeConfiguration(configMap, ConfigurationUserLevel.None);
                var connection = config.ConnectionStrings.ConnectionStrings["SQLTestAdapter.Properties.Settings.TestDataConnectionString"].ConnectionString;

                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls11;
                System.ServiceModel.BasicHttpBinding binding = new System.ServiceModel.BasicHttpBinding();
                binding.Security.Mode = System.ServiceModel.BasicHttpSecurityMode.Transport;
                binding.Security.Transport.ClientCredentialType = System.ServiceModel.HttpClientCredentialType.None;
                binding.MaxBufferSize = 64000000;
                binding.MaxReceivedMessageSize = 64000000;
                System.ServiceModel.EndpointAddress EndPoint = new System.ServiceModel.EndpointAddress("https://geapi.dqtelecharge.com/EAPI.svc");
                EAPIClient client = new EAPIClient(binding, EndPoint);

                Debugger.Break();
                MethodInfo testMethod = client.GetType().GetMethod(test.DisplayName);
                ParameterInfo[] parameterInfo = testMethod.GetParameters();
                object[] parameters = new object[parameterInfo.Length];

                //TODO: Here we need to use the db to query parameter values.
                parameters[0] = "WePlann";
                parameters[1] = "h9tbMi2n";
                parameters[2] = "600409";

                //TODO: Here we have to determine the return type and store the results back into the db.
                // In this case it would be the auth token. The return type class would be stored in the db?
                Type resultType = Type.GetType("SQLTestAdapter.EAPIServiceReference.SignOnResponse");
                dynamic ret = resultType;
                ret = testMethod.Invoke(client, parameters);

                //SignOnResponse ret = client.SignOn("WePlann", "h9tbMi2n", "600409");
                Console.WriteLine("Token:\t{0}", ret.AuthToke.Value);

                TestResult testResult = new TestResult(test);

                testResult.Outcome = (TestOutcome)test.GetPropertyValue(TestResultProperties.Outcome);
                frameworkHandle.RecordResult(testResult);
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
