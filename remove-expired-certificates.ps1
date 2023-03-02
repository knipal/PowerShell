#Requires -RunAsAdministrator

$computerCerts = Get-ChildItem Cert:\LocalMachine\My\
$expiredComputerCerts = $computerCerts | Where-Object {$_.NotAfter -lt (get-date)}

$expiredComputerCerts | % {
    $output = "Cert named `"{0}`" ({1}) for {2} from CA {3} expired on {4}" -f $_.FriendlyName, `
                                                                               $_.Thumbprint, `
                                                                               $_.Subject, `
                                                                               $_.Issuer, `
                                                                               $_.NotAfter
    Write-Host $output
}

$expiredComputerCerts | Remove-Item -Verbose
