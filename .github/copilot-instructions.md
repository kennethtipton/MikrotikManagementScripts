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
