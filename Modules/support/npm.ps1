Set-Variable -Name NODE_EXE -Value $PSScriptRoot\node.exe
Set-Variable -Name NODE_MODULES -Value $PSScriptRoot\node_modules\

Set-Variable -Name NPM_MODULE -Value $NODE_MODULES\npm\
Set-Variable -Name NPM_BIN -Value $NPM_MODULE\bin\

Set-Variable -Name NPM_JS -Value $NPM_BIN\npm-cli.js
Set-Variable -Name NPX_JS -Value $NPM_BIN\npx-cli.js

Write-Output $NODE_MODULES

# npm config set python /path/to/executable/python

# → ./pkg/v/node/18/npm.ps1 config get prefix -g

# Write-Output script: $PSScriptRoot
# Write-Output $PSScriptRoot/node.exe
# Write-Output $PWD/node.exe

# if (Test-Path $PWD/node.exe) {
#     Set-Variable -Name NODE_EXE -Value $PWD\node.exe
# } elseif (Test-Path $PSScriptRoot/node.exe) {
#     Set-Variable -Name NODE_EXE -Value $PSScriptRoot\node.exe
# } else {  
#     Set-Variable -Name NODE_EXE -Value node
# }

# .$NODE_EXE $NPM_CLI_JS $args

# Get-Variable NODE_EXE

# if (Test-Path $NODE_EXE) {
#     # Set-Variable 
#     Write-Output "was Valid"
# }