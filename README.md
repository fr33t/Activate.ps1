# VirtualPrompt
添加你的 path， 像 activate.ps1 一样

## require

推荐使用 powershell 7以上 pwsh.exe

系统默认的是 powershell.exe


## install
```zsh
git clone https://github.com/freetbash/VirtualPrompt.git
```


## configure
将 activate.ps1 bins.txt 放入 你的工具根目录作为BASE_DIR

更改prompt.lnk的属性 为 activate.ps1 的地址

配置bins.txt 里面填入 相对目录，工具的bin目录

## extra
内置 bins命令 查看 加载的 bin
```
> bins
```