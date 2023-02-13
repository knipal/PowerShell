param (
    [PSCredential]$vcenterCredentials
)

if (!$vcenterCredentials) {$vcenterCredentials = Get-Credential -Message "Enter vCenter Credentials."}

#Requires -Modules ImportExcel, VMware.VimAutomation.Core
$ErrorActionPreference = "Stop"


# TODO - fix certificates on vcenter servers and re-enable certificate vaidation check
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false | Out-Null
Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Scope Session -Confirm:$false | Out-Null


$xlsxPath = "$env:userprofile\Desktop\VMware-Snapshots.$(Get-Date -Format "yyyy-MM-dd-hhmm").xlsx"
if (Test-Path $xlsxPath) {
    throw "File $xlsxPath already exists."
}

$vcenterServers = [ordered]@{
    "SITE-CODE-1" = "vcenter1-url.example.com"
    "SITE-CODE-2" = "vcenter2-url.example.com"
}







try {
    Connect-VIServer -Server @($vcenterServers.Values) -Credential $vcenterCredentials -ErrorAction Stop -Verbose # ErrorAction must be added to work

    foreach ($vcenterServer in $vcenterServers.GetEnumerator()) {
        $siteName = $vcenterServer.Name
        $siteFQDN = $vcenterServer.Value

        # lazy flooring by casting to int
        $snapshots = Get-VM -Server $siteFQDN | 
            Get-Snapshot | 
                sort Created -Descending | 
                select VM,Name,Created,@{n="SizeGB";e={[int]$_.SizeGB}},Description

        $snapshots | Export-Excel -Path $xlsxPath -WorksheetName $siteName -TableName $siteName -AutoSize -AutoFilter -FreezeTopRow
    }
} <#catch {
    Write-Error $_
} #>finally {
    if ($global:DefaultVIServers) {Disconnect-VIServer -Server * -Confirm:$false -Verbose}
}

