Remove-PSDrive -name "X" -Force;
# Authenticate and map PSDrive to devnas13\images
$credential = Get-Credential
$credential.Password | ConvertFrom-SecureString | Set-Content c:\temp\password.txt
$encrypted = Get-Content c:\temp\password.txt | ConvertTo-SecureString
$credential = New-Object System.Management.Automation.PsCredential($credential.Username, $encrypted)

New-PSDrive -name "X"� -PSProvider FileSystem -Root \\domain\images -Persist -Credential $credential
 

function browse () {
    Add-Type -AssemblyName System.Windows.Forms
    $browser = New-Object System.Windows.Forms.FolderBrowserDialog
    $browser.SelectedPath = "\\domain\images"
    $null = $browser.ShowDialog()
    Write-Host $browser.SelectedPath
    $userPath = $browser.SelectedPath
    $textBox1.Text = $userPath
    return $userPath
}

function enterButton ($title,$folderpath, $note, $initials) {
###################Load Assembly for creating form & button######
[void][System.Reflection.Assembly]::LoadWithPartialName( “System.Windows.Forms”)
[void][System.Reflection.Assembly]::LoadWithPartialName( “Microsoft.VisualBasic”)

#####Define the form size & placement
$form = New-Object “System.Windows.Forms.Form”;
$form.Width = 550;
$form.Height = 150;
$form.Text = $title;
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;

##############Define text label1
$textLabel1 = New-Object “System.Windows.Forms.Label”;
$textLabel1.Left = 10;
$textLabel1.Top = 10;
$textLabel1.Text = $folderpath;

##############Define text label2
$textLabel2 = New-Object “System.Windows.Forms.Label”;
$textLabel2.Left = 10;
$textLabel2.Top = 40;
$textLabel2.Text = $note;

##############Define text label3
$textLabel3 = New-Object “System.Windows.Forms.Label”;
$textLabel3.Left = 10;
$textLabel3.Top = 70;
$textLabel3.Text = $initials;

############Define text box1 for input
$textBox1 = New-Object “System.Windows.Forms.TextBox”;
$textBox1.Left = 110;
$textBox1.Top = 10;
$textBox1.width = 400;

############Define text box2 for input
$textBox2 = New-Object “System.Windows.Forms.TextBox”;
$textBox2.Left = 110;
$textBox2.Top = 40;
$textBox2.width = 400;

############Define text box3 for input
$textBox3 = New-Object “System.Windows.Forms.TextBox”;
$textBox3.Left = 110;
$textBox3.Top = 70;
$textBox3.width = 50;

#############Define default values for the input boxes
$textBox1.Text = “\\domain\images\”;
$textBox2.Text = “”;
$textBox3.Text = “”;

#############define browseButton
$browseButton = New-Object “System.Windows.Forms.Button”;
$browseButton.Left = 420;
$browseButton.Top = 40;
$browseButton.Width = 100;
$browseButton.Text = “Browse”;

#############define enterButton
$enterButton = New-Object “System.Windows.Forms.Button”;
$enterButton.Left = 420;
$enterButton.Top = 70;
$enterButton.Width = 100;
$enterButton.Text = “Enter”;

############# This is when you have to close the form after getting values
$eventHandler = [System.EventHandler]{
$textBox1.Text;
$textBox2.Text;
$textBox3.Text;
$form.Close();
$browseButton.Add_Click({browse});
$enterButton.Add_Click($eventHandler) ;

#############Add controls to all the above objects defined
$form.Controls.Add($browseButton);
$form.Controls.Add($enterButton);
$form.Controls.Add($textLabel1);
$form.Controls.Add($textLabel2);
$form.Controls.Add($textLabel3);
$form.Controls.Add($textBox1);
$form.Controls.Add($textBox2);
$form.Controls.Add($textBox3);
$ret = $form.ShowDialog();

#################return values
return $textBox1.Text, $textBox2.Text, $textBox3.Text
}

$return= enterButton “Auto README” “Folder path” “Add note” “Initials”
$folderpath = $return[0] 
$userNote = $return[1]
$initials = $return[2]
If ($test -notmatch '.+?\\$') {$folderpath += “\”}
$folderpath += “README.txt”
$path = [System.IO.DirectoryInfo]$folderpath

$lines = get-content $path
$numLines = $lines.Count

$notes =  Get-Content $path | Select-Object -Index (34..$numLines)

$lines = get-content $path
$numLines = $lines.Count


$model = (Get-WmiObject -Class:Win32_ComputerSystem).Model
$date = Get-Date -Format g
$winVer = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$winRel = $winVer.ReleaseId

Set-Content $path "$model README ($date)"

Add-Content $path "BASE R&D IMAGE performed by $initials"

$caption = (gwmi win32_operatingsystem).caption.trimstart("Microsoft ") 
$osa = (gwmi win32_operatingsystem).OSArchitecture

Add-Content $path "$caption $osa"

$version = (Get-WmiObject Win32_OperatingSystem).Version
Add-Content $path "Release $winRel (Version $version)"

Add-Content $path “
------------------------------------------------------------
"

$hostname = (gwmi win32_operatingsystem).pscomputername
Add-Content $path "TEMP(BASE) HOSTNAME: $hostname"

Add-Content $path "
        MUST CHANGE [computer name] and add to [DEV domain]!
        CHANGE [DevLOCAL] password!

TEMP(BASE) DEVLOCAL pass = SANITIZED”

Add-Content $path “
------------------------------------------------------------
"

Add-Content $path "SOFTWARE INSTALLED:"

$interestingApps = @(“McAfee ePO Deep Command Client”, 
				“Office 16 Click-to-Run Extensibility Component”,
				“SAP Kerberos SSO Support”,
				“McAfee Agent”,
				“Adobe Acrobat Reader DC”,
				“McAfee VirusScan Enterprise”,
				“Cylance PROTECT”) 

foreach ($app in Get-WmiObject -Class Win32_Product)
{
$name = [string]$app.name
$version = $app.version

	if ($name.contains(“Java”))
	{
	Add-Content $path "        $name (v$version)" 
}

elseif ($interestingApps -contains $name) {
	if ($name -eq “SAP Kerberos SSO Support”) {
	$name = “SAP”
		} elseif ($name -eq “Office 16 Click-to-Run Extensibility Component”) {
		$name = “Office 365 ProPlus”
		}
Add-Content $path "        $name (v$version)" }
}

$chromeVersion =  (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion

$ffVersion = (Get-ItemProperty Registry::HKEY_LOCAL_MACHINE\SOFTWARE\mozilla.org\Mozilla).CurrentVersion


$mcAfee = get-itemproperty HKLM:\software\wow6432Node\mcafee\avengine
$mcAfeeDATVer = $mcAfee.AVDatVersion
$mcAfeeDATDate = $mcAfee.AVDatDATE

Add-Content $path "        McAfee DAT $mcAfeeDATVer ($mcAfeeDATDate)"

Add-Content $path "
        Google Chrome (v$chromeVersion)"

Add-Content $path "        Mozilla Firefox (v$ffVersion)"

Add-Content $path “
------------------------------------------------------------
"

Add-Content $path "NOTES:"
Add-Content $path $notes

if ($userNote -ne “”) 
{
$newNote = (Get-Date).ToString('MM/dd/yy') + “ “ 
$newNote += $userNote
$newNote += “ ($initials)”
Add-Content $path $newNote
}


# Unmap the PSDrive
Remove-PSDrive -name "X" -Force;


