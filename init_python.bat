@echo off
:: 删除现有的 .py 文件类型和关联
assoc .py=
ftype Python.File=

:: 查找 Python 路径并设置关联
for /f "delims=" %%i in ('where python') do (
    set pythonPath=%%i
    goto :set_association
)

:set_association
:: 设置 Python 解释器为 .py 文件类型的默认打开程序
ftype Python.File="%pythonPath%" "%%1" %%*
assoc .py=Python.File
echo Python file association has been successfully set!
