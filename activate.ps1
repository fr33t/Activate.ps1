$env:WD = "P:\fr33t\remoulages\Collection\dicts"
$script:THIS_PATH = $myinvocation.mycommand.path
$script:BASE_DIR = Split-Path (Resolve-Path "$THIS_PATH") -Parent
$CUSTOM_PROMPT = ""

$VIRTUAL_ENV = $BASE_DIR
$env:VIRTUAL_ENV = $VIRTUAL_ENV

function bins() {
    $bins_file = $env:VIRTUAL_ENV + "\bins.txt"
    Write-Output "BINS:"
    foreach ($line in Get-Content $bins_file) {
        $log = "`t- " + $line
        Write-Output $log
    }
    Write-Output ''
}

function __add_path() {
    $bins_file = $env:VIRTUAL_ENV + "\bins.txt"
    foreach ($line in Get-Content $bins_file) {
        $tmp = $env:VIRTUAL_ENV + $line + ";"
        $env:PATH = $tmp + $env:PATH
    }
}


function __change_prompt() {
    if ($CUSTOM_PROMPT -ne "") {
        $env:VIRTUAL_ENV_PROMPT = $CUSTOM_PROMPT
    }
    else {
        $env:VIRTUAL_ENV_PROMPT = $( Split-Path $env:VIRTUAL_ENV -Leaf )
    }
    
    if (!$env:VIRTUAL_ENV_DISABLE_PROMPT) {
        function global:_old_virtual_prompt {
            ""
        }
        $function:_old_virtual_prompt = $function:prompt
        
        function global:prompt {
            # Add the custom prefix to the existing prompt
            $previous_prompt_value = & $function:_old_virtual_prompt
            ("(" + $env:VIRTUAL_ENV_PROMPT + ") " + $previous_prompt_value)
        }
    }
    
}

function c { cmd /c $args }

function __unset_alias {
    Remove-Item -Path alias:echo
    Remove-Item -Path alias:cat
    Remove-Item -Path alias:ls
    Remove-Item -Path alias:cp
    Remove-Item -Path alias:mv
    Remove-Item -Path alias:rm
    Remove-Item -Path alias:pwd
    Remove-Item -Path alias:man
}

function banner() {
    bins
    $log = "BASE_DIR: `t" + $BASE_DIR + "`n" + '$' + "ENV:WD: `t`$env:wordlists `t" + $env:wordlists + "`nTry to type 'c dir' and TAB`nType 'c TAB' to show all scripts in python`n"

    Write-Output $log
}


# 定义补全函数以获取 PATH 中的 .py 文件
function Complete-PyFilesFromPath {
    param(
        [string]$wordToComplete  # 输入的部分文件名
    )

    # 获取 PATH 中的所有目录
    $pathDirs = $env:PATH -split ';'
    $matchess = @()

    foreach ($dir in $pathDirs) {
        if (Test-Path -Path $dir) {
            # 获取目录中所有 .py 文件
            $pyFiles = Get-ChildItem -Path $dir -Filter '*.py' -File -ErrorAction SilentlyContinue
            foreach ($file in $pyFiles) {
                # 如果文件名包含用户输入的部分则添加到补全列表中
                if ($file.Name -like "$wordToComplete*") {
                    $matchess += $file.Name
                }
            }
        }
    }

    # 返回补全选项
    $matchess | Sort-Object -Unique
}

Register-ArgumentCompleter -Native -CommandName 'c' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    # Complete-PyFilesFromPath -wordToComplete $commandName
    Complete-PyFilesFromPath -wordToComplete $commandName | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }

}

function main() {
    __change_prompt
    __add_path
    __unset_alias
    banner
    Set-PSReadLineKeyHandler -Key Tab -Function Complete
}

main
