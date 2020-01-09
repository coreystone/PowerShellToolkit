# PowerShellToolkit
A suite of PowerShell scripts to make my job easier. Includes proxy configurations, database and Active Directory queries, readme generation, software installations, and others. All encapsulated into a simple-to-use GUI.

## Introduction
This is a suite of scripts I authored in PowerShell to address many common problems/tasks that my team and I encounter. 
The project started out as a few lone scripts but later evolved into the toolkit that this is today. It may seem ironic to 
encapsulate a scripting language into a GUI that requires manual input, but I thought a GUI was an excellent medium to 
consolidate all of these scripts together into one place. A user-friendly GUI will ultimately last longer than I can maintain 
the project, and is simply more intuitive for others using it (my team).

This project was my first real introduction to PowerShell and has been a really enjoyable experience, so I am definitely going to 
continue to use PowerShell to solve my problems in the future.

## Included Scripts & Amenities
* Tab functionality to organize tools 
* Table of system specifications and compliance information
* Table of installed programs and versions
* Insert new records and attributes into database
* Query asset database and view results in table
* Format USB drives, add OS/program as bootable
* Query Active Directory computers to find OU, Active status
* Configure proxies for security and updates
* Generate inventory reports, README's 
* Check for group policy and Windows licensing compliance
* Various network troubleshooting commands
* Internal links, contacts, and other information for reference

## Walkthrough
![alt text](https://github.com/coreystone/PowerShellToolkit/blob/master/computer_tab.PNG "")

![alt text](https://github.com/coreystone/PowerShellToolkit/blob/master/database_tab.PNG "")

![alt text](https://github.com/coreystone/PowerShellToolkit/blob/master/utilities_tab.PNG "")


## Tools Used
* **System.Windows.Forms** to create buttons, windows, and other GUI functionality
* **OLDEB** (Microsoft's SQL API) to query asset database
* Batch files to run existing scripts located in a network share
