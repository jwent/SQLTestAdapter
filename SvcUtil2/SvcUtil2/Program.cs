using System.Net;
using System.Reflection;

namespace SvcUtil2
{
    class Program
    {
        static void Main(string[] args)
        {
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            // Your SvcUtil path here
            var svcUtilPath = @"C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools\SvcUtil.exe";
            var svcUtilAssembly = Assembly.LoadFile(svcUtilPath);
            svcUtilAssembly.EntryPoint.Invoke(null, new object[] { args });
        }
    }
}