<#
.SYNOPSIS
Reads a BIND formatted DNS zone file and compares it to a DNS server.

#>

$file = get-content C:\temp\db.knipal.com.txt -Raw
$domain = "knipal.com"
$server = "denver.ns.cloudflare.com"

$recordsString = ($file -split '(?:\r?\n){2,}')[2] # third "paragraph"

$records = $recordsString -split '\n'

foreach ($record in $records) {
    if ($record -match '^$') {continue} # ignore empty lines

    $entries = $record -split '\s+'

    $dnsName = if ($entries[0] -eq '@') {$domain} else {$entries[0] + '.' + $domain}
    $type = $entries[2]
    if ($type -eq 'TXT') {
        $expectedResult = ([regex]'".*"$').matches($record).Value.Trim('"') # TXT records can contain spaces
    } elseif ($type -eq 'MX'){
        $expectedResult = $entries[4]
    } elseif ($type -eq 'NS'){
        continue    # can't query NS
    } else {
        $expectedResult = $entries[3]
    }


    if ($type -eq 'ALIAS') {continue} # invalid

    $result = switch($type) {
        'A' {$(Resolve-DnsName $dnsName -Type A -Server $server).IPAddress}
        'CNAME' {$(Resolve-DnsName $dnsName -Type CNAME -Server $server).NameHost + '.'}
        'NS' {$(Resolve-DnsName $dnsName -Type CNAME -Server $server).NameHost}
        'MX' {$(Resolve-DnsName $dnsName -Type MX -Server $server).NameExchange + '.'}
        'TXT' {$(Resolve-DnsName $dnsName -Type TXT -Server $server).Strings.Trim('"')}
    }


    $correctness = $expectedResult -in $result


    $color = switch($correctness) {
        $true {"Green"}
        $false {"Red"}
        default {"Red"}
    }
    

    Write-Host "$correctness - $dnsName type $type resolves to `"$result`" where we expected `"$expectedResult`"" -ForegroundColor $color

    # debug
    #if (!$correctness) {write-host $record}
}
