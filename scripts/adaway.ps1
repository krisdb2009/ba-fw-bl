$HOST_URL  = "https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt"

$HOST_FILE = "adverts"

$HOST_RAW  = $(Invoke-WebRequest -Uri $HOST_URL -UseBasicParsing).Content

$FILE      = [System.IO.StreamWriter]::new($HOST_FILE)

$rx        = [System.Text.RegularExpressions.Regex]::Matches($HOST_RAW, "(?<=127\.0\.0\.1 ).*")

$track     = 0

foreach($match in $rx) {
    if($match.Value -eq " localhost") { continue }
    Write-Progress -Activity "Resolving" -Status $match.Value -PercentComplete $(($track++ / $rx.Count) * 100)
    $ips = Resolve-DnsName -Name $match.Value -Type A_AAAA -ErrorAction SilentlyContinue
    foreach($ip in $ips) {
        if($ip.Address -eq $null) { continue }
        $FILE.WriteLine($ip.Address.ToString())
    }
}

$FILE.Close()
