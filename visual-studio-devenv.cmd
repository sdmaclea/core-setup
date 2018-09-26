@if "%_echo%" neq "on" echo off
setlocal

if defined VisualStudioVersion goto :Run

set _VSWHERE="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist %_VSWHERE% (
  for /f "usebackq tokens=*" %%i in (`%_VSWHERE% -latest -prerelease -property installationPath`) do set _VSCOMNTOOLS=%%i\Common7\Tools
)
if not exist "%_VSCOMNTOOLS%" set _VSCOMNTOOLS=%VS140COMNTOOLS%
if not exist "%_VSCOMNTOOLS%" (
    echo Error: Visual Studio 2015 or 2017 required.
    echo        Please see https://github.com/dotnet/corefx/blob/master/Documentation/project-docs/developer-guide.md for build instructions.
    exit /b 1
)

set VSCMD_START_DIR="%~dp0"
call "%_VSCOMNTOOLS%\VsDevCmd.bat"

:Run

:: this makes test explorer work in Visual Studio
:: Found the env vars by running build -MsBuildLogging=/bl, then look at the Exec task in RunTest target

set NUGET_PACKAGES=%~dp0\packages\
set TEST_ARTIFACTS=%~dp0\Bin\tests\win-x64.Debug\
set TEST_TARGETRID=win-x64
set BUILDRID=win-x64
set BUILD_ARCHITECTURE=x64
set BUILD_CONFIGURATION=Debug
set MNA_VERSION=3.0.0-preview1-26927-0
set MNA_TFM=netcoreapp3.0
set DOTNET_SDK_PATH=%~dp0\Tools\dotnetcli\
devenv %~dp0\Microsoft.DotNet.CoreSetup.sln
