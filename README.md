# InZip

InZip is a PowerShell module designed to work with files inside Zip archives.

```powershell
# What is the canonical ID of this Chocolatey package?
[xml]$Nuspec = Find-FileInArchive -Path $Nupkg -match "\w+\.nuspec" | Get-FileContentInArchive
$Nuspec.package.metadata.id
```

This can be used for quickly testing or modifying files in a variety of zip-archives without spending time or code creating and cleaning up temporary files.

## Building InZip

InZip uses the `ModuleBuilder` module to compile and bundle the various source files into modules.

Running `Build.ps1` should result in a compiled (versioned) folder within the root folder containing the module.

My personal use for this is to have module-sources in a path that is on `$env:ModulePath`, such that building the module results in a versioned folder that resolves correctly, e.g. `~\Source\Modules\InZip\0.1.0\InZip.psd1`.

## Testing InZip

You can run `Test.ps1` to run all available tests, or run individual tests.

~~Tests are written to test the compiled module, so will require a build and import before any changes are reflected in the results.~~

As there are no function dependencies, Tests are written to dot-source individual function files and test them at run-time.

## Contributing to InZip

PRs would be very happily welcomed if this is in any way useful but lacking!
