# Copilot Instructions for MikroTik Management Scripts

Use these rules whenever creating or editing any .rsc file in this repository.

## Required Header Format

Every .rsc file must begin with this exact top header:

# ===================================================================
# MikroTik Management Scripts
# MMS Version: 0.01 Testing
# (blank line)

Immediately after the two required lines, include these metadata lines in this order:

# Script Version: YYYYMMDDHHMM
# Script Filename: <filename.rsc>
# Stored Script Name: <script-name>
# Description: <short purpose statement>
# Author: Kenneth G. Tipton
# Date: YYYY-MM-DD
# Time: HH:MM:SS
# used AI tools: <list of AI tools used, if any>
# ===================================================================

## Stored Script Name Rules

Set Stored Script Name to match the file naming convention by folder:

- `Stored Script Name` in the header is the RouterOS stored script name on the MikroTik device.
- `Stored Script Name` is not a file extension value and should not include `.rsc` unless explicitly required by device-side naming decisions.
- Root MMS scripts (example: MMS-InstallScripts.rsc): Stored Script Name should be the stored script name, typically matching file name without `.rsc`.
- MMS-Functions scripts: file names must start with MMS- and Stored Script Name should be the stored script name, typically matching file name without `.rsc`.
- Devices scripts: Stored Script Name should be the stored script name used on device.
- dataSetMaps scripts: Stored Script Name should be the stored script name used on device.

## File Naming Rules

- MMS-Functions folder: all active function files must start with MMS-
- Do not create new files with spaces in the name
- Use Pascal or existing project style where applicable, but preserve existing script file names unless asked to rename

## Formatting Rules

- Keep header comments at the top of the file
- Do not remove the required two-line MMS header
- Preserve existing RouterOS syntax and indentation style in each file
- Always update `# Script Version: YYYYMMDDHHMMSS` every time Copilot edits any `.rsc` file (functional or non-functional changes)
- for the `# Script Version`, use the format YYYYMMDDHHMMSS (year, month, day, hour, minute, second) and set it to the current date and time of the computer system whenever Copilot edits any `.rsc` file (functional or non-functional changes)
- Update `# Date: YYYY-MM-DD` to the current date every time Copilot edits any `.rsc` file (functional or non-functional changes)


## Safety Rules

- Never include passwords, secrets, or tokens in comments or headers
- Keep .vscode/ftp-sync.json out of source control

## PowerShell Script Header Requirements

Use these rules whenever creating or editing any .ps1 file in this repository.

- Do not use RouterOS `.rsc` header format in `.ps1` files.
- Do not add the `.rsc` two-line MMS header (`# MikroTik Management Scripts` and `# MMS Version: 0.01 Testing`) to any PowerShell file.
- Keep `.ps1` headers strictly in PowerShell comment-based help format and the `MasterPowershellScriptHeaderExample.txt` structure.

- Comment-Based Help: Include comprehensive comment-based help (`<# ... #>`) at the beginning of each script or function.
- Required Help Sections:
	- `.SYNOPSIS`: Brief description.
	- `.DESCRIPTION`: Detailed explanation.
	- `.PARAMETER`: Description for each parameter.
	- `.EXAMPLE`: Practical usage examples (use `PS>` for prompts).
	- `.INPUT`: Expected input types.
	- `.OUTPUT`: Expected output types.
	- `.NOTES`: Author, date, version, dependencies, or other important info.
	- `.LINK`: Relevant documentation or resources.
- Formatting:
	- Use PascalCase for function and parameter names.
	- Avoid using aliases (example: use `Get-ChildItem` instead of `gci`).
	- Follow consistent PowerShell style with proper indentation.

Every script and function must include a standard header based on `MasterPowershellScriptHeaderExample.txt`.

Replace the following fields in the header:

- `[CurrentDate]` -> File metadata modified date
- `[CurrentTime]` -> File metadata modified time
- `[TIMEZONE]` -> System time zone
- `[CurrentYear]` -> File metadata modified year
- `[IsAIUsed]` -> True or False
- `[AIUsed]` -> Name of AI used (or N/A)
- `[AuthorCompany]` -> Author company name
- `[LicenseName]` -> License name
- `[URLToLicense]` -> License URL
- `[ScriptType]` -> Function or Application

Header may include AI override variables if required.

## PowerShell Script Footer Requirements

- All PowerShell scripts must include a commented example usage block at the end of the file.

## Change Log Requirements

Use these rules whenever creating or editing any `.rsc` or `.ps1` file in this repository.

- Create or update a per-file change log in the root `logs/` folder.
- Keep one change log file per script file (do not combine multiple script files into one log file).
- The change log entry must include:
	- Script file name
	- Date/time of the change
	- New script version number after the change
	- A short plain-language synopsis of what changed
- Keep entries concise and append new entries in chronological order.

Recommended log file naming:

- `<script-filename>.changelog.md`

Examples:

- `logs/MMS-dataSetMapSync.rsc.changelog.md`
- `logs/Invoke-RemoteUserImport.ps1.changelog.md`
