# For PowerShell <5.0, we need to load the System.IO.Compression assembly
if (-not ("System.IO.Compression.ZipArchive" -as [type])) {
    Add-Type -Assembly 'System.IO.Compression'
}