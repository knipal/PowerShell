$ProgressPreference = 'SilentlyContinue'

$remoteHost = Read-Host -Prompt "Enter the hostname or IP"
Write-Host "Beginning test $remoteHost"
while (1) {
    $pingResult = Test-NetConnection $remoteHost -InformationLevel Quiet -WarningAction SilentlyContinue -ErrorAction Stop
        
    Write-Host ("{0} - " -f $(Get-Date -Format "HH:mm:ss")) -NoNewline

    if ($pingResult) {
        Write-Host " Online " -BackgroundColor Green
    } else {
        Write-Host " Offline " -BackgroundColor Red
    }

    sleep 1
}