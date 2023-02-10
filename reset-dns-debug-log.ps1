$computer = Read-Host -Prompt "DNS Server Name"
Invoke-Command -ComputerName $computer -ScriptBlock {Restart-Service dns}
Resolve-DnsName example.com -Type A -Server $computer