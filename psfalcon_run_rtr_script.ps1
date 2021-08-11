# When the script is run, you will be prompted for ClientId and ClientSecret for your CrowdStrike PSFalcon API
Import-Module -Name PSFalcon
#Create a CSV file with column title of Hostname and one Hostname per line, edit 'c:\Temp...' path below to match your CSV file name and location
$hostnames= (import-csv c:\Temp\hostnames.csv).Hostname
$formatted_hostnames = $hostnames | ForEach-Object {"hostname:'$_'"}
$falcon_hosts = $formatted_hostnames | ForEach-Object {get-falconhost -Filter $_}
#Prompts you for the name of the RTR Script to execute
$rtrscriptname = read-host "Enter RTR Script Name"
$commandarguments = "-CloudFile=$rtrscriptname"
#Creates a very basic output file with a true/false completion status, session identifiers, etc; named for the RTR Script you ran, with Date/Time
$ExportName = "$pwd\rtr_$($rtrscriptname -replace ' ','_')_$(Get-Date -Format FileDateTime).csv"
Invoke-FalconRTR -command runscript -arguments $commandarguments -hostids $falcon_hosts | Export-Csv -Path $ExportName
    
    if (Test-Path $ExportName) {
        # Display CSV file
        Get-ChildItem $ExportName
    }
