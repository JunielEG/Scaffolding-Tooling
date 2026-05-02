@echo off
setlocal enabledelayedexpansion

set "REPO_URL=https://github.com/JunielEG/Scaffolding-Tooling.git"

echo.
echo   Scaffolding Generator  setup
echo   ----------------------------------------
echo.

cd /d "%~dp0"

if exist "tools\" (
    echo   source    ^ found locally, skipping clone
    goto submodules
)
if exist ".git" (
    echo   source    ^ repository found, skipping clone
    goto submodules
)

rem -- directorio no vacio pero sin repo, clonar en temp y mover
dir /b /a | findstr "." > nul
if not errorlevel 1 (
    echo   source    cloning to temp...
pause
    if exist "%TEMP%\scaffolding-setup" rmdir /s /q "%TEMP%\scaffolding-setup"
    git clone "%REPO_URL%" "%TEMP%\scaffolding-setup"

    if errorlevel 1 ( echo   source    x clone failed & pause & exit /b 1 )
    robocopy "%TEMP%\scaffolding-setup" "." /E /NFL /NDL /NJH /NJS > nul
    rmdir /s /q "%TEMP%\scaffolding-setup"
    goto submodules
)

echo   source    cloning...
git clone "%REPO_URL%" .
if errorlevel 1 ( echo   source    x clone failed & pause & exit /b 1 )

:submodules
echo   modules   updating submodules...
git submodule update --init --recursive
if errorlevel 1 ( echo   modules   x submodule update failed & pause & exit /b 1 )

echo.
echo   ----------------------------------------
echo   installing tools...
echo.

set FOUND=0
set "OK_LIST="
set "WARN_LIST="
set "SKIP_LIST="
set "MISSING_LIST="

for /d %%T in (tools\*) do call :check_tool "%%T" "%%~nxT"
goto :after_loop

:check_tool
set "FOUND=1"
echo %~2
if exist "%~1\install.bat" (
    cmd /c "%~1\install.bat" closeLocal > nul 2>&1
    if errorlevel 1 (
        set "WARN_LIST=!WARN_LIST! %~2"
    ) else (
        set "OK_LIST=!OK_LIST! %~2"
    )
) else if exist "%~1\install.sh" (
    set "SKIP_LIST=!SKIP_LIST! %~2"
) else (
    set "MISSING_LIST=!MISSING_LIST! %~2"
)
exit /b 0

:after_loop

if !FOUND!==0 (
    echo   x  no tools found in tools\
    echo      make sure submodules were downloaded correctly
    pause & exit /b 1
)

echo.
echo   ----------------------------------------
echo   summary
echo.

if defined OK_LIST (
    for %%I in (!OK_LIST!) do echo   [+]  %%I
)
if defined WARN_LIST (
    for %%I in (!WARN_LIST!) do echo   [x]  %%I   -failed
)
if defined SKIP_LIST (
    for %%I in (!SKIP_LIST!) do echo   [-]  %%I   -skipped
)
if defined MISSING_LIST (
    for %%I in (!MISSING_LIST!) do echo   [?]  %%I   -no installer
)

echo.
echo   done.  restart your terminal to apply changes.
echo.
pause
endlocal