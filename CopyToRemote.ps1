param($SourceDir, $RemoteDir, $UserName, $Password)

if([string]::IsNullOrEmpty($SourceDir))
{
	Write-Host  "ERROR: parameter SourceDir may not be null or empty"
	exit 2
}
if([string]::IsNullOrEmpty($RemoteDir))
{
	Write-Host  "ERROR: parameter RemoteDir may not be null or empty"
	exit 2
}
if([string]::IsNullOrEmpty($UserName))
{
	Write-Host  "ERROR: parameter UserName may not be null or empty"
	exit 2
}
if([string]::IsNullOrEmpty($Password))
{
	Write-Host  "ERROR: parameter Password may not be null or empty"
	exit 2
}

$source = "$SourceDir" + "\*.*"
$dest = "$RemoteDir"

Write-Host "Copying items from '$source' to '$dest'"

try{
	net use X: $dest /user:$UserName $Password | Out-Default
	xcopy.exe /e /y /v /h $source X: | Out-Default
	net use X: /d | Out-Default
}
catch
{
    Write-Host "Caught an exception:"
    Write-Host "Exception Type: $($_.Exception.GetType().FullName)"
    Write-Host "Exception Message: $($_.Exception.Message)"

	exit 1
}
