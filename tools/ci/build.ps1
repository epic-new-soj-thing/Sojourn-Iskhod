if (!(Test-Path -Path "C:/byond")) {
	if (Test-Path -Path "tools/ci/byond_working-win.zip") {
		Write-Host "Using local BYOND zip"
		Copy-Item "tools/ci/byond_working-win.zip" "C:/byond.zip"
	}
	else {
		bash tools/ci/download_byond.sh
		if (Test-Path -Path "byond.zip") {
			Move-Item "byond.zip" "C:/byond.zip"
		}
	}
	[System.IO.Compression.ZipFile]::ExtractToDirectory("C:/byond.zip", "C:/")
	Remove-Item C:/byond.zip
}

bash tools/ci/install_node.sh
bash tools/build/build

exit $LASTEXITCODE
