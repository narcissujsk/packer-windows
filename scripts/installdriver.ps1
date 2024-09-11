function UnzipFile([string]$souceFile, [string]$targetFolder)
{
    if(!(Test-Path $targetFolder))
    {
        mkdir $targetFolder
    }
    $shellApp = New-Object -ComObject Shell.Application
    $files = $shellApp.NameSpace($souceFile).Items()
    #下面这句会删除已解压的，但不会影响目录内其它不相干的文件      
    $files|%{if (Test-Path ("$targetFolder/{0}" -f  $_.name )){Remove-Item ("$targetFolder/{0}" -f  $_.name) -Force -Recurse}}
    $shellApp.NameSpace($targetFolder).CopyHere($files)
}

# 针对windows 2012 Disable Network Level Authentication 否则会提示安全漏洞
(Get-WmiObject -class Win32_TSGeneralSetting -Namespace root\cimv2\terminalservices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0)


certutil.exe -addstore -f "TrustedPublisher" "a:\redhat.cer" 
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/virtio/2k19/Balloon.zip"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\Balloon.zip")

UnzipFile "C:\Windows\Temp\Balloon.zip" "C:\Windows\Temp\"
PnPutil.exe -i -a "C:\Windows\Temp\Balloon\balloon.inf"
mkdir "C:\Program Files\Balloon"
Move-Item "C:\Windows\Temp\Balloon\blnsvr.exe" "C:\Program Files\Balloon\blnsvr.exe"
cmd.exe /c 'C:\Program Files\Balloon\blnsvr.exe' -i


# 下载串口驱动
<#
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/virtio/2k19/vioserial.zip"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\vioserial.zip")
#>

## 下载串口dll
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/virtio/dlls.zip"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\dlls.zip")
UnzipFile "C:\Windows\Temp\dlls.zip" "C:\Windows\Temp\"

Move-Item -Path "C:\Windows\Temp\dlls\*" -Destination "C:\Windows\System32\"

# 安装驱动
<#
UnzipFile "C:\Windows\Temp\vioserial.zip" "C:\Windows\Temp\"
PnPutil.exe -i -a "C:\Windows\Temp\vioserial\vioser.inf"
#>

# Qlogic Fibre Channel Adapter HBA 3770
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cps/QlogicFC/ql2300.cat"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\ql2300.cat")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cps/QlogicFC/ql2300.sys"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\ql2300.sys")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cps/QlogicFC/ql2x00.inf"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\ql2x00.inf")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cps/QlogicFC/qlsrvc.exe"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\qlsrvc.exe")
Copy-Item "C:\Windows\Temp\qlsrvc.exe" -Destination "C:\Windows\system32\qlsrvc.exe"
Copy-Item "C:\Windows\Temp\ql2300.sys" -Destination "C:\Windows\system32\DRIVERS\ql2300.sys"
PnPutil.exe -i -a "C:\Windows\Temp\ql2x00.inf"


#Controllers Supported : This Driver supports SAS3.5 MegaRAID 94xx (Ventura Family) and MegaRAID 95xx (Aero Family) of Controllers only.
#There is no minimum patch level required for Windows Server 2019 before using our drivers.
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cps/raid-driver/win_megasas_drv_rel/Win2019_Server_RS5_LTSC_f18_x64/megasas35.RttMeta"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\megasas35.RttMeta")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cps/raid-driver/win_megasas_drv_rel/Win2019_Server_RS5_LTSC_f18_x64/megasas35.cat"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\megasas35.cat")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cps/raid-driver/win_megasas_drv_rel/Win2019_Server_RS5_LTSC_f18_x64/megasas35.inf"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\megasas35.inf")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cps/raid-driver/win_megasas_drv_rel/Win2019_Server_RS5_LTSC_f18_x64/megasas35.pdb"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\megasas35.pdb")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cps/raid-driver/win_megasas_drv_rel/Win2019_Server_RS5_LTSC_f18_x64/nodev.inf"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\nodev.inf")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cps/raid-driver/win_megasas_drv_rel/Win2019_Server_RS5_LTSC_f18_x64/megasas35.sys"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\megasas35.sys")
Copy-Item "C:\Windows\Temp\megasas35.sys" -Destination "C:\Windows\system32\DRIVERS\megasas35.sys"
PnPutil.exe -i -a "C:\Windows\Temp\megasas35.inf"
PnPutil.exe -i -a "C:\Windows\Temp\nodev.inf"



# 安装Qga
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/qemu-guest-agent/windows/qemu-ga-x86_64-2.12.0-6.msi"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\qemu-ga-x64.msi")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/qemu-guest-agent/windows/win_qga_update-2.12.0-6.exe"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\win_qga_update.exe")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/qemu-guest-agent/windows/win_qga_update-2.12.0-6.sig"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\win_qga_update.sig")
$url= "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/qemu-guest-agent/windows/libcrypto.dll"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\libcrypto.dll")
New-Item "C:\Program Files\Qemu-ga\" -Type Directory
Copy-Item "C:\Windows\Temp\libcrypto.dll" -Destination "C:\Program Files\Qemu-ga\libcrypto.dll"
Copy-Item "C:\Windows\Temp\win_qga_update.exe" -Destination "C:\Program Files\Qemu-ga\win_qga_update.exe"
Copy-Item "C:\Windows\Temp\win_qga_update.sig" -Destination "C:\Program Files\Qemu-ga\win_qga_update.sig"
Start-Process C:\Windows\Temp\qemu-ga-x64.msi /qn -Wait
Set-Service qemu-ga -startuptype automatic
Copy-Item "C:\Program files\Qemu-ga\libwinpthread-1.dll" -Destination "C:\Windows\System32\pthreadgc2.dll"
regsvr32 -s pthreadgc2.dll


