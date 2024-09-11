@echo off
title Windows Security hardening script

echo [Unicode]>win.inf
echo Unicode=yes>>win.inf
echo [System Access]>>win.inf

echo PasswordComplexity = 1 >>win.inf

echo MinimumPasswordLength = 8 >>win.inf

echo PasswordHistorySize = 5 >>win.inf

echo MinimumPasswordAge = 2 >>win.inf


echo LockoutBadCount = 5 >>win.inf

echo LockoutDuration = 30 >>win.inf

echo ResetLockoutCount = 30 >>win.inf


echo [Event Audit]>>win.inf
@Rem Configure log audit strategy
echo AuditSystemEvents = 1 >>win.inf
echo AuditLogonEvents = 3 >>win.inf
echo AuditObjectAccess = 3 >>win.inf
echo AuditPrivilegeUse = 3 >>win.inf
echo AuditPolicyChange = 1 >>win.inf
echo AuditAccountManage = 3 >>win.inf
echo AuditProcessTracking = 3 >>win.inf
echo AuditDSAccess = 3 >>win.inf
echo AuditAccountLogon = 3 >>win.inf


echo EnableGuestAccount = 0 >>win.inf
echo=


echo [Version]>>win.inf
echo signature="$CHICAGO$">>win.inf
echo Revision=1 >>win.inf

secedit /configure /db win.sdb /cfg win.inf
del win.inf /q
del win.sdb /q








reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v restrictanonymoussam /t REG_DWORD /d 0x00000001 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v restrictanonymous /t REG_DWORD /d 0x00000001 /f

REM not allow storage username and password
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa" /v DisableDomainCreds /t REG_DWORD /d 0x00000001 /f

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v SCENoApplyLegacyAuditPolicy /t REG_DWORD /d 0x00000001 /f



reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v ForceUnlockLogon /t REG_DWORD /d 0x00000001 /f

reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v CachedLogonsCount /t REG_DWORD /d 0x00000003 /f

REM reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa" /v DisableDomainCreds /t REG_DWORD /d 0x00000000 /f



REM reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" /v AutoShareServer /t REG_DWORD /d 0x00000000 /f

REM reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" /v AutoShareWks /t REG_DWORD /d 0x00000000 /f

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v restrictanonymous /t REG_DWORD /d 0x00000001 /f




net share c$ /del
net share ipc$ /del
net share admin$ /del





netsh advfirewall set allprofiles state on

REM echo %date%   %time%



echo 'MaxIdleTime'
REM The MaxIdleTime is in milliseconds; by default, this script sets MaxIdleTime to 15 minutes.
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v MaxIdleTime /t REG_DWORD /d 0xdbba0 /f
REM HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance



echo 'stop services'
C:\Windows\System32\wbem\wmic.exe service where name="Messenger" call stopservice
sc config "Messenger" start= disabled
C:\Windows\System32\wbem\wmic.exe service where name="SMTPSVC" call stopservice
sc config "SMTPSVC" start= disabled

C:\Windows\System32\wbem\wmic.exe service where name="WINS" call stopservice
sc config "WINS" start= disabled

C:\Windows\System32\wbem\wmic.exe service where name="RasMan" call stopservice
sc config "RasMan" start= disabled

C:\Windows\System32\wbem\wmic.exe service where name="MSMQ" call stopservice
sc config "MSMQ" start= disabled


netsh advfirewall firewall add rule name = "Disable port 135 - TCP" dir = in action = block protocol = TCP localport = 135,136,137,138,139
netsh advfirewall firewall add rule name = "Disable port 135 - UDP" dir = in action = block protocol = UDP localport = 135,136,137,138,139
netsh advfirewall firewall add rule name = "Disable port 445 - TCP" dir = in action = block protocol = TCP localport = 445
netsh advfirewall firewall add rule name = "Disable port 445 - UDP" dir = in action = block protocol = UDP localport = 445




REM reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v SCRNSAVE.EXE /t REG_SZ /d C:\Windows\system32\scrnsave.scr /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaverIsSecure /t REG_SZ /d 1 /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaveTimeOut /t REG_SZ /d 600000 /f

echo 'NoDriveTypeAutoRun'
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 0x000000ff /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 0x000000ff /f

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoAutorun  /t REG_DWORD /d 0x00000001 /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoAutorun  /t REG_DWORD /d 0x00000001 /f

echo 'DontDisplayLockedUserId'
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DontDisplayLockedUserId /t REG_DWORD /d 0x00000003 /f

echo 'DontDisplayLastUserName'
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Currentversion\Policies\System" /v DontDisplayLastUserName /t REG_DWORD /d 0x00000001 /f



echo 'ClearPageFileAtShutdown'
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0x00000001 /f






set path1="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer"
set path2="HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
set path3="HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client"

REM DisablePasswordSaving
reg add %path1% /v DisablePasswordSaving /t REG_DWORD /d 0x1 /f>nul



echo 'fAllowUnsolicited begin'
reg add %path1% /v fAllowUnsolicited /t REG_DWORD /d 0x00000000 /f
reg add %path2% /v fAllowUnsolicited /t REG_DWORD /d 0x00000000 /f
echo 'fAllowUnsolicited end'



echo 'fAllowToGetHelp begin'
reg add %path1% /v fAllowToGetHelp /t REG_DWORD /d 0x00000000 /f
reg add %path2% /v fAllowToGetHelp /t REG_DWORD /d 0x00000000 /f
echo 'fAllowToGetHelp end'









reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanServer\Parameters" /v AutoShareServer /t REG_DWORD /d 0x00000000 /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanServer\Parameters" /v AutoShareWks /t REG_DWORD /d 0x00000000 /f


C:\Windows\System32\wbem\wmic.exe service where name="LanmanServer" call stopservice
sc config LanmanServer start= disabled


reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v NullSessionShares /t REG_MULTI_SZ  /d hex(7):43,00,4f,00,4d,00,43,00,46,00,47,00,00,00,44,00,46,00,53,00,24,00,00,00,00,00  /f

echo=
echo=
echo=
echo=
echo Configuration is complete, some configurations take effect after restarting the system
echo=
echo=
echo=
echo=