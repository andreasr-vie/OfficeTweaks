function Test-RegistryValue {

param (

 [parameter(Mandatory=$true)]
 [ValidateNotNullOrEmpty()]$Path,

[parameter(Mandatory=$true)]
 [ValidateNotNullOrEmpty()]$Value
)

try {
Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
return $true
}

catch {
    return $false
}
}

$RegUser = Read-Host -Prompt "Wie lautet der Name, auf den der Computer registriert sein soll?"
$RegUserKey = "RegisteredOwner"
$RegOrg = Read-Host -Prompt "Wie lautet die Firma, auf die der Computer registriert sein soll?"
$RegOrgKey = "RegisteredOrganization"
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$RegType = "String"

if(Test-RegistryValue -Path $RegPath -Value $RegUserKey) { Set-ItemProperty -Path $RegPath -Name $RegUserKey -Value $RegUser }
else { New-ItemProperty -Path $RegPath -Name $RegUserKey -Value $RegUser -PropertyType $RegType }

if(Test-RegistryValue -Path $RegPath -Value $RegOrgKey) { Set-ItemProperty -Path $RegPath -Name $RegOrgKey -Value $RegOrg }
else { New-ItemProperty -Path $RegPath -Name $RegOrgKey -Value $RegOrg -PropertyType $RegType }


Write-Host ""
Write-Host "Dieser Computer wurde auf folgende Daten registriert:"
Write-Host "     Name:          " $RegUser
Write-Host "     Organisation:  " $RegOrg
