function GenerateForm {
#region Import the Assemblies
[reflection.assembly]::loadwithpartialname(“System.Windows.Forms”) | Out-Null
[reflection.assembly]::loadwithpartialname(“System.Drawing”) | Out-Null
#endregion

#region Generated Form Objects
$form1 = New-Object System.Windows.Forms.Form
$form1.FormBorderStyle = 'Fixed3D'
$form1.MaximizeBox = $false

$button3 = New-Object System.Windows.Forms.Button
$button2 = New-Object System.Windows.Forms.Button
$tabControl1 = New-Object System.Windows.Forms.TabControl
$computerTab = New-Object System.Windows.Forms.TabPage
$dbTab = New-Object System.Windows.Forms.TabPage
$buttonGB = New-Object System.Windows.Forms.GroupBox
$label1 = New-Object System.Windows.Forms.Label
$label2 = New-Object System.Windows.Forms.Label
$createTB = New-Object System.Windows.Forms.TextBox
$assignedCB = New-Object System.Windows.Forms.ComboBox
$modelCB = New-Object System.Windows.Forms.ComboBox
$categoryCB = New-Object System.Windows.Forms.ComboBox
$usbCB = New-Object System.Windows.Forms.ComboBox
$osCB = New-Object System.Windows.Forms.ComboBox
$Database = New-Object System.Windows.Forms.TabPage
$utilTab = New-Object System.Windows.Forms.TabPage
$taskmgrBtn = New-Object System.Windows.Forms.Button
$fontDialog1 = New-Object System.Windows.Forms.FontDialog
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

#———————————————-
#Generated Event Script Blocks
#———————————————-
$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
$form1.WindowState = $InitialFormWindowState
}

#———————————————-
#region Generated Form Code
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 600
$System_Drawing_Size.Width = 600
$form1.ClientSize = $System_Drawing_Size
$form1.Name = “form1”
$form1.Text = “DevIT Toolkit”


$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 136
$System_Drawing_Point.Y = 83
$tabControl1.Location = (0,0)
$tabControl1.Name = “tabControl1”
$tabControl1.SelectedIndex = 0
$tabControl1.ShowToolTips = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 600
$System_Drawing_Size.Width = 600
$tabControl1.Size = $System_Drawing_Size
$tabControl1.TabIndex = 4

$form1.Controls.Add($tabControl1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 4
$System_Drawing_Point.Y = 22
$computerTab.Location = $System_Drawing_Point
$computerTab.Name = “tabControl”
$System_Windows_Forms_Padding = New-Object System.Windows.Forms.Padding
$System_Windows_Forms_Padding.All = 3
$System_Windows_Forms_Padding.Bottom = 3
$System_Windows_Forms_Padding.Left = 3
$System_Windows_Forms_Padding.Right = 3
$System_Windows_Forms_Padding.Top = 3
$computerTab.Padding = $System_Windows_Forms_Padding
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 444
$System_Drawing_Size.Width = 704
$computerTab.Size = $System_Drawing_Size
$computerTab.TabIndex = 0
$computerTab.Text = “Computer”
$computerTab.UseVisualStyleBackColor = $True

$tabControl1.Controls.Add($computerTab)


$System_Drawing_Point.X = 500
$System_Drawing_Point.Y = 50
$label1.Location = $System_Drawing_Point
$taskmgrBtn.Name = “taskmgrBtn”
$taskmgrBtn.Size = (50, 100)
$taskmgrBtn.TabIndex = 1
$taskmgrBtn.TabStop = $True
$taskmgrBtn.Text = “Task Manager”
$taskmgrBtn.UseVisualStyleBackColor = $True
$form1.Controls.Add($taskmgrBtn)


$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 5
$label1.Location = $System_Drawing_Point
$label1.Name = “label1”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 192
$label1.Size = $System_Drawing_Size
$label1.TabIndex = 2
$label1.Text = “Computer Specs”
$computerTab.Controls.Add($label1)

$specsDGV                   = New-Object system.Windows.Forms.DataGridView
$specsDGv.AutoSizeColumnsMode = 'AllCells'
$specsDGV.width             = 425
$specsDGV.height            = 311
$specsDGV.location          = New-Object System.Drawing.Point(17,25)
$specsDGV.ColumnCount = 2
$specsDGV.ColumnHeadersVisible = $false

$specsDGV.RowHeadersVisible = $false
$specsDGV.AutoSizeColumnsMode = 'Fill'
$specsDGV.AllowUserToResizeRows = $false
$specsDGV.selectionmode = 'FullRowSelect'
$specsDGV.MultiSelect = $false
$specsDGV.AllowUserToAddRows = $false
$specsDGV.ReadOnly = $true

$specsDGV.Rows.Add("Host Name", $env:COMPUTERNAME)
$specsDGV.Rows.Add("Domain", (Get-WmiObject Win32_ComputerSystem).Domain)
$specsDGV.Rows.Add("Model", (Get-WmiObject -Class:Win32_ComputerSystem).Model)
$specsDGV.Rows.Add("Serial Number", (gwmi win32_bios).SerialNumber)

$biosInfo = Get-WMIObject -Class Win32_BIOS
$biosVal = $biosInfo.Manufacturer + ' ' + $biosInfo.SMBIOSBIOSVERSION + ', ' + ([datetime]::ParseExact(($biosInfo.Version -split ' ' | select -Last 1),”yyyyMMdd”,$null)).toshortdatestring()
$specsDGV.Rows.Add("BIOS Version", $biosVal)


$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
$os = $osInfo.Caption
$version = (Get-WmiObject Win32_OperatingSystem).Version
$os = $os 
$specsDGV.Rows.Add("Operating System", $os)
$specsDGV.Rows.Add("Release Version", (Get-ItemProperty -Path ‘HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion’).ReleaseId + " (" + $version + ")")


$cpu = gwmi win32_Processor
$cpuName = $cpu.Name -replace '\s+', ' '
$specsDGV.Rows.Add("CPU", $cpuName)

$ram = [string][Math]::Round((Get-WmiObject -class Win32_ComputerSystem).TotalPhysicalMemory/1GB) + ' GB'
$ip = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | where {$_.DefaultIPGateway -ne $null}).IPAddress | select-object -first 1
$specsDGV.Rows.Add("RAM", $ram)
$specsDGV.Rows.Add("Last Boot", (Get-CimInstance -ClassName win32_operatingsystem).lastbootuptime)
$specsDGV.Rows.Add("IP Address", $ip)
$specsDGV.Rows.Add("Display Adapter", (Get-WmiObject Win32_VideoController).Caption)
$specsDGV.Rows.Add("McAfee Agent", (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object {$_.DisplayName -like "McAfee*"})[0].DisplayVersion)

$DATVersion = ""

if (Test-Path 'HKLM:\software\wow6432Node\mcafee\avengine') {
    $mcAfee = Get-ItemProperty HKLM:\software\wow6432Node\mcafee\avengine
    $mcAfeeDATVer = $mcAfee.AVDatVersion
    $mcAfeeDATDate = $mcAfee.AVDatDATE
    $DATVersion = [String]$mcAfeeDATVer + " (" + [String]$mcAfeeDATDate + ")"
}

$specsDGV.Rows.Add("DAT Version", $DATVersion)

$computerTab.Controls.Add($specsDGV)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 344
$label2.Location = $System_Drawing_Point
$label2.Name = “label1”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 192
$label2.Size = $System_Drawing_Size
$label2.TabIndex = 2
$label2.Text = “Installed Programs”

$computerTab.Controls.Add($label2)


$programsDGV                       = New-Object system.Windows.Forms.DataGridView
$programsDGV.AutoSizeColumnsMode = 'AllCells'
$programsDGV.width                 = 560
$programsDGV.height                = 200
$programsDGV.location              = New-Object System.Drawing.Point(17,365)
$programsDGV.ColumnCount = 3
$programsDGV.ColumnHeadersVisible = $true

$programsDGV.Columns[0].Name = "Name"
$programsDGV.Columns[1].Name = "Version"
$programsDGV.Columns[2].Name = "Publisher"

$programsDGV.RowHeadersVisible = $false
$programsDGV.AutoSizeColumnsMode = 'Fill'
$programsDGV.AllowUserToResizeRows = $false
$programsDGV.selectionmode = 'FullRowSelect'
$programsDGV.MultiSelect = $false
$programsDGV.AllowUserToAddRows = $false
$programsDGV.ReadOnly = $true

foreach ($p in Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher) {
    if ($p.DisplayName -ne $null) { $programsDGV.Rows.Add($p.DisplayName, $p.DisplayVersion, $p.Publisher) }}


$computerTab.Controls.Add($programsDGV)






# Set to the first item
$comboBox1.SelectedIndex = 0;
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 4
$System_Drawing_Point.Y = 22
$Database.Location = $System_Drawing_Point
$Database.Name = “Database”
$System_Windows_Forms_Padding = New-Object System.Windows.Forms.Padding
$System_Windows_Forms_Padding.All = 3
$System_Windows_Forms_Padding.Bottom = 3
$System_Windows_Forms_Padding.Left = 3
$System_Windows_Forms_Padding.Right = 3
$System_Windows_Forms_Padding.Top = 3
$Database.Padding = $System_Windows_Forms_Padding
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 444
$System_Drawing_Size.Width = 704
$Database.Size = $System_Drawing_Size
$Database.TabIndex = 1
$Database.Text = “Database”
$Database.UseVisualStyleBackColor = $True

$tabControl1.Controls.Add($Database)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 4
$System_Drawing_Point.Y = 22
$utilTab.Location = $System_Drawing_Point
$utilTab.Name = “utilTab”
$System_Windows_Forms_Padding = New-Object System.Windows.Forms.Padding
$System_Windows_Forms_Padding.All = 3
$System_Windows_Forms_Padding.Bottom = 3
$System_Windows_Forms_Padding.Left = 3
$System_Windows_Forms_Padding.Right = 3
$System_Windows_Forms_Padding.Top = 3
$utilTab.Padding = $System_Windows_Forms_Padding
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 600
$System_Drawing_Size.Width = 600
$utilTab.Size = $System_Drawing_Size
$utilTab.TabIndex = 2
$utilTab.Text = “Utilities”
$utilTab.UseVisualStyleBackColor = $True

$tabControl1.Controls.Add($utilTab)

$taskMgrBtn                         = New-Object system.Windows.Forms.Button
$taskMgrBtn.text                    = "Task Mgr"
$taskMgrBtn.width                   = 125
$taskMgrBtn.height                  = 30
$taskMgrBtn.location                = New-Object System.Drawing.Point(455,25)
$taskMgrBtn.Font                    = 'Microsoft Sans Serif,9'
$taskMgrBtn.UseVisualStyleBackColor = $True
$computerTab.Controls.Add($taskMgrBtn)

$taskmgrBtn.Add_Click({
    Taskmgr
})

$devmgrBtn                         = New-Object system.Windows.Forms.Button
$devmgrBtn.text                    = "Device Mgr"
$devmgrBtn.width                   = 125
$devmgrBtn.height                  = 30
$devmgrBtn.location                = New-Object System.Drawing.Point(455,65)
$devmgrBtn.Font                    = 'Microsoft Sans Serif,9'
$devmgrBtn.UseVisualStyleBackColor = $True
$computerTab.Controls.Add($devmgrBtn)

$devmgrBtn.Add_Click({
    Devmgmt
})


$compmgrBtn                         = New-Object system.Windows.Forms.Button
$compmgrBtn.text                    = "Computer Mgr"
$compmgrBtn.width                   = 125
$compmgrBtn.height                  = 30
$compmgrBtn.location                = New-Object System.Drawing.Point(455,105)
$compmgrBtn.Font                    = 'Microsoft Sans Serif,9'
$compmgrBtn.UseVisualStyleBackColor = $True
$computerTab.Controls.Add($compmgrBtn)

$compmgrBtn.Add_Click({
    Compmgmt
})

$diskmgrBtn                         = New-Object system.Windows.Forms.Button
$diskmgrBtn.text                    = "Disk Mgr"
$diskmgrBtn.width                   = 125
$diskmgrBtn.height                  = 30
$diskmgrBtn.location                = New-Object System.Drawing.Point(455,145)
$diskmgrBtn.Font                    = 'Microsoft Sans Serif,9'
$diskmgrBtn.UseVisualStyleBackColor = $True
$computerTab.Controls.Add($diskmgrBtn)

$diskmgrBtn.Add_Click({
    Diskmgmt
})


$rdpBtn                         = New-Object system.Windows.Forms.Button
$rdpBtn.text                    = "RDP"
$rdpBtn.width                   = 125
$rdpBtn.height                  = 30
$rdpBtn.location                = New-Object System.Drawing.Point(455,185)
$rdpBtn.Font                    = 'Microsoft Sans Serif,9'
$rdpBtn.UseVisualStyleBackColor = $True
$computerTab.Controls.Add($rdpBtn)

$rdpBtn.Add_Click({
    Mstsc
})

$regeditBtn                         = New-Object system.Windows.Forms.Button
$regeditBtn.text                    = "Regedit"
$regeditBtn.width                   = 125
$regeditBtn.height                  = 30
$regeditBtn.location                = New-Object System.Drawing.Point(455,225)
$regeditBtn.Font                    = 'Microsoft Sans Serif,9'
$regeditBtn.UseVisualStyleBackColor = $True
$computerTab.Controls.Add($regeditBtn)

$regeditBtn.Add_Click({
    Regedit
})


$syspropBtn                         = New-Object system.Windows.Forms.Button
$syspropBtn.text                    = "System Prop."
$syspropBtn.width                   = 125
$syspropBtn.height                  = 30
$syspropBtn.location                = New-Object System.Drawing.Point(455,265)
$syspropBtn.Font                    = 'Microsoft Sans Serif,9'
$syspropBtn.UseVisualStyleBackColor = $True
$computerTab.Controls.Add($syspropBtn)

$syspropBtn.Add_Click({
    Sysdm.cpl
})


$servicesBtn                         = New-Object system.Windows.Forms.Button
$servicesBtn.text                    = "Services"
$servicesBtn.width                   = 125
$servicesBtn.height                  = 30
$servicesBtn.location                = New-Object System.Drawing.Point(455,306)
$servicesBtn.Font                    = 'Microsoft Sans Serif,9'
$servicesBtn.UseVisualStyleBackColor = $True
$computerTab.Controls.Add($servicesBtn)

$servicesBtn.Add_Click({
    services.msc
})


# --------------------------------------------------------------------------

$labelCreateNew = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 25
$labelCreateNew.Location = $System_Drawing_Point
$labelCreateNew.Name = “Create new”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 80
$labelCreateNew.Size = $System_Drawing_Size
$labelCreateNew.TabIndex = 2
$labelCreateNew.Text = “Create new”
$Database.Controls.Add($labelCreateNew)

$labelInsertNew = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 120
$labelInsertNew.Location = $System_Drawing_Point
$labelInsertNew.Name = “Insert new Asset”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 200
$labelInsertNew.Size = $System_Drawing_Size
$labelInsertNew.TabIndex = 2
$labelInsertNew.Text = “Insert new Asset”
$Database.Controls.Add($labelInsertNew)


$labelAssetNo = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 150
$labelAssetNo.Location = $System_Drawing_Point
$labelAssetNo.Name = “Asset #”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 50
$labelAssetNo.Size = $System_Drawing_Size
$labelAssetNo.TabIndex = 2
$labelAssetNo.Text = “Asset#”
$Database.Controls.Add($labelAssetNo)


$assetTB = New-Object System.Windows.Forms.TextBox
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 75
$System_Drawing_Point.Y = 150
$assetTB.Location = $System_Drawing_Point
$assetTB.Name = “Asset TB”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 100
$assetTB.Size = $System_Drawing_Size
$assetTB.TabIndex = 2
$Database.Controls.Add($assetTB)


$assignedLabel = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 185
$System_Drawing_Point.Y = 150
$assignedLabel.Location = $System_Drawing_Point
$assignedLabel.Name = “AssignedTo”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 100
$assignedLabel.Size = $System_Drawing_Size
$assignedLabel.TabIndex = 2
$assignedLabel.Text = “Assigned To”
$Database.Controls.Add($assignedLabel)


$assignedCB.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 285
$System_Drawing_Point.Y = 150
$assignedCB.Location = $System_Drawing_Point
$assignedCB.Name = “assignedCB”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 115
$assignedCB.Size = $System_Drawing_Size
$assignedCB.TabIndex = 0


# SQL
[reflection.assembly]::LoadWithPartialname("MySQL.Data")
$conn = new-object system.data.oledb.oledbconnection
$conn.connectionstring = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\database.mdb"
$conn.open()

$cmd = new-object System.Data.OleDb.OleDbCommand
$cmd.Connection = $conn
$cmd.CommandText = "SELECT DISTINCT assignedTo FROM Asset"
$reader = $cmd.ExecuteReader()

$table = new-object “System.Data.DataTable”
$table.Load($reader)

$persons = New-Object System.Collections.Generic.List[string]
$persons.Add("")
foreach ($r in $table.Rows) { $persons.Add($r[0]) }

$reader.close()
$conn.close()

foreach ($p in $persons){ $assignedCB.items.add($p) }
$Database.Controls.Add($assignedCB)


$modelLabel = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 415
$System_Drawing_Point.Y = 150
$modelLabel.Location = $System_Drawing_Point
$modelLabel.Name = “Model”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 50
$modelLabel.Size = $System_Drawing_Size
$modelLabel.TabIndex = 2
$modelLabel.Text = “Model”
$Database.Controls.Add($modelLabel)

$modelCB.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 470
$System_Drawing_Point.Y = 150
$modelCB.Location = $System_Drawing_Point
$modelCB.Name = “assignedCB”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 105
$modelCB.Size = $System_Drawing_Size
$modelCB.TabIndex = 0

$models = @("", "Z400 DIMM", "Z420", "Z440", "Precision 5530", "Precision 5540", "Precision 5820", "Zbook 15", "Zbook 15 G2", "Zbook 15 G3", "Zbook 15 G5", "EliteBook 8460w", "EliteBook 8470w", "EliteBook 8570w", "P2319H", "Ultrasharp U2419H", "E231i", "Z23n", "VP2365-LED", "VP2765-LED")
foreach ($m in $models) { $modelCB.items.add($m) }
$Database.Controls.Add($modelCB)


$categoryCB.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 110
$System_Drawing_Point.Y = 25
$categoryCB.Location = $System_Drawing_Point
$categoryCB.Name = “comboBox1”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 110
$categoryCB.Size = $System_Drawing_Size
$categoryCB.TabIndex = 0

$commands = @("Categories", "tbAssignedTo", "tblMfgr")
foreach ($command in $commands){ $categoryCB.items.add($command) }
$Database.Controls.Add($categoryCB)



$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 230
$System_Drawing_Point.Y = 26
$createTB.Location = $System_Drawing_Point
$createTB.Name = “createTB”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 50
$System_Drawing_Size.Width = 170
$createTB.Size = $System_Drawing_Size
$createTB.TabIndex = 1
$Database.Controls.Add($createTB)

$createBtn                         = New-Object system.Windows.Forms.Button
$createBtn.text                    = "CREATE"
$createBtn.width                   = 160
$createBtn.height                  = 25
$createBtn.location                = New-Object System.Drawing.Point(415, 25)
$createBtn.Font                    = 'Microsoft Sans Serif,10'
$createBtn.UseVisualStyleBackColor = $True
$Database.Controls.Add($createBtn)


$createBtn.Add_Click({
    if ($categoryCB.SelectedItem -ne $null -and $createTB.Text -ne '') {
        [reflection.assembly]::LoadWithPartialname("MySQL.Data")
        $conn = new-object system.data.oledb.oledbconnection
        $conn.connectionstring = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\database.mdb"
        $conn.open()

        $cmd = new-object System.Data.OleDb.OleDbCommand
        $cmd.Connection = $conn
    
        if ($categoryCB.SelectedItem -eq "Categories") { $cmd.CommandText = "INSERT INTO " + $categoryCB.SelectedItem + " (categories) VALUES ('" + $createTB.Text + "')" }
        elseif ($categoryCB.SelectedItem -eq "tblMfgr") { $cmd.CommandText = "INSERT INTO " + $categoryCB.SelectedItem + " (Manufacturer) VALUES ('" + $createTB.Text + "')" }
        elseif ($categoryCB.SelectedItem -eq "tbAssignedTo") { $cmd.CommandText = "INSERT INTO " + $categoryCB.SelectedItem + " (AssignedTo, Dept) VALUES ('" + $createTB.Text + "', 'Lake Forest')" }

        $a = $cmd.ExecuteNonQuery()
        $conn.close()
    }
})


$notesTBLabel = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 180
$notesTBLabel.Location = $System_Drawing_Point
$notesTBLabel.Name = “Notes”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 50
$notesTBLabel.Size = $System_Drawing_Size
$notesTBLabel.TabIndex = 2
$notesTBLabel.Text = “Notes”
$Database.Controls.Add($notesTBLabel)

$notesTB = New-Object System.Windows.Forms.TextBox
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 75
$System_Drawing_Point.Y = 180
$notesTB.Location = $System_Drawing_Point
$notesTB.Name = “Notes TB”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 100
$System_Drawing_Size.Width = 210
$notesTB.Size = $System_Drawing_Size
$notesTB.TabIndex = 2
$Database.Controls.Add($notesTB)


$serialLabel = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 290
$System_Drawing_Point.Y = 180
$serialLabel.Location = $System_Drawing_Point
$serialLabel.Name = “Notes”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 30
$serialLabel.Size = $System_Drawing_Size
$serialLabel.TabIndex = 2
$serialLabel.Text = “S/N”
$Database.Controls.Add($serialLabel)

$serialTB= New-Object System.Windows.Forms.TextBox
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 320
$System_Drawing_Point.Y = 180
$serialTB.Location = $System_Drawing_Point
$serialTB.Name = “Notes TB”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 80
$serialTB.Size = $System_Drawing_Size
$serialTB.TabIndex = 2
$Database.Controls.Add($serialTB)


$insertBtn                         = New-Object system.Windows.Forms.Button
$insertBtn.text                    = "INSERT"
$insertBtn.width                   = 160
$insertBtn.height                  = 25
$insertBtn.location                = New-Object System.Drawing.Point(415, 180)
$insertBtn.Font                    = 'Microsoft Sans Serif,10'
$insertBtn.UseVisualStyleBackColor = $True
$Database.Controls.Add($insertBtn)


$insertBtn.Add_Click(
{
    if ($assetTB.Text -ne '' -and $assignedCB.SelectedItem -ne $null -and $modelCB.SelectedItem -ne $null -and $serialTB.Text -ne '') {
        [reflection.assembly]::LoadWithPartialname("MySQL.Data")
        $conn = new-object system.data.oledb.oledbconnection
        $conn.connectionstring = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\database.mdb"
        $conn.open()

        $cmd = new-object System.Data.OleDb.OleDbCommand
        $cmd.Connection = $conn
    
        $cmd.CommandText = "INSERT INTO Asset (assetNumber, assignedTo, categories, Manufacturer, ModelNbrOrDescription, SerialNbr, notes) VALUES ('" + 
                            ($assetTB.Text).ToUpper() + "', '" + 
                            $assignedCB.SelectedItem + "', '" + 
                            $categoryCB.SelectedItem + "', '"
                            "')"

        $a = $cmd.ExecuteNonQuery()
        $conn.close()
    }
})



$invLabel = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 270
$invLabel.Location = $System_Drawing_Point
$invLabel.Name = “Find Inventory”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 90
$invLabel.Size = $System_Drawing_Size
$invLabel.TabIndex = 2
$invLabel.Text = “Inventory”
$Database.Controls.Add($invLabel)


$invassetTB = New-Object System.Windows.Forms.TextBox
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 110
$System_Drawing_Point.Y = 270
$invassetTB.Location = $System_Drawing_Point
$invassetTB.Name = “Inv Asset TB”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 100
$invassetTB.Size = $System_Drawing_Size
$invassetTB.TabIndex = 2
$Database.Controls.Add($invassetTB)


$invassetLabel = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 138
$System_Drawing_Point.Y = 250
$invassetLabel.Location = $System_Drawing_Point
$invassetLabel.Name = “Inv Asset Label”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 80
$invassetLabel.Size = $System_Drawing_Size
$invassetLabel.TabIndex = 2
$invassetLabel.Text = “Asset #”
$Database.Controls.Add($invassetLabel)


$invmodelLabel = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 243
$System_Drawing_Point.Y = 250
$invmodelLabel.Location = $System_Drawing_Point
$invmodelLabel.Name = “Select Asset”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 100
$invmodelLabel.Size = $System_Drawing_Size
$invmodelLabel.TabIndex = 2
$invmodelLabel.Text = “Select Asset”
$Database.Controls.Add($invmodelLabel)



$invmodelCB = New-Object System.Windows.Forms.ComboBox
$invmodelCB.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 220
$System_Drawing_Point.Y = 270
$invmodelCB.Location = $System_Drawing_Point
$invmodelCB.Name = “invCB”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 120
$invmodelCB.Size = $System_Drawing_Size
$invmodelCB.TabIndex = 0

foreach ($m in $models){ $invmodelCB.items.add($m) }
$Database.Controls.Add($invmodelCB)


$invassignLabel = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 370
$System_Drawing_Point.Y = 250
$invassignLabel.Location = $System_Drawing_Point
$invassignLabel.Name = “Selected Assignee”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 120
$invassignLabel.Size = $System_Drawing_Size
$invassignLabel.TabIndex = 2
$invassignLabel.Text = “Select Assignee”
$Database.Controls.Add($invassignLabel)

$invassignCB = New-Object System.Windows.Forms.ComboBox
$invassignCB.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 350
$System_Drawing_Point.Y = 270
$invassignCB.Location = $System_Drawing_Point
$invassignCB.Name = “assignCB”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 140
$invassignCB.Size = $System_Drawing_Size
$invassignCB.TabIndex = 0

foreach ($p in $persons) { $invassignCB.items.add($p) }
$Database.Controls.Add($invassignCB)



$invBtn = New-Object System.Windows.Forms.Button
$invBtn                         = New-Object system.Windows.Forms.Button
$invBtn.text                    = "GO"
$invBtn.width                   = 75
$invBtn.height                  = 24
$invBtn.location                = New-Object System.Drawing.Point(500, 270)
$invBtn.Font                    = 'Microsoft Sans Serif,10'
$invBtn.UseVisualStyleBackColor = $True
$Database.Controls.Add($invBtn)

$invBtn.Add_Click(
    {
    [reflection.assembly]::LoadWithPartialname("MySQL.Data")
    $conn = new-object system.data.oledb.oledbconnection
    $conn.connectionstring = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\database.mdb"
    $conn.open()

    $cmd = new-object System.Data.OleDb.OleDbCommand
    $cmd.Connection = $conn

    # Asset Number box filled
    if     ($invassetTB.Text -ne '') { $cmd.CommandText = "SELECT assetNumber, assignedTo, Manufacturer, ModelNbrOrDescription, SerialNbr FROM Asset WHERE assetNumber = '" + $invassetTB.Text + "'" }

    # Only Model box is filled
    elseif ($invmodelCB.SelectedItem -notin ($null, "") -and $invassignCB.SelectedItem -in ($null, "")) { $cmd.CommandText = "SELECT assetNumber, assignedTo, Manufacturer, ModelNbrOrDescription, SerialNbr FROM Asset WHERE ModelNbrOrDescription = '" + $invmodelCB.SelectedItem + "'" }

    # Only AssignedTo box is filled
    elseif ($invmodelCB.SelectedItem -in ("", $null) -and $invassignCB.SelectedItem -notin ("", $null)) { $cmd.CommandText = "SELECT assetNumber, assignedTo, Manufacturer, ModelNbrOrDescription, SerialNbr FROM Asset WHERE assignedTo = '" + $invassignCB.SelectedItem + "'" }

    # Both Model and AssignedTo are filled
    else   { $cmd.CommandText = "SELECT assetNumber, assignedTo, Manufacturer, ModelNbrOrDescription, SerialNbr FROM Asset WHERE ModelNbrOrDescription = '" + $invmodelCB.SelectedItem + "' AND assignedTo = '" + $invassignCB.SelectedItem + "'" }

    write-host $cmd.CommandText
    $reader = $cmd.ExecuteReader()

    $table = new-object “System.Data.DataTable”
    $table.Load($reader)
    $invDGV.DataSource = $table

    $reader.close()
    $conn.close()
    
    $Database.Controls.Add($invDGV)
    }
)
        

$invDGV                   = New-Object system.Windows.Forms.DataGridView
$invDGV                       = New-Object system.Windows.Forms.DataGridView
$invDGV.width                 = 560
$invDGV.height                = 240
$invDGV.location              = New-Object System.Drawing.Point(17,320)
$invDGV.ColumnHeadersVisible = $true

$invDGV.RowHeadersVisible = $false
$invDGV.AutoSizeColumnsMode = 'Fill'
$invDGV.AllowUserToResizeRows = $false
$invDGV.selectionmode = 'FullRowSelect'
$invDGV.MultiSelect = $false
$invDGV.AllowUserToAddRows = $false
$invDGV.ReadOnly = $true

$Database.Controls.Add($invDGV)




$usbCB.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 150
$System_Drawing_Point.Y = 40
$usbCB.Location = $System_Drawing_Point
$usbCB.Name = “comboBox2”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 145
$usbCB.Size = $System_Drawing_Size
$usbCB.TabIndex = 0

$usbs = Get-WmiObject Win32_Volume -Filter "DriveType='2'"
foreach ($u in $usbs) { $usbCB.items.add($u.Label + " (" + $u.DriveLetter + ") [" + [math]::round($u.Capacity / 1GB) + "GB]") }
$utilTab.Controls.Add($usbCB)



$osCB.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 300
$System_Drawing_Point.Y = 40
$osCB.Location = $System_Drawing_Point
$osCB.Name = “comboBox2”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 150
$osCB.Size = $System_Drawing_Size
$osCB.TabIndex = 0

$oses = @("None", "WinPE", "Windows 10 Enterprise", "Server 2012 R2", "Server 2016", "Server 2019", "SpinRite", "DBAN")
foreach ($o in $oses) { $osCB.items.add($o) }
$utilTab.Controls.Add($osCB)


$usbBtn                         = New-Object system.Windows.Forms.Button
$usbBtn.text                    = "CREATE"
$usbBtn.width                   = 117
$usbBtn.height                  = 24
$usbBtn.location                = New-Object System.Drawing.Point(460, 40)
$usbBtn.Font                    = 'Microsoft Sans Serif,10'
$usbBtn.UseVisualStyleBackColor = $True
$utilTab.Controls.Add($usbBtn)


$usbBtn.Add_Click({
    if ($usbCB.SelectedItem -ne $null) {
        foreach ($u in $usbs) {
            if ($u.DriveLetter -in $usbCB.SelectedItem) { $driveLetter = $u.DriveLetter; break }
        }
        
        write-host $driveLetter
        $selectedOS = $osCB.SelectedItem
        switch ($selectedOS) {
            "None"  {
                Format-Volume -DriveLetter $driveLetter -FileSystem NTFS
                break}
            "WinPE"   {
                Format-Volume -DriveLetter $driveLetter -FileSystem FAT32 -whatif
                Copy-Item -Recurse \\domain\OS\winpe\*  $driveLetter
                break}
            "Windows 10 Enterprise" {
                Format-Volume -DriveLetter $driveLetter -FileSystem $fs NTFS
                Copy-Item -Recurse \\domain\OS\1909\*  $driveLetter
                break}
            "Server 2012 R2"  {
                Format-Volume -DriveLetter $driveLetter -FileSystem $fs NTFS
                Copy-Item -Recurse \\domain\OS\2012\*  $driveLetter
                break}
            "Server 2016" {
                Format-Volume -DriveLetter $driveLetter -FileSystem $fs NTFS
                Copy-Item -Recurse \\domain\OS\2016\*  $driveLetter
                break}
            "Server 2019" {
                Format-Volume -DriveLetter $driveLetter -FileSystem $fs NTFS
                Copy-Item -Recurse \\domain\OS\2019\*  $driveLetter
                break}
            "SpinRite" {
                Format-Volume -DriveLetter $driveLetter -FileSystem $fs FAT32
                Copy-Item  \\domain\SpinRite.exe  $driveLetter
                break}
            "DBAN" {
                Format-Volume -DriveLetter $driveLetter -FileSystem $fs FAT32
                Copy-Item -Recurse \\domain\DBAN\*  $driveLetter
                break}
        default {"No proper OS selection"}
        }
    }                                                    
})

$labelCreateUsb = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 40
$labelCreateUsb.Location = $System_Drawing_Point
$labelCreateUsb.Name = “Create Bootable USB”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 40
$System_Drawing_Size.Width = 130
$labelCreateUsb.Size = $System_Drawing_Size
$labelCreateUsb.TabIndex = 2
$labelCreateUsb.Text = “Create Bootable USB”
$utilTab.Controls.Add($labelCreateUsb)


$selectUsbLabel = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 185
$System_Drawing_Point.Y = 20
$selectUsbLabel.Location = $System_Drawing_Point
$selectUsbLabel.Name = “Select USB”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 80
$selectUsbLabel.Size = $System_Drawing_Size
$selectUsbLabel.TabIndex = 2
$selectUsbLabel.Text = “Select USB”
$utilTab.Controls.Add($selectUsbLabel)


$selectOsLabel = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 315
$System_Drawing_Point.Y = 20
$selectOsLabel.Location = $System_Drawing_Point
$selectOsLabel.Name = “Select OS/Program”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 150
$selectOsLabel.Size = $System_Drawing_Size
$selectOsLabel.TabIndex = 2
$selectOsLabel.Text = “Select OS/Program”
$utilTab.Controls.Add($selectOsLabel)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Name = 'progressBar'
$progressBar.Value = 0
$progressBar.Style="Continuous"
$progressBar.width                   = 300
$progressBar.height                  = 25
$progressBar.location                = New-Object System.Drawing.Point(150, 75)
$utilTab.Controls.Add($progressBar)

$updateFixBtn                         = New-Object system.Windows.Forms.Button
$updateFixBtn.text                    = "Windows Update Fix"
$updateFixBtn.width                   = 125
$updateFixBtn.height                  = 50
$updateFixBtn.location                = New-Object System.Drawing.Point(75, 110)
$updateFixBtn.Font                    = 'Microsoft Sans Serif,10'
$updateFixBtn.UseVisualStyleBackColor = $True
$utilTab.Controls.Add($updateFixBtn)

$updateFixBtn.Add_Click({
    start-process -Credential $credentials \\domain\run_winupdatefixit.bat -computername $env:COMPUTERNAME
})


$zscalerBtn                         = New-Object system.Windows.Forms.Button
$zscalerBtn.text                    = "Auto zScaler"
$zscalerBtn.width                   = 125
$zscalerBtn.height                  = 50
$zscalerBtn.location                = New-Object System.Drawing.Point(225, 110)
$zscalerBtn.Font                    = 'Microsoft Sans Serif,10'
$zscalerBtn.UseVisualStyleBackColor = $True
$utilTab.Controls.Add($zscalerBtn)

$zscalerBtn.Add_Click({
    start-process \\domain\zscaler_logon_task.bat
})

$gpupdateBtn                         = New-Object system.Windows.Forms.Button
$gpupdateBtn.text                    = "GP Update"
$gpupdateBtn.width                   = 125
$gpupdateBtn.height                  = 50
$gpupdateBtn.location                = New-Object System.Drawing.Point(375, 110)
$gpupdateBtn.Font                    = 'Microsoft Sans Serif,10'
$gpupdateBtn.UseVisualStyleBackColor = $True
$utilTab.Controls.Add($gpupdateBtn)

$gpupdateBtn.Add_Click({
    Invoke-GPUpdate
})

$naBtn                         = New-Object system.Windows.Forms.Button
$naBtn.text                    = "Reset network adapters"
$naBtn.width                   = 125
$naBtn.height                  = 50
$naBtn.location                = New-Object System.Drawing.Point(75, 170)
$naBtn.Font                    = 'Microsoft Sans Serif,10'
$naBtn.UseVisualStyleBackColor = $True
$utilTab.Controls.Add($naBtn)

$naBtn.Add_Click({
    # Restart net adapters
    Get-NetAdapter | Restart-NetAdapter
    
    # Disable IPv6
    Disable-NetAdapterBinding -Name * -ComponentID ms_tcpip6 -PassThru
})


$assetReportBtn                         = New-Object system.Windows.Forms.Button
$assetReportBtn.text                    = "Asset Report"
$assetReportBtn.width                   = 125
$assetReportBtn.height                  = 50
$assetReportBtn.location                = New-Object System.Drawing.Point(225, 170)
$assetReportBtn.Font                    = 'Microsoft Sans Serif,10'
$assetReportBtn.UseVisualStyleBackColor = $True
$utilTab.Controls.Add($assetReportBtn)


$assetReportBtn.Add_ClicK({
    start-process \\domain\run_autoassetreport.bat | out-null
})


$renewBtn                         = New-Object system.Windows.Forms.Button
$renewBtn.text                    = "Renew IP Flush DNS"
$renewBtn.width                   = 125
$renewBtn.height                  = 50
$renewBtn.location                = New-Object System.Drawing.Point(375, 170)
$renewBtn.Font                    = 'Microsoft Sans Serif,10'
$renewBtn.UseVisualStyleBackColor = $True
$utilTab.Controls.Add($renewBtn)

$renewBtn.Add_Click({
    cmd.exe /c ipconfig /release
    cmd.exe /c ipconfig /renew

    # Flush DNS cache
    Clear-DnsClientCache
})

$readmeBtn                         = New-Object system.Windows.Forms.Button
$readmeBtn.text                    = "Create README"
$readmeBtn.width                   = 125
$readmeBtn.height                  = 50
$readmeBtn.location                = New-Object System.Drawing.Point(75, 230)
$readmeBtn.Font                    = 'Microsoft Sans Serif,10'
$readmeBtn.UseVisualStyleBackColor = $True
$utilTab.Controls.Add($readmeBtn)

$readmeBtn.Add_Click({
    start-process \\domain\run_autoreadme.bat
})


$devlocalBtn                         = New-Object system.Windows.Forms.Button
$devlocalBtn.text                    = "DevLocal Input Box"
$devlocalBtn.width                   = 125
$devlocalBtn.height                  = 50
$devlocalBtn.location                = New-Object System.Drawing.Point(225, 230)
$devlocalBtn.Font                    = 'Microsoft Sans Serif,10'
$devlocalBtn.UseVisualStyleBackColor = $True
$utilTab.Controls.Add($devlocalBtn)

$devlocalBtn.Add_Click({
    Invoke-Expression  \\domain\inputbox.exe
})

$windowsBtn                         = New-Object system.Windows.Forms.Button
$windowsBtn.text                    = "Windows License"
$windowsBtn.width                   = 125
$windowsBtn.height                  = 50
$windowsBtn.location                = New-Object System.Drawing.Point(375, 230)
$windowsBtn.Font                    = 'Microsoft Sans Serif,10'
$windowsBtn.UseVisualStyleBackColor = $True
$utilTab.Controls.Add($windowsBtn)

$windowsBtn.Add_Click({
    cmd.exe /c 'slmgr /dli'
})


$driverBtn                         = New-Object system.Windows.Forms.Button
$driverBtn.text                    = "Find DRIVERS for this machine"
$driverBtn.width                   = 425
$driverBtn.height                  = 30
$driverBtn.location                = New-Object System.Drawing.Point(75, 290)
$driverBtn.Font                    = 'Microsoft Sans Serif,10'
$driverBtn.UseVisualStyleBackColor = $True
$utilTab.Controls.Add($driverBtn)

$driverBtn.Add_Click({
    $model = (Get-WmiObject -Class:Win32_ComputerSystem).Model
    switch($model) {
        "HP Z400 Workstation"  { Invoke-Expression "start https://support.hp.com/us-en/drivers/selfservice/hp-z400-workstation/3718668"; break }
        "HP Z420 Workstation"  { Invoke-Expression "start https://support.hp.com/us-en/drivers/selfservice/hp-z420-workstation/5225033"; break }
        "HP Z440 Workstation"  { Invoke-Expression "start https://support.hp.com/us-en/drivers/selfservice/hp-z440-workstation/6978828"; break } 
        "Precision 5820 Tower" { Invoke-Expression "start https://www.dell.com/support/home/us/en/04/product-support/product/precision-5820-workstation/drivers"; break } 
        "Precision 5530"       { Invoke-Expression "start https://www.dell.com/support/home/us/en/04/product-support/product/precision-15-5530-laptop/drivers"; break }
        "Precision 5540"       { Invoke-Expression "start https://www.dell.com/support/home/us/en/04/product-support/product/precision-15-5540-laptop/drivers"; break }
    }
})

$adLabel = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 350
$adLabel.Location = $System_Drawing_Point
$adLabel.Name = “Find AD Item”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 100
$adLabel.Size = $System_Drawing_Size
$adLabel.TabIndex = 2
$adLabel.Text = “Find AD Item”
$utilTab.Controls.Add($adLabel)


$adselectLabel = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 140
$System_Drawing_Point.Y = 330
$adselectLabel.Location = $System_Drawing_Point
$adselectLabel.Name = “Select Asset”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 80
$adselectLabel.Size = $System_Drawing_Size
$adselectLabel.TabIndex = 2
$adselectLabel.Text = “Select Item”
$utilTab.Controls.Add($adselectLabel)

$selectadCB = New-Object System.Windows.Forms.ComboBox
$selectadCB.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 125
$System_Drawing_Point.Y = 350
$selectadCB.Location = $System_Drawing_Point
$selectadCB.Name = “assignCB”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 115
$selectadCB.Size = $System_Drawing_Size
$selectadCB.TabIndex = 0

$selectadCB.items.add("User")
$selectadCB.items.add("Computer")
$utilTab.Controls.Add($selectadCB)


$adTB= New-Object System.Windows.Forms.TextBox
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 250
$System_Drawing_Point.Y = 350
$adTB.Location = $System_Drawing_Point
$adTB.Name = “AD Textbox”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 200
$adTB.Size = $System_Drawing_Size
$adTB.TabIndex = 2
$utilTab.Controls.Add($adTB)


$advalLabel = New-Object System.Windows.Forms.Label
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 320
$System_Drawing_Point.Y = 330
$advalLabel.Location = $System_Drawing_Point
$advalLabel.Name = “Ad Val Label”
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 80
$advalLabel.Size = $System_Drawing_Size
$advalLabel.TabIndex = 2
$advalLabel.Text = “Value”
$utilTab.Controls.Add($advalLabel)


$searchadBtn = New-Object System.Windows.Forms.Button
$searchadBtn                         = New-Object system.Windows.Forms.Button
$searchadBtn.text                    = "SEARCH"
$searchadBtn.width                   = 117
$searchadBtn.height                  = 24
$searchadBtn.location                = New-Object System.Drawing.Point(460, 350)
$searchadBtn.Font                    = 'Microsoft Sans Serif,10'
$searchadBtn.UseVisualStyleBackColor = $True
$utilTab.Controls.Add($searchadBtn)

        

$adDGV                   = New-Object system.Windows.Forms.DataGridView
$adDGV                       = New-Object system.Windows.Forms.DataGridView
$adDGV.width                 = 560
$adDGV.height                = 175
$adDGV.location              = New-Object System.Drawing.Point(17,385)
$adDGV.ColumnHeadersVisible = $true
$adDGV.ColumnCount = 3

$adDGV.Columns[0].Name = "DNSHostName"
$adDGV.Columns[1].Name = "OU's"
$adDGV.Columns[2].Name = "Enabled"


$adDGV.RowHeadersVisible = $false
$adDGV.AutoSizeColumnsMode = 'Fill'
$adDGV.AllowUserToResizeRows = $false
$adDGV.selectionmode = 'FullRowSelect'
$adDGV.MultiSelect = $false
$adDGV.AllowUserToAddRows = $false
$adDGV.ReadOnly = $true


$searchadBtn.Add_Click({
    if ($adTB.Text -ne '') {
        $adDGV.Rows.Clear();
        $adDGV.Refresh();

        $userInput = $adTB.Text
        $computers = Get-ADComputer -Filter "name -like '*$userInput*'" | select DNSHostName, DistinguishedName, Enabled 
           
        foreach ($c in $computers) {
            $ouString = $c.DistinguishedName.Substring($c.DistinguishedName.IndexOf("OU"))
            $adDGV.Rows.Add($c.DNSHostName, $ouString, $c.Enabled) 
        }  

        $utilTab.Controls.Add($adDGV)      
    }
})


$utilTab.Controls.Add($adDGV)

           
#endregion Generated Form Code
#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm