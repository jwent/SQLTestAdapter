using System;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestPlatform.ObjectModel;
using Microsoft.VisualStudio.TestPlatform.ObjectModel.Adapter;
using System.Diagnostics;
using SQLTestAdapter.EAPIServiceReference;
using System.Security.Cryptography.X509Certificates;
using System.Configuration;
using System.ServiceModel.Configuration;

namespace SQLTestAdapter
{
    [ExtensionUri(SQLTestExecutor.ExecutorUriString)]
    public class SQLTestExecutor : ITestExecutor
    {
        public void RunTests(IEnumerable<string> sources, IRunContext runContext,
            IFrameworkHandle frameworkHandle)
        {
            Debugger.Launch();
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
                Debugger.Break();
                /*
                var binding = new System.ServiceModel.BasicHttpsBinding();
                binding.Security.Mode = System.ServiceModel.BasicHttpsSecurityMode.Transport;
                binding.Security.Transport.ClientCredentialType = System.ServiceModel.HttpClientCredentialType.None;
                var EndPoint = new System.ServiceModel.EndpointAddress("https://geapi.dqtelecharge.com/EAPI.svc");
                var client = new EAPIClient(binding, EndPoint);
                */
                //client.ClientCredentials.ClientCertificate.SetCertificate(StoreLocation.CurrentUser, StoreName.Root, X509FindType.FindBySubjectName, "*.dqtelecharge.com");

                //Configuration appConfig = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.PerUserRoamingAndLocal);
                //ServiceModelSectionGroup serviceModel = ServiceModelSectionGroup.GetSectionGroup(appConfig);
                //ClientSection clientSection = serviceModel.Client;
                //var el = clientSection.Endpoints[0];
                //return el.Address.ToString();
                //var EndPoint = serviceModel.Client.Endpoints;

                System.ServiceModel.BasicHttpBinding binding = new System.ServiceModel.BasicHttpBinding();
                binding.Security.Mode = System.ServiceModel.BasicHttpSecurityMode.Transport;
                binding.Security.Transport.ClientCredentialType = System.ServiceModel.HttpClientCredentialType.None;
                binding.MaxBufferSize = 64000000;
                binding.MaxReceivedMessageSize = 64000000;
                System.ServiceModel.EndpointAddress EndPoint = new System.ServiceModel.EndpointAddress("https://geapi.dqtelecharge.com/EAPI.svc");
                EAPIClient client = new EAPIClient(binding, EndPoint);
                //var client = new EAPIClient("EAPIServiceReference.IEAPI");
                //var client = new EAPIClient();

                SignOnResponse ret = client.SignOn("WePlann", "h9tbMi2n", "600409");

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
