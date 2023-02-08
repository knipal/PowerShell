# Base64
### Text
'Motörhead' | 
    % {[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($_))} |  # to 
    % {[Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($_))} # from 
### Files
[Convert]::ToBase64String([IO.File]::ReadAllBytes($FileName))


# implicit typing
"False" -eq $false # $true
$false -eq "False" # $false


# random passwords or secrets
-join (1..10 | %{ [char]((48..57) + (65..90) + (97..122) | Get-Random) })


# update computer group membership without reboot
klist purge -li 0x3e7


# workaround kerberos double hop for file copies
$session = New-PSSession -ComputerName mycomputer
Copy-Item -FromSession $session -Path C:\temp\copyme.txt -Destination "\\fileserver\share\folder\"


# Check for elevation / Run as Administrator
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Oopps, you need to run this script from an elevated PowerShell prompt!`nPlease start the PowerShell prompt as an Administrator and re-run the script."
	Write-Warning "Aborting script..."
    Break
}
# OR
[Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
# OR
[Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.SecurityIdentifier]::new("S-1-5-32-544"))

# PS Credential as file securely
# Source: https://blogs.technet.microsoft.com/heyscriptingguy/2017/12/22/script-wars-the-farce-awakens-part-v/
### WRITE
if ([Security.Principal.WindowsIdentity]::GetCurrent().Name -ne "domain\user") {
    throw "Not running as the user"
}
$password = 'watever'
$secureString = ConvertTo-SecureString $password -AsPlainText -Force
$encryptedStringASCII = ConvertFrom-SecureString $SecureString
Out-File -FilePath C:\encrypted\watever -inputobject $encryptedStringASCII
### READ
if ([Security.Principal.WindowsIdentity]::GetCurrent().Name -ne "domain\user") {
    throw "Not running as the user"
}
$secureStringPassword = Get-Content C:\encrypted\watever | ConvertTo-SecureString
# Convert to PSCredential object
$RetrivedCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'wat',$SecureStringPassword
# read plaintext from Credential object
$PlainTextPassword = $RetrivedCredential.GetNetworkCredential().Password


# Regular Expressions (regex)
"255.101.0.1" -match "^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$" # IPv4


# Remove extra characters
(irm checkip.amazonaws.com) -replace '\n',''


# while vs do..while
while ($false) {echo "ok"} # nothing
do {echo "ok"} while ($false) # "ok"


# timer
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$stopwatch.Stop()
$stopwatch


# TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12



# CBA secret vault
Unlock-SecretStore -Password (Import-Clixml "$env:UserProfile\Unlock-SecretStore.xml").Password

# Download a file from URL
#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri 'https://cdn.lansweeper.com/download/10.1.0/0/LansweeperSetup.exe' -OutFile "C:\temp\LansweeperSetup.exe"


# Automatic temporary file
[System.io.path]::GetTempFileName()
# OR
New-TemporaryFile

# Wait for user input
pause # $null = Read-Host 'Press Enter to continue...'


# SID to Name
$objSID = New-Object System.Security.Principal.SecurityIdentifier ("S S-1-3-12-12345678901-1234567890-1234567-1234")
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$objUser.Value


# Open a file with exclusive lock
[System.io.File]::Open('c:\myfile.txt', 'Open', 'Read', 'None') 


# Write Random
1..1024 | % {$rand=[byte[]]::new(1GB); [Random]::new().NextBytes($rand); [IO.File]::WriteAllBytes("D:\filez$_.bin",$rand)}