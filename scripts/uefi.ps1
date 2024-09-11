# 添加uefi启动文件
#  分区的时候，在C盘之前添加了一个fat32的D盘，将uefi启动文件添加到D盘，再删除卷标label和分区磁盘符letter，将分区隐藏
#
#  分区格式在Autounattend.xml文件中定义
#((@"
#diskpart
#list disk
#select disk 0
#list volume
#select volume 2
#list volume
#format fs=FAT32 quick
#"@
#)|diskpart)

bcdboot c:\windows /f all /s d: /l zh-cn

# 清除UEFI启动分区卷标
Set-Volume -DriveLetter D -NewFileSystemLabel ""

# 隐藏UEFI分区
# 分区号码2 0和1 是光盘和软盘
((@"
diskpart
list disk
select disk 0
list volume
select volume 2
list volume
remove
"@
)|diskpart)