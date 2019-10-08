Write-Host
Write-Host Beginning Auto zScaler script
Write-Host 'Updated 08/29/19; tested on Windows 7, 8, 10, Server 2012 R2'

$validRegion = $false
while (!$validRegion) {
    Write-Host 'NAM = USA, Mexico, Canada'
    Write-Host 'IN  = India'
    $region = (Read-Host 'Before the script can begin, enter your region (NAM/IN)').ToLower()
    if ($region -in ('nam', 'in')) {$validRegion = $true}
    else {Write-Host Invalid region, enter NAM or IN}
}


# Add the configuration script for corresponding region
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL /t REG_SZ /d "http://PACFILE.pac" /f


Write-Host Modified auto-configuration script for $region.ToUpper()


# Import the certificate
$imported = $false
while (!$imported) {
    try {
        $zScalerCert = Get-Item \\domain\cert.crt -ErrorAction Stop 
        $zScalerCert | Import-Certificate -CertStoreLocation Cert:\CurrentUser\Root -ErrorAction Stop
        Write-Host Imported zScaler root certificate
        $imported = $true
           
        Write-Host zScaler setup complete
    }

    catch {
	    $userExit = (Read-Host 'Could not import root certificate; file may have been moved or your credentials are incorrect. Do you want to try again? (y/n)').ToLower()

	    while ($userExit -notin ('y', 'n')) {
		    $userExit = Read-Host ('Invalid input; do you want to try again? (y/n)').ToLower()
	    }

	    if ($userExit -eq 'n') {
		    Read-Host Successfully closing the program, press any key to exit...
            exit
	    }
    }
}



