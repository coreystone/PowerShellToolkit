# Updated 08/29/19 
# AutoFreshImage is a script created to automate much of the imaging process for new machines that do not have an existing image.
# It configures the desired Windows settings and installs software for a base R&D machine. 

$validRegion = $false
while (!$validRegion) {
    Write-Host 'NAM = USA, Mexico, Canada'
    Write-Host 'IN  = India'
    $region = (Read-Host 'Before the script can begin, enter your region (NAM/IN)').ToLower()
    if ($region -in ('nam', 'in')) {$validRegion = $true}
    else {Write-Host Invalid region, enter NAM or IN}
}


# Add the configuration script for corresponding region
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL /t REG_SZ /d "pat/PACFILE" /f
Write-Host Modified auto-configuration script for $region.ToUpper()


# Import the certificate
$imported = $false
while (!$imported) {
    try {
        $zScalerCert = Get-Item \\domain\\certfile.crt -ErrorAction Stop 
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

# Create devadministrator
#$devadminPassword = Read-Host -AsSecureString 'Enter devadministrator password (or enter to skip)'
#if ($devadminPassword -ne "") {
#    New-LocalUser "devadministrator" -Password $devadminPassword -PasswordNeverExpires -UserMayNotChangePassword
#    Add-LocalGroupMember -Group "Administrators" -Member "devadministrator"
#    Write-Host devadministrator local account created
#}

$credential = Get-Credential
$credential = New-Object System.Management.Automation.PsCredential($credential.Username,  $credential.Password)

# Add computer to domain
#Add-Computer -ComputerName $env:computername -LocalCredential $credential -DomainName dom -Credential $credential
#Write-Host Computer joined to  domain


# Add CORP account to local Administrators
#$DomainUser = Read-Host 'Enter the CORP account to add to Administrators (or Enter to skip)'
#if ($DomainUser -ne "") {
#    $LocalGroup = 'Administrators'
#    $Computer   = $env:computername
#    $Domain     = $env:userdomain
#    ([ADSI]"WinNT://$Computer/$LocalGroup,group").psbase.Invoke("Add",([ADSI]"WinNT://$Domain/$DomainUser").path)
#    Write-Host $DomainUser added to Administrators group
#}


# Rename computer
$name = Read-Host 'NEW COMPUTER NAME (or Enter to skip)'
if ($name -ne "") {Rename-Computer -NewName $newComputerName -DomainCredential $credential.Username}
Write-Host Computer renamed to $name


#  Authenticate and map PSDrive to dev\software
#$credential = Get-Credential
#$credential = New-Object System.Management.Automation.PsCredential($credential.Username, $credential.Password)
#New-PSDrive -name "X" -PSProvider FileSystem -Root \\domain\software -Persist -Credential $credential
#X:


# Install McAfee agent
Start-Process -FilePath '\\domain\AgentInstall\McAfeeAgent.exe'
Write-Host McAfee EPO Agent installed


# Install VirusScan Enterprise
Start-Process -FilePath '\\domain\McAfeeAntiVirus.exe'
Write-Host McAfee VirusScan Enterprise installed


# Download SAP
Start-Process -FilePath '\\domain\SAP.exeù'
Write-Host SAP installed

# Download O365
C:
$url = "office365.exe"
$output = "C:\Program Files\invofficedeployment.exe"
Invoke-WebRequest -Uri $url -OutFile $output
Invoke-Item $output
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