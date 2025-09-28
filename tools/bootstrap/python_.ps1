# bootstrap/python_.ps1
#
# Python bootstrapping script for Windows.
#
# Automatically downloads a portable edition of a pinned Python version to
# a cache directory, installs Pip, installs `requirements.txt`, and then invokes
# Python.
#
# The underscore in the name is so that typing `bootstrap/python` into
# PowerShell finds the `.bat` file first, which ensures this script executes
# regardless of ExecutionPolicy.
$host.ui.RawUI.WindowTitle = "starting :: python $args"
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Add-Type -AssemblyName System.IO.Compression.FileSystem

function ExtractVersion {
	param([string] $Path, [string] $Key)
	foreach ($Line in Get-Content $Path) {
		if ($Line.StartsWith("export $Key=")) {
			return $Line.Substring("export $Key=".Length)
		}
	}
	throw "Couldn't find value for $Key in $Path"
}

# Convenience variables
$Bootstrap = Split-Path $script:MyInvocation.MyCommand.Path
$Tools = Split-Path $Bootstrap
$Cache = "$Bootstrap/.cache"
if ($Env:TG_BOOTSTRAP_CACHE) {
	$Cache = $Env:TG_BOOTSTRAP_CACHE
}
$PythonVersion = ExtractVersion -Path "$Bootstrap/../../dependencies.sh" -Key "PYTHON_VERSION"
$PythonDir = "$Cache/python-$PythonVersion"
$PythonExe = "$PythonDir/python.exe"
$Log = "$Cache/last-command.log"

# Download and unzip a portable version of Python
if (!(Test-Path $PythonExe -PathType Leaf)) {
	$host.ui.RawUI.WindowTitle = "Downloading Python $PythonVersion..."
	New-Item $Cache -ItemType Directory -ErrorAction silentlyContinue | Out-Null

	$Archive = "$Cache/python-$PythonVersion-embed.zip"
	Invoke-WebRequest `
		"https://www.python.org/ftp/python/$PythonVersion/python-$PythonVersion-embed-amd64.zip" `
		-OutFile $Archive `
		-ErrorAction Stop

	[System.IO.Compression.ZipFile]::ExtractToDirectory($Archive, $PythonDir)

	# Copy a ._pth file without "import site" commented, so pip will work
	$PythonMajorMinor = $PythonVersion -replace "^(\d+\.\d+).*", '$1' -replace "\.", ""
	$PthFile = "$Bootstrap/python$PythonMajorMinor._pth"
	if (!(Test-Path $PthFile)) {
		# Fallback to a generic python3._pth if specific version doesn't exist
		$PthFile = "$Bootstrap/python3._pth"
		if (!(Test-Path $PthFile)) {
			throw "No suitable ._pth file found for Python $PythonVersion"
		}
	}

	# Simply copy the .pth file - don't modify it as that breaks the standard library
	Copy-Item $PthFile "$PythonDir\python$PythonMajorMinor._pth" -ErrorAction Stop	Remove-Item $Archive
}

# Install pip
if (!(Test-Path "$PythonDir/Scripts/pip.exe") -and !(Test-Path "$PythonDir/Lib/site-packages/pip")) {
	$host.ui.RawUI.WindowTitle = "Downloading Pip..."

	Invoke-WebRequest "https://bootstrap.pypa.io/get-pip.py" `
		-OutFile "$Cache/get-pip.py" `
		-ErrorAction Stop

	# Create the Lib/site-packages directory if it doesn't exist
	New-Item "$PythonDir/Lib/site-packages" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

	# For embedded Python, install directly to the site-packages directory
	& $PythonExe "$Cache/get-pip.py" --no-warn-script-location --target="$PythonDir/Lib/site-packages"
	if ($LASTEXITCODE -ne 0) {
		Write-Host "Direct pip installation failed. Trying with prefix..."
		& $PythonExe "$Cache/get-pip.py" --no-warn-script-location --prefix="$PythonDir"
		if ($LASTEXITCODE -ne 0) {
			Write-Host "All pip installation methods failed. Continuing without pip..."
		}
	}

	# Also try to create a pip script in the Python directory for easier access
	$PipScript = @"
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'Lib', 'site-packages'))
from pip import main
if __name__ == '__main__':
    sys.exit(main())
"@
	$PipScript | Out-File -Encoding ASCII "$PythonDir/pip.py"

	Remove-Item "$Cache/get-pip.py" `
		-ErrorAction Stop
}

# Use pip to install our requirements
if (!(Test-Path "$PythonDir/requirements.txt") -or ((Get-FileHash "$Tools/requirements.txt").hash -ne (Get-FileHash "$PythonDir/requirements.txt").hash)) {
	$host.ui.RawUI.WindowTitle = "Updating dependencies..."

	# Try different methods to use pip
	$PipSuccess = $false

	# Method 1: Try python -m pip
	& $PythonExe -m pip install -U pip -r "$Tools/requirements.txt" 2>&1 | Out-Null
	if ($LASTEXITCODE -eq 0) {
		$PipSuccess = $true
	} else {
		# Method 2: Try using our pip.py script
		if (Test-Path "$PythonDir/pip.py") {
			& $PythonExe "$PythonDir/pip.py" install -U pip -r "$Tools/requirements.txt" 2>&1 | Out-Null
			if ($LASTEXITCODE -eq 0) {
				$PipSuccess = $true
			}
		}

		# Method 3: Try using pip executable if it exists
		if (!$PipSuccess -and (Test-Path "$PythonDir/Scripts/pip.exe")) {
			& "$PythonDir/Scripts/pip.exe" install -U pip -r "$Tools/requirements.txt" 2>&1 | Out-Null
			if ($LASTEXITCODE -eq 0) {
				$PipSuccess = $true
			}
		}
	}

	if (!$PipSuccess) {
		Write-Host "Warning: Could not install requirements using pip. Some functionality may not work."
	}

	Copy-Item "$Tools/requirements.txt" "$PythonDir/requirements.txt"
	Write-Output "`n---`n"
}

# Invoke python with all command-line arguments
Write-Output $PythonExe | Out-File -Encoding utf8 $Log
[System.String]::Join([System.Environment]::NewLine, $args) | Out-File -Encoding utf8 -Append $Log
Write-Output "---" | Out-File -Encoding utf8 -Append $Log
$host.ui.RawUI.WindowTitle = "python $args"
$ErrorActionPreference = "Continue"
& $PythonExe -u $args 2>&1 | ForEach-Object {
	$str = "$_"
	if ($_.GetType() -eq [System.Management.Automation.ErrorRecord]) {
		$str = $str.TrimEnd("`r`n")
	}
	$str | Out-File -Encoding utf8 -Append $Log
	$str | Out-Host
}
exit $LastExitCode
