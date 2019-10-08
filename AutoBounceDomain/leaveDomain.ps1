# Leave the domain and join TEMP workgroup
Add-Computer -WorkgroupName TEMP

# Add one-time task to run script to re-join the domain
Set-Location -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'
Set-ItemProperty -Path . -Name rejoinDomain -Value "\\domain\rejoinDomain.ps1"

Restart-Computer