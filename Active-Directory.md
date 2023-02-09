
#### Get all DCs in forest
```powershell
(Get-ADForest).Domains | % {(Get-ADDomain -Server $_).Replicadirectoryservers} | sort
```

