using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Xml;
using Microsoft.VisualStudio.TestPlatform.ObjectModel;
using Microsoft.VisualStudio.TestPlatform.ObjectModel.Adapter;
using Microsoft.VisualStudio.TestPlatform.ObjectModel.Logging;
using System.Threading;
using System.Diagnostics;

namespace SQLTestAdapter
{
    [DefaultExecutorUri(SQLTestExecutor.ExecutorUriString)]
    [FileExtension(".xml")]
    public class SQLTestDiscoverer : ITestDiscoverer
    {
        public void DiscoverTests(IEnumerable<string> sources, IDiscoveryContext discoveryContext,
            IMessageLogger logger, ITestCaseDiscoverySink discoverySink)
        {
            Debugger.Launch();
            GetTests(sources, discoverySink);
        }

        public static List<TestCase> GetTests(IEnumerable<string> sources, ITestCaseDiscoverySink discoverySink)
        {
            var con = ConfigurationManager.ConnectionStrings[0].ToString();
            List<TestCase> tests = new List<TestCase>();

            using (SqlConnection myConnection = new SqlConnection("Data Source=LAPTOP-DHCHDQG6\\SQLEXPRESS;Initial Catalog=TestData;Integrated Security=True"))
            {
                string oString = "Select * from Tests";
                SqlCommand oCmd = new SqlCommand(oString, myConnection);
                myConnection.Open();
                foreach (string source in sources)
                {
                    using (SqlDataReader oReader = oCmd.ExecuteReader())
                    {
                        while (oReader.Read())
                        {
                            var testcase = new TestCase(oReader["Name"].ToString(), SQLTestExecutor.ExecutorUri, source)
                            {
                                CodeFilePath = source,
                            };


                            if (discoverySink != null)
                            {
                                discoverySink.SendTestCase(testcase);
                            }
                            else
                            {
                                TestOutcome outcome;
                                Enum.TryParse<TestOutcome>("Passed", out outcome);
                                testcase.SetPropertyValue(TestResultProperties.Outcome, outcome);
                            }
                            tests.Add(testcase);
                        }
                    }
                }
                myConnection.Close();
            }

            return tests;
        }
    }
}