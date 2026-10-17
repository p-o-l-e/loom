<#
.SYNOPSIS
Build Loom as C23 on Windows using Clang and Ninja (does not run it).
.DESCRIPTION
Requires Visual Studio or Build Tools with Desktop development with C++,
the Windows SDK, LLVM with C23 support, CMake 3.21+, and Ninja.
Tools are discovered on PATH, in LLVM's default location, or in Visual Studio.
Verified with LLVM 22.1.8 and CMake 3.31.12.
.EXAMPLE
.\build-windows.ps1
.EXAMPLE
.\build-windows.ps1 -Compiler clang-cl -Configuration Debug
#>
[CmdletBinding()]
param(
    [ValidateSet('Debug', 'Release', 'RelWithDebInfo', 'MinSizeRel')]
    [string]$Configuration = 'Release',

    [ValidateSet('clang', 'clang-cl')]
    [string]$Compiler = 'clang',

    # Relative paths are resolved against the repository, not the caller's directory.
    [string]$BuildDirectory = '',

    [ValidateRange(1, 1024)]
    [int]$Jobs = [Environment]::ProcessorCount
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Find-BuildTool {
    param([string]$Name, [string[]]$Candidates)
    $command = Get-Command $Name -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($command) { return $command.Source }
    foreach ($candidate in $Candidates) {
        if (Test-Path -LiteralPath $candidate -PathType Leaf) { return $candidate }
    }
    throw "Cannot find $Name. Install it or add its directory to PATH."
}

try {
    if ($env:OS -ne 'Windows_NT') { throw 'This script requires Windows.' }

    $vswhere = Find-BuildTool 'vswhere.exe' @(
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    )
    $vsInstallation = & $vswhere -latest -prerelease -products '*' `
        -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    if ($LASTEXITCODE -ne 0 -or -not $vsInstallation) {
        throw 'Install Visual Studio Build Tools with Desktop development with C++ and a Windows SDK.'
    }

    # Import the x64 compiler/SDK environment even from a regular PowerShell prompt.
    $devCommand = Join-Path $vsInstallation 'Common7\Tools\VsDevCmd.bat'
    $environmentLines = & $env:ComSpec /d /s /c "`"$devCommand`" -no_logo -arch=x64 -host_arch=x64 >nul && set"
    if ($LASTEXITCODE -ne 0) { throw 'Could not initialize the Visual Studio x64 environment.' }
    foreach ($line in $environmentLines) {
        if ($line -match '^([^=]+)=(.*)$') {
            [Environment]::SetEnvironmentVariable($Matches[1], $Matches[2], 'Process')
        }
    }

    $clang = Find-BuildTool "$Compiler.exe" @(
        "$env:ProgramFiles\LLVM\bin\$Compiler.exe",
        "$vsInstallation\VC\Tools\Llvm\x64\bin\$Compiler.exe",
        "$vsInstallation\VC\Tools\Llvm\bin\$Compiler.exe"
    )
    $cmake = Find-BuildTool 'cmake.exe' @(
        "$env:ProgramFiles\CMake\bin\cmake.exe",
        "$vsInstallation\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
    )
    $ninja = Find-BuildTool 'ninja.exe' @(
        "$vsInstallation\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe"
    )

    if (-not (Test-Path -LiteralPath "$PSScriptRoot\field\field.h")) {
        throw 'The field submodule is missing. Run: git submodule update --init --recursive'
    }
    if (-not $BuildDirectory) {
        $BuildDirectory = "build\windows-$Compiler-$Configuration"
    }
    if (-not [IO.Path]::IsPathRooted($BuildDirectory)) {
        $BuildDirectory = Join-Path $PSScriptRoot $BuildDirectory
    }
    $BuildDirectory = [IO.Path]::GetFullPath($BuildDirectory)

    Write-Host "Building $Configuration with $clang"
    & $cmake -S $PSScriptRoot -B $BuildDirectory -G Ninja `
        "-DCMAKE_C_COMPILER=$clang" `
        '-DCMAKE_C_COMPILER_TARGET=x86_64-pc-windows-msvc' `
        "-DCMAKE_MAKE_PROGRAM=$ninja" `
        "-DCMAKE_BUILD_TYPE=$Configuration"
    if ($LASTEXITCODE -ne 0) { throw "CMake configuration failed (exit $LASTEXITCODE)." }

    & $cmake --build $BuildDirectory --config $Configuration --parallel $Jobs
    if ($LASTEXITCODE -ne 0) { throw "Build failed (exit $LASTEXITCODE)." }

    Write-Host "Built: $(Join-Path $BuildDirectory 'loom.exe')"
    exit 0
}
catch {
    Write-Error -Message $_ -ErrorAction Continue
    exit 1
}
