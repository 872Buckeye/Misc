
# One Computer Per Line
$myServers = @"
Server1
Server2
Server3
"@ -split '\r?\n'.Trim()

# One Search Per Line
$mySearch = @"
google
7zip
vmware
"@ -split '\r?\n'.Trim()

$MyLog = @()

foreach ($u in $myServers) {

    foreach ($v in $mySearch) {

        write-host $u $v

        foreach ($w in (Get-WmiObject -ComputerName $u -Class win32_product | ?{$_.Name -like '*$v*'})) {

            write-host $w.Name "Found"
            $myItem = New-Object PSObject
            $myItem | Add-Member -type NoteProperty -Name 'Server' -Value $u
            $myItem | Add-Member -type NoteProperty -Name 'Software' -Value $w.Name
            $myItem | Add-Member -type NoteProperty -Name 'Version' -Value $w.version
            $MyLog += $myItem        

        }

    }

}

$myLog
