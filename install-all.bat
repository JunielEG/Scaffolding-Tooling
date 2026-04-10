@echo off
setlocal

set "REPO_URL=https://github.com/JunielEG/Scaffolding-Generator.git"

echo ==============================
echo  Scaffolding Generator Setup
echo ==============================
echo.

cd /d "%~dp0"

if exist "tools\" (
    echo Source found locally, skipping clone.
    goto submodules
)

if exist ".git" (
    echo Repository found, skipping clone.
    goto submodules
)

echo Cloning repository...
git clone "%REPO_URL%" .
if errorlevel 1 (
    echo ERROR: git clone failed.
    pause & exit /b 1
)

:submodules
echo Updating submodules...
git submodule update --init --recursive
if errorlevel 1 (
    echo ERROR: submodule update failed.
    pause & exit /b 1
)

echo.
echo Installing tools...
echo.

set FOUND=0
set OK_LIST=
set WARN_LIST=
set SKIP_LIST=
set MISSING_LIST=

for /d %%T in (tools\*) do (
    set FOUND=1
    if exist "%%T\install.bat" (
        echo -- Installing %%~nxT...
        call "%%T\install.bat"
        if errorlevel 1 (
            echo    WARNING: %%~nxT install failed.
            set "WARN_LIST=%WARN_LIST% %%~nxT"
        ) else (
            echo    OK
            set "OK_LIST=%OK_LIST% %%~nxT"
        )
    ) else if exist "%%T\install.sh" (
        echo -- SKIPPED: %%~nxT  ^(Linux/Mac only, no install.bat^)
        set "SKIP_LIST=%SKIP_LIST% %%~nxT"
    ) else (
        echo -- NO INSTALLER: %%~nxT
        set "MISSING_LIST=%MISSING_LIST% %%~nxT"
    )
)

if %FOUND%==0 (
    echo No tools found in tools\
    echo Make sure submodules were downloaded correctly.
    pause & exit /b 1
)

:: Resumen
echo.
echo ==============================
echo  Summary
echo ==============================

if defined OK_LIST (
    echo.
    echo [OK]
    for %%I in (%OK_LIST%) do echo   + %%I
)

if defined WARN_LIST (
    echo.
    echo [FAILED]
    for %%I in (%WARN_LIST%) do echo   x %%I
)

if defined SKIP_LIST (
    echo.
    echo [SKIPPED - Linux/Mac only]
    for %%I in (%SKIP_LIST%) do echo   - %%I
)

if defined MISSING_LIST (
    echo.
    echo [NO INSTALLER]
    for %%I in (%MISSING_LIST%) do echo   - %%I
)

echo.
echo Done! Restart your terminal.
pause
endlocal