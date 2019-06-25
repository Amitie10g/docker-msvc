# escape=`

# Using Windows 10 Insider instead of Server Core, to get gui.
FROM mcr.microsoft.com/windows/insider:10.0.18922.1000

RUN @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

# wait for vs_installer.exe, vs_installerservice.exe
# or vs_installershell.exe because choco doesn't
RUN powershell -NoProfile -InputFormat None -Command `
    choco install git 7zip -y; `
    choco install visualcpp-build-tools `
        --version 15.0.26228.20170424 -y; `
    Write-Host 'Waiting for Visual C++ Build Tools to finish'; `
    Wait-Process -Name vs_installer

WORKDIR C:\build
CMD powershell -ExecutionPolicy Bypass -Command .\release.ps1
