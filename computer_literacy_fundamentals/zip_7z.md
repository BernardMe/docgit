

## 7zip在dos命令行用法总结



Usage: 7za <command> [<switches>...] <archive_name> [<file_names>...] 
[<@listfiles...>] 


1. "a"，添加文件 
`7z a -t7z files.7z *.txt `


3. "e", 解压缩 
7z e archive.zip 


7. "x", 与e相同，但保留全路径 
`"C:\Program Files\7-Zip\7z.exe" x "d:\xTest\mongodb.7z" -y -aos -o"d:\"`

