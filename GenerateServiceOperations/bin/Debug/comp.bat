.\svcutil2 /n:*,Shubert.EApiWS https://geapi.dqtelecharge.com/EAPI.svc
.\csc -t:library EAPI.cs
copy EAPI.dll \Users\Jeremy\Code\SQLTestAdapterDev\SQLTestAdapter\SQLTestAdapter\bin\Debug
