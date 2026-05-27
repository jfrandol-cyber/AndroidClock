$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$tools = Join-Path $root ".tools"
$jdk = Get-ChildItem -Path $tools -Directory | Where-Object { $_.Name -like "jdk-*" } | Select-Object -First 1

if (-not $jdk) {
    throw "Portable JDK not found under $tools"
}

$env:JAVA_HOME = $jdk.FullName
$env:ANDROID_HOME = Join-Path $tools "android-sdk"
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
$env:PATH = "$env:JAVA_HOME\bin;$env:ANDROID_HOME\platform-tools;$env:PATH"

$assets = Join-Path $root "app\src\main\assets"
New-Item -ItemType Directory -Force -Path $assets | Out-Null
Copy-Item -LiteralPath (Join-Path $root "index.html") -Destination (Join-Path $assets "index.html") -Force

$gradle = Join-Path $tools "gradle-8.10.2\bin\gradle.bat"
& $gradle -p $root assembleDebug --no-daemon
