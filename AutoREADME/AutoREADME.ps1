# Updated 8/29/19
# AutoREADME is a script created to automate the creation of README files for new or updated R&D images.
# It fetches the system specs, installed software, and also notes entered by the user and compiles them into a README.txt file.
# The GUI allows users to select the network folder corresponding to the machine the readme is being created for, and to enter their initials and a note detailing what's new in the readme.


# Authenticate and map PSDrive to domain
$connected = $false
while (!$connected) {
    try {
        if (Get-PSDrive "N" -ErrorAction SilentlyContinue) {
			    Remove-PSDrive -name "N" -Force
		}
        $credential = Get-Credential
        $credential = New-Object System.Management.Automation.PsCredential($credential.Username,  $credential.Password)

        New-PSDrive -name "N" -PSProvider FileSystem -Root  \\domain\imagefolder -Persist -Credential $credential     
	$connected = $true
    }

    catch {
        Write-Host 'Could not connect to \\domain\IMAGES; make sure your credentials are correct'
        Write-Host $Error[0].Exception.GetType().FullName
		$userExit = Read-Host 'Do you want to try again? (y/n)'

        while ($userExit -notin ("y", "n")) {
            $userExit = Read-Host 'Invalid input; do you want to try again? (y/n)'
        }

		if ($userExit -eq "n") {
            if (Get-PSDrive "N" -ErrorAction SilentlyContinue) {
			    Remove-PSDrive -name "N" -Force
		    }
            Write-Host Successfully closing the program
            exit
        }
    }
}

Write-Host Authenticated and connected to \\domain\IMAGES

function browse {
    Add-Type -AssemblyName System.Windows.Forms
    $browser = New-Object System.Windows.Forms.FolderBrowserDialog
    $browser.SelectedPath = "\\domain\images"
    $null = $browser.ShowDialog()
    $userPath = $browser.SelectedPath
    $textBox1.Text = $userPath
    return $userPath
}
 
 
 function button ($title,$folderpath, $note, $initials) {
     #########Load Assembly for creating form & button######
     [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
     [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
     
     #####Define the form size & placement
     $form = New-Object "System.Windows.Forms.Form";
     $form.Width = 550;
     $form.Height = 150;
     $form.Text = $title;
     $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;
 
     ##############Define text label1
     $textLabel1 = New-Object "System.Windows.Forms.Label";
     $textLabel1.Left = 10;
     $textLabel1.Top = 10;
     $textLabel1.Text = $folderpath
 
     ##############Define text label2
     $textLabel2 = New-Object "System.Windows.Forms.Label";
     $textLabel2.Left = 10;
     $textLabel2.Top = 40;
     $textLabel2.Text = $note;

     ##############Define text label3
     $textLabel3 = New-Object "System.Windows.Forms.Label";
     $textLabel3.Left = 10;
     $textLabel3.Top = 70;
     $textLabel3.Text = $initials;

     ############Define text box1 for input
     $textBox1 = New-Object "System.Windows.Forms.TextBox";
     $textBox1.Left = 110;
     $textBox1.Top = 10;
     $textBox1.width = 300;
 
     ############Define text box2 for input
     $textBox2 = New-Object "System.Windows.Forms.TextBox";
     $textBox2.Left = 110;
     $textBox2.Top = 40;
     $textBox2.width = 410;
 
     ############Define text box3 for input
     $textBox3 = New-Object "System.Windows.Forms.TextBox";
     $textBox3.Left = 110;
     $textBox3.Top = 70;
     $textBox3.width = 50;
 
     #############Define default values for the input boxes
     $defaultValue = ""
     $textBox1.Text = "\\domain\imagefolder";;
     $textBox2.Text = "";
     $textBox3.Text = "";
 
     #############define Browse button
     $browseButton = New-Object "System.Windows.Forms.Button";
     $browseButton.Left = 420;
     $browseButton.Top = 10;
     $browseButton.Width = 100;
     $browseButton.Text = "Browse";
 
     #############define enterButton
     $enterButton = New-Object "System.Windows.Forms.Button";
     $enterButton.Left = 420;
     $enterButton.Top = 70;
     $enterButton.Width = 100;
     $enterButton.Text = "OK";

     ############# This is when you have to close the form after getting values
     $eventHandler = [System.EventHandler]{
     $textBox1.Text;
     $textBox2.Text;
     $textBox3.Text;
     $form.Close();};
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

$return= button "Auto README" "Folder Path" "Add Note" "Initials"
$folderPath = $return[0] 
$userNote = $return[1]
$initials = $return[2]
 
if ($test -notmatch '.+?\\$') {$folderPath += "\"}
$filePath =  $folderPath + "README.txt"
$readmeExists = Test-Path $filePath

$path = [System.IO.DirectoryInfo]$filePath

if ($readmeExists) {
	Write-Host 'Modifying existing readme file' $filePath
    $lines = get-content $path
    $numLines = $lines.Count

    $notes =  Get-Content $path | Select-Object -Index (34..$numLines)

    $lines = get-content $path
    $numLines = $lines.Count
}

else {Write-Host Creating new readme file}


$model = (Get-WmiObject -Class:Win32_ComputerSystem).Model
$date = Get-Date -Format g
$winVer = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$winRel = $winVer.ReleaseId

Set-Content $path "$model README ($date)"

if ($initials -ne "") {Add-Content $path "BASE R&D IMAGE performed by $initials"}
else {Add-Content $path "BASE R&D IMAGE"}


$caption = (gwmi win32_operatingsystem).caption.trimstart("Microsoft ") 
$osa = (gwmi win32_operatingsystem).OSArchitecture

Add-Content $path "$caption $osa"

$version = (Get-WmiObject Win32_OperatingSystem).Version
Add-Content $path "Release $winRel (Version $version)"

Add-Content $path "
------------------------------------------------------------
"

$hostname = (gwmi win32_operatingsystem).pscomputername
Add-Content $path "TEMP(BASE) HOSTNAME: $hostname"

Add-Content $path "
        MUST CHANGE [computer name] and add to [domain]!
        CHANGE [USERNAME] password!

TEMP(BASE) DEVLOCAL pass = SANITIZED"

Write-Host 'Gathered system info'

Add-Content $path "
------------------------------------------------------------
"

Add-Content $path "SOFTWARE INSTALLED:"
Write-Host 'Checking installed software'


$interestingApps = @("McAfee ePO Deep Command Client",
				"Office 16 Click-to-Run Extensibility Component",
				"SAP Kerberos SSO Support",
				"McAfee Agent",
				"Adobe Acrobat Reader DC",
				"Adobe Acrobat Reader DC MUI",
				"McAfee VirusScan Enterprise",
				"Cylance PROTECT") 


foreach ($app in Get-WmiObject -Class Win32_Product) {
    try {
        $name = [string]$app.name
        $version = $app.version

	    if ($name.contains("Java")) {Add-Content $path "        $name (v$version)"}

        elseif ($name -in $interestingApps) {
            if ($name -eq "SAP Kerberos SSO Support") {$name = "SAP"} 
            elseif ($name -eq "Office 16 Click-to-Run Extensibility Component") {$name = "Office 365 ProPlus"}
    
            Add-Content $path "        $name (v$version)" 
        }
    }

    catch {
        Write-Host $app NOT INSTALLED
        Add-Content $path "         $app  NOT INSTALLED"
    }
}

if (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe') {
    $chromeVersion =  (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion
    Add-Content $path "        Google Chrome (v$chromeVersion)"
}

else {
    Write-Host Google Chrome NOT INSTALLED
    Add-Content $path "        Google Chrome NOT INSTALLED"
}

if (Test-Path "HKLM:\SOFTWARE\mozilla.org\Mozilla") {
    $ffVersion = (Get-ItemProperty Registry::HKEY_LOCAL_MACHINE\SOFTWARE\mozilla.org\Mozilla).CurrentVersion
    Add-Content $path "        Mozilla Firefox (v$ffVersion)"
}

else {
    Write-Host Mozilla Firefox NOT INSTALLED
    Add-Content $path "        Mozilla Firefox NOT INSTALLED"
}

If (Test-Path 'Get-ItemProperty HKLM:\software\wow6432Node\mcafee\avengine') {
    $mcAfee = Get-ItemProperty HKLM:\software\wow6432Node\mcafee\avengine
    $mcAfeeDATVer = $mcAfee.AVDatVersion
    $mcAfeeDATDate = $mcAfee.AVDatDATE

    Add-Content $path "        McAfee DAT $mcAfeeDATVer ($mcAfeeDATDate)"
}

Add-Content $path "
------------------------------------------------------------
"

Add-Content $path "NOTES:"
if ($readmeExists) {Add-Content $path $notes}

if ($userNote -ne "") {
    $newNote = (Get-Date).ToString('MM/dd/yy') + " " 
    $newNote += $userNote
    $newNote += " ($initials)"
    Add-Content $path $newNote
}

Write-Host 'Successfully created readme'

# Unmap the PSDrive
Remove-PSDrive -name "N" -Force


