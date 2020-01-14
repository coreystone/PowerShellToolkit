$validRegion = $false
while (!$validRegion) {
    Write-Host 'NAM = USA, Mexico, Canada'
    Write-Host 'IN  = India'
    $region = (Read-Host 'Before the script can begin, enter your region (NAM/IN)').ToLower()
    if ($region -in ('nam', 'in')) {$validRegion = $true}
    else {Write-Host Invalid region, enter NAM or IN}
}


# Add the configuration script for corresponding region
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL /t REG_SZ /d "pacfile.pac" /f
Write-Host Modified auto-configuration script for $region.ToUpper()


# Import the certificate
$imported = $false
while (!$imported) {
    try {
        $zScalerCert = Get-Item \\domain\CERT.crt -ErrorAction Stop 
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
		    Write-Host ''
	    }
    }
}


# Disable auto reboot
$regkeypath="HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl"
Set-ItemProperty -Path $regkeypath -Name "AutoReboot" -Value 0
Write-Host Auto-reboot disabled


# Enable RDC
$ComputerName = hostname
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
(Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices -ComputerName $ComputerName -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(1)
Write-Host RDC enabled


# Disable IPv6
$adapters = Get-NetAdapterBinding -ComponentID ms_tcpip6
Foreach ($a in $adapters) {Disable-NetAdapterBinding -Name $a.Name -ComponentID ms_tcpip6}
Write-Host Disabled IPv6 for each network adapter


# Disable Sleep mode when charging
c:\windows\system32\powercfg.exe -change -standby-timeout-ac 0
Write-Host Sleep mode when plugged-in disabled


$credential = Get-Credential
$credential = New-Object System.Management.Automation.PsCredential($credential.Username,  $credential.Password)


# Install VirusScan Enterprise
Start-Process -FilePath '\\domain\mcafeeepo.exe'
Write-Host McAfee VirusScan Enterprise installed


# Download SAP
Start-Process -FilePath '\\domain\sap.exe'
Write-Host SAP installed

# Download O365
Invoke-Item "\\domain\o365.exe"
Write-Host Office 365 installed


# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
Write-Host Installed Chocolatey


#Install Chrome, Firefox, Java, Adobe Acrobat
choco install googlechrome -y
Write-Host Installed Google Chrome
choco install firefox -y
Write-Host Installed Mozilla Firefox
choco install adobereader -y
Write-Host Installed Adobe Acrobat Reader DC
choco install javaruntime -y
Write-Host Installed JRE

