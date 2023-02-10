#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"

Stop-Service -Name "CcmExec" -Force
Remove-Item -Path "C:\Windows\SMSCFG.ini" -Force
Get-ChildItem -Path Cert:\LocalMachine\SMS\ | Remove-Item
Get-WmiObject -Namespace 'root\CCM\invagt' -Class "inventoryActionStatus" -Filter 'InventoryActionID="{00000000-0000-0000-0000-000000000001}"' | Remove-WmiObject
Start-Service -Name "CcmExec"
