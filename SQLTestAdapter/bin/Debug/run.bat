set VSTEST_RUNNER_DEBUG=0 
vstest.console.exe /Diag:./log.txt /ListTests /TestAdapterPath:. .\Tests\Test.xml 
echo https://github.com/Simply360/tSQLt.NET