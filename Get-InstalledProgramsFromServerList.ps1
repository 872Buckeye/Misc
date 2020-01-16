
# One Computer Per Line
$myServers = @"
JAX1EXCH01
JAX1EXCH02
"@ -split '\r?\n'.Trim()

# One Search Per Line
$mySearch = @"
google
7zip
vmware
"@ -split '\r?\n'.Trim()

$MyLog = @()

foreach ($u in $myServers) {

    write-host "Gathering info on" $u
    $myGWMI = Get-WmiObject -ComputerName $u -Class win32_product

    foreach ($v in $mySearch) {

        write-host "Searching" $v

        $myVar = '*'+$v+'*'

        foreach ($w in ($myGWMI | ?{$_.Name -like $myVar})) {

            write-host "Found" $w.Name
            $myItem = New-Object PSObject
            $myItem | Add-Member -type NoteProperty -Name 'Server' -Value $u
            $myItem | Add-Member -type NoteProperty -Name 'Filter' -Value $v
            $myItem | Add-Member -type NoteProperty -Name 'Software' -Value $w.Name
            $myItem | Add-Member -type NoteProperty -Name 'Version' -Value $w.version
            $MyLog += $myItem        

        }

    }

}

$myLog
