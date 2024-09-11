reg ADD HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient /v Enabled /t REG_DWORD /d 1 /f
reg ADD HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient /v SpecialPollInterval /t REG_DWORD /d 3600 /f
reg ADD HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Config /v AnnounceFlags /t REG_DWORD /d 5 /f
reg ADD HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters /v NtpServer /t REG_SZ /d "time.windows.com,0x8 ntp.myinspurcloud.com,0x9" /f
reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers /v 0 /t REG_SZ /d ntp.myinspurcloud.com /f
sc config w32time start= auto
net stop w32time
net start w32time
w32tm /resync