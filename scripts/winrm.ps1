## Current WinRM settings
## winrm get winrm/config
## Configure WinRM
## Supress network location Prompt
#New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force
#
## Set network to private
#$ifaceinfo = Get-NetConnectionProfile
#Set-NetConnectionProfile -InterfaceIndex $ifaceinfo.InterfaceIndex -NetworkCategory Private
## start "" /WAIT cmd.exe /c net stop winrm
#winrm quickconfig -q
##winrm quickconfig -transport:http
#winrm set "winrm/config" '@{MaxTimeoutms="1800000"}'
#winrm set "winrm/config/winrs" '@{MaxMemoryPerShellMB="2048"}'
#winrm set "winrm/config/service" '@{AllowUnencrypted="true"}'
#winrm set "winrm/config/service/auth" '@{Basic="true"}'
#winrm set "winrm/config/client/auth" '@{Basic="true"}'
#
## Fire up WinRM!
#cmd.exe /c sc config winrm start= auto
#
## enable admin user
#net user "Administrator" /active:yes
##netsh advfirewall set allprofiles state off
##############################################################################################
$NetworkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
$Connections = $NetworkListManager.GetNetworkConnections()
$Connections | ForEach-Object { $_.GetNetwork().SetCategory(1) }

Enable-PSRemoting -Force
winrm quickconfig -q
winrm quickconfig -transport:http
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="800"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/listener?Address=*+Transport=HTTP '@{Port="5985"}'
netsh advfirewall firewall set rule group="Windows Remote Administration" new enable=yes
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=allow
Set-Service winrm -startuptype Automatic
Restart-Service winrm
