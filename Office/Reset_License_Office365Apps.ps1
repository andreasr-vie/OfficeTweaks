# RESET OFFICE ACTIVATION STATE
# https://docs.microsoft.com/en-us/office/troubleshoot/activation/reset-office-365-proplus-activation-state
#
# Credit: https://gist.github.com/mark05e
#
# Setzt die Lizenzierung der Office 365 Apps zurück

$Urls = @(
	"https://download.microsoft.com/download/e/1/b/e1bbdc16-fad4-4aa2-a309-2ba3cae8d424/OLicenseCleanup.zip",
	"https://download.microsoft.com/download/f/8/7/f8745d3b-49ad-4eac-b49a-2fa60b929e7d/signoutofwamaccounts.zip",
	"https://download.microsoft.com/download/8/e/f/8ef13ae0-6aa8-48a2-8697-5b1711134730/WPJCleanUp.zip"
	)

$BaseExtractPath = "C:\TempPath\o365reset\"		

# create folder anyway
New-Item -ItemType Directory -Path $BaseExtractPath -Force

# download and extract files
foreach ($Url in $Urls) {
	$DownloadZipFile = $BaseExtractPath + $(Split-Path -Path $Url -Leaf)
	$ExtractPath = $BaseExtractPath
	write-host "Downloading: $Url"
	Invoke-WebRequest -Uri $Url -OutFile $DownloadZipFile
	$ExtractShell = New-Object -ComObject Shell.Application
	$ExtractFiles = $ExtractShell.Namespace($DownloadZipFile).Items()
	$ExtractShell.NameSpace($ExtractPath).CopyHere($ExtractFiles)	
}

# check if the files exist after extract
write-host "Test OLicenseCleanup.vbs: " -nonewline; Test-Path $BaseExtractPath\OLicenseCleanup.vbs
write-host "Test signoutofwamaccounts.ps1: " -nonewline; Test-Path $BaseExtractPath\signoutofwamaccounts.ps1
write-host "Test WPJCleanUp.cmd: " -nonewline; Test-Path $BaseExtractPath\WPJCleanUp\WPJCleanUp\WPJCleanUp.cmd

# execute each script
write-host "Execute OLicenseCleanup.vbs: "
Start-Process cmd.exe -ArgumentList "/c $($BaseExtractPath)\OLicenseCleanup.vbs" -NoNewWindow -PassThru
Start-Sleep 3
write-host "Execute signoutofwamaccounts.ps1: "
start-process powershell.exe -argumentlist "-executionpolicy bypass -file $($BaseExtractPath)\signoutofwamaccounts.ps1" -NoNewWindow -PassThru
Start-Sleep 3
write-host "Execute WPJCleanUp.cmd: "
Start-Process $BaseExtractPath\WPJCleanUp\WPJCleanUp\WPJCleanUp.cmd -NoNewWindow -PassThru
Start-Sleep 3
