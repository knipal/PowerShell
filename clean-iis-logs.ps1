<#

.SYNOPSIS
Delete old IIS log files older than X days (default = 30).

.NOTES
- https://serverfault.com/questions/65329/how-can-i-keep-iis-log-files-cleaned-up-regularly
  - Original Idea
- https://stackoverflow.com/questions/26784883/get-iis-log-location-via-powershell
  - Find every log folder

#>

param(
    [switch]$DryRun,
    [int]$LogAgeDays = 30
)

#Requires -RunAsAdministrator
#Requires -Modules WebAdministration

$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"

$scriptNameWithoutExtension = ($myinvocation.MyCommand.Name.Split('.') | select -skiplast 1) -join '.'
Start-Transcript -Path "$env:temp\pstranscript-$scriptNameWithoutExtension-$(Get-Date -Format "yyyy-MM-dd-hhmmss").log" # C:\Windows\Temp for SYSTEM

if ($logAgeDays -lt 0) {throw "`"LogAgeDays`" cannot be negative."}

# Get log folders
Write-Host "Getting log folder locations..."
$logFolders = New-Object -TypeName "System.Collections.ArrayList"
$websites = Get-Website
foreach ($website in $websites) {
    $thisLogFolder = "$($Website.logFile.directory)\w3svc$($website.id)".replace("%SystemDrive%",$env:SystemDrive)
    Write-Host "The log for `"$($website.Name)`" is located `"$thisLogFolder`""
    $logFolders.Add($thisLogFolder) | Out-Null
}

# Get old log files
Write-Host "Getting old log files..."
$oldLogFiles = New-Object -TypeName "System.Collections.ArrayList"
foreach ($logFolder in $logFolders) {
    $logFolder = $logFolder.TrimEnd('\')
    if (!(Test-Path $logFolder)) {throw "$logFolder does not exist"}
    if ((Get-Item $logFolder) -isnot [System.IO.DirectoryInfo]) {throw "$logFolder is not a folder"}

    # When using the -Include parameter, if you don't include an asterisk in the path the command returns no output
    Get-ChildItem -Path "$($logFolder)\*" -Include "*.log" |
        Where-Object LastWriteTime -lt  (Get-Date).AddDays(-$LogAgeDays) | % {
            $oldLogFiles.Add($_) | Out-Null
        }
}

Write-Host "Found $($oldLogFiles.Count) old log files."


if ($DryRun) {
    Write-Host -ForegroundColor Green -Object "The DryRun parameter is specified. No log files will be deleted."
}

foreach ($file in $oldLogFiles) {
    Write-Host "Deleting $($file.FullName) last written on $($file.LastWriteTime) "
    if (!($DryRun)) {
        Remove-Item -Path $file.FullName
    }
}

Write-Host ("Cleanup completed. $($oldLogFiles.Count) files deleted to free up {0:N2} GB of disk space." -f (($oldLogFiles.Length | measure -Sum).Sum / 1GB))

Stop-Transcript