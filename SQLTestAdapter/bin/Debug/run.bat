REM set VSTEST_RUNNER_DEBUG=0 
REM vstest.console.exe /Diag:./log.txt /ListTests /TestAdapterPath:. dummy.tests.xml
vstest.console.exe /TestAdapterPath:. dummy.tests.xml
