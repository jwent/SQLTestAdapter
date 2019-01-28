using System;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestPlatform.ObjectModel;
using Microsoft.VisualStudio.TestPlatform.ObjectModel.Adapter;
using System.Diagnostics;

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
            Debugger.Break();
            m_cancelled = false;

            foreach (TestCase test in tests)
            {
                if (m_cancelled) break;

                //TODO: Perform tests.
                Console.WriteLine("Running test:\t", test.DisplayName);

                var testResult = new TestResult(test);

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
