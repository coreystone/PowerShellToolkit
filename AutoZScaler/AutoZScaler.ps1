# Authenticate and map PSDrive to dev\software
$credential = Get-Credential
$credential = New-Object System.Management.Automation.PsCredential($credential.Username, $credential.Password)
New-PSDrive -name “X” -PSProvider FileSystem -Root \\domain -Persist -Credential $credential
Write-Host Authenticated and connected to \\domain


# Add the configuration script
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL /t REG_SZ /d "http://PACFILE.pac" /f
Write-Host Modified auto-configuration script


# Import the certificate
X:
$zScalerCert = (Get-ChildItem -Path 'CERT.crt')
$zScalerCert | Import-Certificate -CertStoreLocation Cert:\CurrentUser\Root
Write-Host Imported zScaler root certificate


# Unmap the PSDrive
Remove-PSDrive -name "X" -Force
Write-Host zScaler successfully configured
