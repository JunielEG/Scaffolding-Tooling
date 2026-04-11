@echo off
setlocal

set "REPO_URL=https://github.com/JunielEG/Scaffolding-Generator.git"

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

echo   source    cloning...
git clone "%REPO_URL%" .
if errorlevel 1 (
    echo   source    x clone failed
    pause & exit /b 1
)

:submodules
echo   modules   updating submodules...
git submodule update --init --recursive
if errorlevel 1 (
    echo   modules   x submodule update failed
    pause & exit /b 1
)

echo.
echo   ----------------------------------------
echo   installing tools...
echo.

set FOUND=0
set OK_LIST=
set WARN_LIST=
set SKIP_LIST=
set MISSING_LIST=

for /d %%T in (tools\*) do (
    set FOUND=1
    if exist "%%T\install.bat" (
        echo   %%~nxT
        call "%%T\install.bat"
        if errorlevel 1 (
            echo   %%~nxT    ^ install failed
            set "WARN_LIST=%WARN_LIST% %%~nxT"
        ) else (
            set "OK_LIST=%OK_LIST% %%~nxT"
        )
    ) else if exist "%%T\install.sh" (
        echo   %%~nxT    -  skipped  (linux/mac only)
        set "SKIP_LIST=%SKIP_LIST% %%~nxT"
    ) else (
        echo   %%~nxT    .  no installer
        set "MISSING_LIST=%MISSING_LIST% %%~nxT"
    )
)

if %FOUND%==0 (
    echo   x  no tools found in tools\
    echo      make sure submodules were downloaded correctly
    pause & exit /b 1
)

echo.
echo   ----------------------------------------
echo   summary
echo.

if defined OK_LIST (
    for %%I in (%OK_LIST%) do echo   ^  %%I
)
if defined WARN_LIST (
    for %%I in (%WARN_LIST%) do echo   ^  %%I   (failed)
)
if defined SKIP_LIST (
    for %%I in (%SKIP_LIST%) do echo   -  %%I   (skipped)
)
if defined MISSING_LIST (
    for %%I in (%MISSING_LIST%) do echo   .  %%I   (no installer)
)

echo.
echo   done.  restart your terminal to apply changes.
echo.
pause
endlocal