# Authenticate and map PSDrive to dev\software
$credential = Get-Credential
$credential = New-Object System.Management.Automation.PsCredential($credential.Username, $credential.Password)
New-PSDrive -name “X” -PSProvider FileSystem -Root \\domain -Persist -Credential $credential


#### Add the configuration script ####
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL /t REG_SZ /d "http://PACFILE.pac" /f



#### Import the certificate ####
X:
$zScalerCert = (Get-ChildItem -Path 'CERT.crt')
$zScalerCert | Import-Certificate -CertStoreLocation Cert:\CurrentUser\Root

# Unmap the PSDrive
Remove-PSDrive -name "X" -Force