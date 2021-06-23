$HOST_URL  = "https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt"

$HOST_FILE = "adverts"

$HOST_RAW  = $(Invoke-WebRequest -Uri $HOST_URL -UseBasicParsing).Content

$FILE      = [System.IO.StreamWriter]::new($HOST_FILE)

$rx        = [System.Text.RegularExpressions.Regex]::Matches($HOST_RAW, "(?<=127\.0\.0\.1 ).*")

foreach($match in $rx) {
    if($match.Value -eq " localhost") { continue }
    $FILE.WriteLine($match.Value)
}

$FILE.Close()
