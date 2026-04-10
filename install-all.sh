#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/JunielEG/Scaffolding-Generator.git"

echo "=============================="
echo " Scaffolding Generator Setup"
echo "=============================="
echo

cd "$(dirname "$0")"

if [ -d "tools" ]; then
    echo "Source found locally, skipping clone."
elif [ -d ".git" ]; then
    echo "Repository found, skipping clone."
else
    echo "Cloning repository..."
    git clone "$REPO_URL" .
fi

echo "Updating submodules..."
git submodule update --init --recursive

echo
echo "Installing tools..."
echo

FOUND=0
OK_LIST=()
WARN_LIST=()
SKIP_LIST=()
MISSING_LIST=()

for tool_dir in tools/*/; do
    [ -d "$tool_dir" ] || continue
    tool_name=$(basename "$tool_dir")
    FOUND=1

    if [ -f "${tool_dir}install.sh" ]; then
        echo "-- Installing ${tool_name}..."
        if bash "${tool_dir}install.sh"; then
            echo "   OK"
            OK_LIST+=("$tool_name")
        else
            echo "   WARNING: ${tool_name} install failed."
            WARN_LIST+=("$tool_name")
        fi
    elif [ -f "${tool_dir}install.bat" ]; then
        echo "-- SKIPPED: ${tool_name} (Windows only, no install.sh)"
        SKIP_LIST+=("$tool_name")
    else
        echo "-- NO INSTALLER: ${tool_name}"
        MISSING_LIST+=("$tool_name")
    fi
done

if [ "$FOUND" -eq 0 ]; then
    echo "No installers found in tools/"
    echo "Make sure submodules were downloaded correctly."
    exit 1
fi

# Resumen
echo
echo "=============================="
echo " Summary"
echo "=============================="

if [ ${#OK_LIST[@]} -gt 0 ]; then
    echo
    echo "[OK]"
    for t in "${OK_LIST[@]}"; do echo "  + $t"; done
fi

if [ ${#WARN_LIST[@]} -gt 0 ]; then
    echo
    echo "[FAILED]"
    for t in "${WARN_LIST[@]}"; do echo "  x $t"; done
fi

if [ ${#SKIP_LIST[@]} -gt 0 ]; then
    echo
    echo "[SKIPPED - Windows only]"
    for t in "${SKIP_LIST[@]}"; do echo "  - $t"; done
fi

if [ ${#MISSING_LIST[@]} -gt 0 ]; then
    echo
    echo "[NO INSTALLER]"
    for t in "${MISSING_LIST[@]}"; do echo "  - $t"; done
fi

echo
echo "Done! Restart your terminal."