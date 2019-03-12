$drives = Get-WmiObject -Class win32_cdromdrive
foreach ($drive in $drives.Drive) {
    if (! ($drive -like "Volume{*")) {
        mountvol $drive /D
    }
}



$getdrives = (Get-Disk | Where partitionstyle -eq ‘raw’).number
if (! ($getdrives -eq $null)) {
    foreach ($getdrive in $getdrives)
    {
        Write-Output "Setting disk $getdrive."
        Initialize-Disk $getdrive -PartitionStyle GPT;
        New-Partition $getdrive -AssignDriveLetter $fromcamp -UseMaximumSize | Format-Volume -FileSystem NTFS -Confirm:$false;
    }
} else {
    Write-output "There are currently no drives that are in RAW or pending initialize status"
}



$LetterDriver = 'C'
$size = Get-PartitionSupportedSize -DriveLetter $LetterDriver
Resize-Partition -DriveLetter $LetterDriver -Size $size.SizeMax
 