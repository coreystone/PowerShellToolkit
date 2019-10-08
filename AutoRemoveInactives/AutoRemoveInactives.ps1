# Updated 8/29/19
# AutoRemoveInactives is a script created to free bounce and conference computers of storage by deleting old, inactive user profiles from the Users folder.
# Users, depending on the OS, can take up to 600MB of storage alone just from signing into the account. This script frees up that storage and can improve performance,
# especially on outdated machines that are being used as such "community" computers.



$users = Get-WmiObject -class Win32_UserProfile
Foreach ($u in $users) {
	If (!$u.Special -and ($u.LastUseTime -eq "" -or $u.LastUsetime -lt (Get-Date).AddDays(-30))) 
	{
		Remove-WmiObject -class Win32_UserProfile
		Write-Host Removing old user
	}

	Else {Write-Host Not removing Special user}
}