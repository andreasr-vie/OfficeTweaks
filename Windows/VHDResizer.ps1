$path = "D:\tmp\vhdtest\*.vhdx"
$files = Get-ChildItem -File $path
[long]$newSize = Read-Host -Prompt "Neue Disksize in GB eingeben: "
[long]$newSize = $newSize * 1073741824
$partitionNumber = Read-Host -Prompt "Partition-ID eingeben (bei UPD 1): "
if ([string]::IsNullOrWhiteSpace($partitionNumber)) { $partitionNumber = 1 }

#########################################

Write-Host $newSize

$files | ForEach-Object {Get-VHD -path $_.FullName -ErrorAction Ignore} | Sort-Object -Property Size | Format-Table -AutoSize -Property Path, @{Name="GB"; Expression={[math]::round($_.Size/1GB, 2)}}
$files | ForEach-Object {Resize-VHD -Path $_.FullName -SizeBytes $newSize}

foreach ($file in $files)
{

    Write-Host("Das ist Disk Nummer " + $file.FullName)
    $size = (Mount-VHD -Path $file.FullName -PassThru | Get-Disk | Get-PartitionSupportedSize -PartitionNumber $partitionNumber)
    Write-Host("Size: " + $size)
    Dismount-VHD -Path $file.FullName
    Mount-VHD -Path $file.FullName -PassThru | Get-Disk | Resize-Partition -PartitionNumber $partitionNumber -Size $size.SizeMax
    Dismount-VHD -Path $file.FullName

}