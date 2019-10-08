# Authenticate and map PSDrive to dev\software
$connected = $false
while (!$connected) {
    try
    {
        $credential = Get-Credential
        $credential = New-Object System.Management.Automation.PsCredential($credential.Username,  $credential.Password)
        New-PSDrive -name “X” -PSProvider FileSystem -Root  \\domain\ZScaler -Persist -Credential $credential
        $connected = $true
    }

    catch
    {
	    Write-Host Could not connect to \\domain; make sure your credentials are correct
	    $userExit = Read-Host ‘Do you want to try again? (y/n)’

	    while ($userExit -notin (“y”, “n”)) {
		    $userExit = Read-Host ‘Invalid input; do you want to try again? (y/n)’

		    if ($userExit -eq “n”) {
			    if (Get-PSDrive “X” -ErrorAction SilentlyContinue) {
			        Remove-PSDrive -name "X" -Force
                    exit
		        }
            }
    
        }
    }
}

Write-Host Authenticated and connected to \\domain

# Add the configuration script
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL /t REG_SZ /d "http://PACFILE.pac" /f
Write-Host Modified auto-configuration script


# Import the certificate
try {
    X:
    $zScalerCert = (Get-ChildItem -Path 'CERT.crt')
    $zScalerCert | Import-Certificate -CertStoreLocation Cert:\CurrentUser\Root
    Write-Host Imported zScaler root certificate
}

catch {
    Write-Host Could not import root certificate; file may have been moved
    Remove-PSDrive -name "X" -Force
    Read-Host "Press any key to exit..." 
    Exit
}


# Unmap the PSDrive
Remove-PSDrive -name "X" -Force
Write-Host zScaler successfully configured


