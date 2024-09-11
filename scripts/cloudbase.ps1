$Host.UI.RawUI.WindowTitle = "Downloading Cloudbase-Init..."

$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cloud-init/cloudbase-init/CloudbaseInitSetup_1_1_0_x64.msi"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\cloudbase-init.msi")

$Host.UI.RawUI.WindowTitle = "Installing Cloudbase-Init..."

$serialPortName = @(Get-WmiObject Win32_SerialPort)[0].DeviceId

$p = Start-Process -Wait -PassThru -FilePath msiexec -ArgumentList "/i C:\Windows\Temp\cloudbase-init.msi /qn /l*v C:\Windows\Temp\cloudbase-init.log LOGGINGSERIALPORTNAME=$serialPortName USERNAME=Administrator INJECTMETADATAPASSWORD=TRUE"
if ($p.ExitCode -ne 0) {
    throw "Installing Cloudbase-Init failed. Log: C:\Windows\Temp\cloudbase-init.log"
}

# modify cloudbase-init, add inspur_task_init
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cloud-init/cloud-init-mod/cloudbase-init-1.1.0/metadata/services/baseopenstackservice.py"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python\Lib\site-packages\cloudbaseinit\metadata\services\baseopenstackservice.py")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cloud-init/cloud-init-mod/cloudbase-init-1.1.0/plugins/common/setuserpassword.py"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python\Lib\site-packages\cloudbaseinit\plugins\common\setuserpassword.py")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cloud-init/cloud-init-mod/cloudbase-init-1.1.0/plugins/windows/inspurtaskinit.py"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python\Lib\site-packages\cloudbaseinit\plugins\windows\inspurtaskinit.py")

$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cps/cloud-init/cloudbase-init-1.1.0/cloudbaseinit/osutils/base.py"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python\Lib\site-packages\cloudbaseinit\osutils\base.py")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cps/cloud-init/cloudbase-init-1.1.0/cloudbaseinit/osutils/windows.py"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python\Lib\site-packages\cloudbaseinit\osutils\windows.py")
$url = "http://vm-image.oss.jinan-lab.inspurcloudoss.com/tools/cps/cloud-init/cloudbase-init-1.1.0/cloudbaseinit/plugins/common/networkconfig.py"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python\Lib\site-packages\cloudbaseinit\plugins\common\networkconfig.py")


Copy-Item "A:\cloudbase-init.conf" -Destination "${env:ProgramFiles}\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init.conf"
# Copy-Item "A:\ICPG2Run.ps1" -Destination "${env:ProgramFiles}\Cloudbase Solutions\Cloudbase-Init\LocalScripts\"

$Host.UI.RawUI.WindowTitle = "Running Cloudbase-Init SetSetupComplete..."
& "${env:ProgramFiles}\Cloudbase Solutions\Cloudbase-Init\bin\SetSetupComplete.cmd"

(Get-WmiObject -class Win32_TSGeneralSetting -Namespace root\cimv2\terminalservices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0)

# cloudbase-init will setup setcomplete iteself
#New-Item -Path "${env:WINDIR}\Setup\Scripts" -type Directory -Force
Copy-Item "A:\SetupComplete.cmd" -Destination "${env:WINDIR}\Setup\Scripts\SetupComplete.cmd"

# run sysprep will disable administrator account
#$Host.UI.RawUI.WindowTitle = "Running Sysprep..."
#$unattendedXmlPath = "${env:ProgramFiles}\Cloudbase Solutions\Cloudbase-Init\conf\Unattend.xml"
#& "${env:SystemRoot}\System32\Sysprep\Sysprep.exe" `/generalize `/oobe `/unattend:"$unattendedXmlPath"

net user "Administrator" /active:yes
netsh advfirewall set allprofile state off
Set-Service -Name cloudbase-init -StartupType automatic

# shutdown /s /t 60
