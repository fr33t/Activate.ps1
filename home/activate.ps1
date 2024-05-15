$script:THIS_PATH = $myinvocation.mycommand.path
$script:BASE_DIR = Split-Path (Resolve-Path "$THIS_PATH") -Parent
$CUSTOM_PROMPT = ""

$VIRTUAL_ENV = $BASE_DIR
$env:VIRTUAL_ENV = $VIRTUAL_ENV

function bins() {
    $bins_file = $env:VIRTUAL_ENV + "\bins.txt"
    foreach ($line in Get-Content $bins_file) {
        Write-Output $line
    }
}
function add_path() {
    $bins_file = $env:VIRTUAL_ENV + "\bins.txt"
    foreach ($line in Get-Content $bins_file) {
        $tmp = $env:VIRTUAL_ENV + $line + ";"
        $env:PATH = $tmp + $env:PATH
    }
}

function change_prompt() {
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


change_prompt
add_path

$log = "BASE_DIR: " + $BASE_DIR
Write-Output $log


