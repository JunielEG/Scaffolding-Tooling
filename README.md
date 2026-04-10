# Scaffolding Generator

A collection of command-line tools that generate project boilerplate for different languages and stacks. Each tool installs globally and works from any terminal.

> [!NOTE]
> All tools fully support **Windows**. Some tools may also support **Linux** and **macOS**, but Unix compatibility is not guaranteed for every tool — check the tool's own repository before installing.

---

## Available tools

| Tool | Language / Stack | Status |
|---|---|---|
| [cpp-cli](https://github.com/JunielEG/cpp-cli) | C++ + CMake | Available |
| py-cli | Python | Coming soon |
| java-cli | Java | Coming soon |
| js-cli | JavaScript / Node.js | Coming soon |
| web-cli | HTML / CSS / JS | Coming soon |

Each tool has its own repository with its specific requirements and documentation.

---

## Requirements

- **Git** — [git-scm.com](https://git-scm.com/downloads)
- Each tool may have its own additional requirements (compiler, runtime, etc.) — see its repository.

---
## Installation

There are multiple ways to install, depending on your environment.

---

### Option A — Install everything (recommended)

Use the provided installer script for your operating system. You don't need to clone anything first — the script handles it.

#### **Windows**

1. Download `Install-All.bat` from this repository
2. Run it as Administrator:

```bat
Install-All.bat
```

#### **Linux / macOS**

1. Download `Install-All.sh`
2. Give execution permission and run:

```bash
chmod +x Install-All.sh
./Install-All.sh
```

#### What the script does

* Clones this repository (if not already present)
* Pulls all tool submodules
* Runs each tool's install script automatically

#### Final step

Open a new terminal and verify a tool is available:

```bash
cppx help
```

---

### Option B — Clone the repository first

If you prefer to inspect the repo before running anything:

```bash
git clone --recurse-submodules https://github.com/JunielEG/Scaffolding-Generator.git
cd Scaffolding-Generator
```

#### Then run the installer:

* **Windows**

```bat
Install-All.bat
```

* **Linux / macOS**

```bash
chmod +x Install-All.sh
./Install-All.sh
```

> [!NOTE]
> Using `--recurse-submodules` downloads all tools in one step. Without it, `tools/` will be empty until you run:

```bash
git submodule update --init --recursive
```

---

### Option C — Install a single tool

If you only need one specific tool, go directly to its repository and follow its own installation instructions.

| Tool | Repository |
|---|---|
| cpp-cli | [github.com/JunielEG/cpp-cli](https://github.com/JunielEG/cpp-cli) |

---

## How it works

This repository uses **Git submodules**. Each tool lives in its own repository under `tools/` and has its own installer script. When you run `Install-All.bat`(*for windows*), it detects every folder inside `tools/` that contains an `install.bat` and runs it automatically — no manual steps needed when new tools are added.

---

## Contributing — adding a new tool

New tools are added as submodules. Once a tool is merged into this repo, `Install-All.bat` will pick it up automatically on the next run — no changes to the script needed.

> [!IMPORTANT]
> Every tool **must** follow this folder structure, with the install scripts in the root.

```
<lang>-cli/
├── templates/
│   └── <template>.<ext>.tpl
├── windows/
│   ├── <command>.bat
│   └── <command>.ps1
├── unix/
│   └── <command>.sh
├── install.bat
├── install.sh (optional)
└── README.md
```
- `<lang>` — is an abrevation of the languaje it was made for.
- `templates/` — all file templates used to generate boilerplate (e.g. `class.h.tpl`, `main.cpp.tpl`).
- `windows/` — the `.bat` and `.ps1` scripts that implement each command on Windows.
- `unix/` — the `.sh` scripts that implement each command on Linux/macOS. Unix support is optional but must live here if provided.
- `install.bat` and `install.sh` — scripts that copy files and register the tool in the system PATH. Both are **not** required if Unix support is not yet implemented.
- `README.md` — documentation for the tool, including its own requirements and usage.