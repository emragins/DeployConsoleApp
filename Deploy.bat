SET THIS_SCRIPTS_DIRECTORY=%~dp0
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%THIS_SCRIPTS_DIRECTORY%Deploy.ps1'" 9>&1 > deploylog.log