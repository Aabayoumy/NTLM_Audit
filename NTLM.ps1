if (!([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544')) { clear-host; Read-Host "Please run PowerShell As Administrator and rerun this commands, Press any key to exit"; exit }
$OutputPath = "C:\_GB\"; If(!(test-path -PathType container $OutputPath)){ MKDIR $OutputPath }
$OutputFile = "$OutputPath\NTLM_$($env:computername)_$((Get-Date).ToString('dd-MMMM-yyyy')).csv"
$Events = Get-WinEvent -Logname security -FilterXPath "Event[System[(EventID=4624)]]and (Event[EventData[Data[@Name='LmPackageName']='NTLM V2']] or Event[EventData[Data[@Name='LmPackageName']='NTLM V1']])" | Select-Object `
@{Label='Time';Expression={$_.TimeCreated.ToString('g')}},
@{Label='DC';Expression={$_.MachineName}},
@{Label='UserName';Expression={$_.Properties[5].Value}},
@{Label='WorkstationName';Expression={$_.Properties[11].Value}},
@{Label='WorkstationIP';Expression={$_.Properties[18].Value}},
@{Label='LogonType';Expression={$_.properties[8].value}},
@{Label='LmPackageName';Expression={$_.properties[14].value}},
@{Label='ImpersonationLevel';Expression={$_.properties[20].value}}
$Events | Export-Csv $OutputFile -NoTypeInformation
