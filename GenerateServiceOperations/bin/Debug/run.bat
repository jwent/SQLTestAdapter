SvcUtil2.exe /t:metadata https://geapi.dqtelecharge.com/EAPI.svc
SvcUtil2.exe /dataContractOnly https://geapi.dqtelecharge.com/EAPI.svc
svcutil.exe /n:*,Shubert.EApiWS EAPI.wsdl
csc -t:library EAPI.cs
csc -t:library -r:Shubert.Ticketing.dll EAPI.cs

