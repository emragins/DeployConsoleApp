#####################
# Bugfix (http://www.leeholmes.com/blog/2008/07/30/workaround-the-os-handles-position-is-not-what-filestream-expected/)

################3

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

Write-Host "==========================================================="
$datetime = Get-Date
Write-Host "Deploy started at $datetime"

$THIS_SCRIPTS_DIRECTORY = Split-Path $script:MyInvocation.MyCommand.Path

$Configuration = Read-Host 'Configuration (QA|PROD)'

IF($Configuration -eq "QA" -or $Conf -eq "qa"){
	$RemoteDir = "\\ClientWebsiteQA\AllianceOne"
}
ELSEIF($Configuration -eq "Prod" -or $Conf -eq "PROD"){
	$Configuration = "Production"
	$RemoteDir = "\\ClientWebsiteProd\AllianceOne"
}
ELSE{
	$RemoteDir = Read-Host 'Remote Directory (ex. )'
}

$slnFile = Get-Item *.sln
$tempDir = $THIS_SCRIPTS_DIRECTORY + "\temp";

$buildLogFile = "deployBuildLog.log"
Write-Host ""
Write-Host "---------Building project------------------"
Write-Host "See $buildLogFile"
C:\Windows\Microsoft.Net\Framework64\v4.0.30319\MSBuild.exe $slnFile.FullName /t:Build /p:Configuration=$Configuration /p:Platform="Any CPU" /p:OutputPath=$tempDir >> $buildLogFile

Write-Host $message 

$Credential = Get-Credential

Write-Host ""
Write-Host "---------Copying files to remote------------------"
Write-Host ""
& "$THIS_SCRIPTS_DIRECTORY\CopyToRemote.ps1" -SourceDir $tempDir -RemoteDir $RemoteDir -UserName $Credential.UserName -Password $Credential.GetNetworkCredential().Password


Write-Host ""
Write-Host "---------Removing temp directory: $tempDir------------------"
Write-Host ""
rmdir $tempDir /s /q

$datetime = Get-Date
Write-Host ""
Write-Host "---------Deploy ended at $datetime------------------"
Write-Host ""