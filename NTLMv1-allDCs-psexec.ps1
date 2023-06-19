if (!([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544')) { clear-host; Read-Host "Please run PowerShell As Administrator and rerun this commands, Press any key to exit"; exit }
Import-Module activedirectory 
$OutputPath = "C:\_GB"; If(!(test-path -PathType container $OutputPath)){ MKDIR $OutputPath}

foreach ($DC in (Get-ADDomainController -Filter *).HostName){
    Write-Host "Searching log on " $DC
    $RemoteOutputPath = "\\$($DC)\C$\_GB"; If(!(test-path -PathType container $RemoteOutputPath)){ MKDIR $RemoteOutputPath > $null}
    copy-item NTLM.ps1 "$($RemoteOutputPath)\NTLM.ps1" -force
   .\psexec.exe \\$DC /s cmd /c %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -file "$($OutputPath)\NTLM.ps1"
    copy-item "$RemoteOutputPath\*.csv" $OutputPath -force
}