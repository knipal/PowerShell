$ErrorActionPreference = "Stop"

#$latestVersionUrl = 'https://cdn.lansweeper.com/download/10.1.0/0/LansweeperSetup.exe' # update this URL as necessary
#$latestVersionUrl = 'https://cdn.lansweeper.com/download/10.2.5/0/LansweeperSetup.exe' # update this URL as necessary
$latestVersionUrl = 'https://cdn.lansweeper.com/download/10.4.1/0/LansweeperSetup.exe' # update this URL as necessary

$workingFolder = 'C:\temp'

if (!(Test-Path $workingFolder)) { throw "$workingFolder does not exist."}


if (Test-Path "$workingFolder\LansweeperSetup.exe") {
    write-host "Removing existing file $workingFolder\LansweeperSetup.exe"
    Remove-Item -Path "$workingFolder\LansweeperSetup.exe"
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $latestVersionUrl -OutFile "$workingFolder\LansweeperSetup.exe"

if (Test-Path "$workingFolder\LansweeperSetup.exe") {
    Write-Host -ForegroundColor Green -Object "Download completed."
} else {
    throw "Downloaded file not found."
}

pause