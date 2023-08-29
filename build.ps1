param(
    $Version = $(
        if ((Get-Command gitversion -ErrorAction SilentlyContinue) -and (gitversion /showvariable SemVer) -and $LASTEXITCODE -eq 0) {
            gitversion /showvariable SemVer
        } else {'0.0.1-prerelease'}
    ),

    [switch]$SkipPackage
)
Build-Module -SemVer $Version

if (-not $SkipPackage -and (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    $PackResult = choco pack $PSScriptRoot\chocolatey\inzip.powershell.nuspec --version $Version --limit-output

    if ($LASTEXITCODE -eq 0) {
        Write-Verbose $PackResult[-1]
        $ChocolateyPackage = $PackResult[-1] -replace "Successfully created package '(?<Path>.+)'", '${Path}'
    } else {
        Write-Error "Failed to pack InZip Chocolatey Package: $($PackResult)"
    }
}