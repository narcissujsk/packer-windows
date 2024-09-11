Remove-Item -Path C:\Windows\Temp\*   -Recurse -Force
#Remove-Item  "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\cloudbase-init.log"
# delete windows update download files
Remove-Item -Path C:\Windows\SoftwareDistribution\Download\* -Force -Recurse


