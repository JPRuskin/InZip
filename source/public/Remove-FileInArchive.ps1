function Remove-FileInArchive {
    <#
        .Synopsis
            Removes files from a zip formatted archive
        .Description
            In order to reduce the size of an archive, you may want to remove files from it.
            This function will remove the files you specify from the archive you specify.
        .Example
            Remove-FileInArchive -Path $Nupkg -Name dotnet-sdk-3.1.410-win-x86.exe dotnet-sdk-3.1.410-win-x86.exe.ignore
        .Example
            Remove-FileInArchive -Zip $Zip -FullName "tools/chocolateyInstall.ps1"
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # Path to the archive
        [Parameter(Mandatory, ParameterSetName = "PathFullName")]
        [Parameter(Mandatory, ParameterSetName = "PathName")]
        [string]$Path,

        # Zip object for the archive
        [Parameter(Mandatory, ParameterSetName = "ZipFullName")]
        [Parameter(Mandatory, ParameterSetName = "ZipName")]
        [IO.Compression.ZipArchive]$Zip,

        # Name of the file(s) to remove in the archive
        [Parameter(Mandatory, ValueFromPipeline, ValueFromRemainingArguments, ParameterSetName="PathFullName")]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromRemainingArguments, ParameterSetName="ZipFullName")]
        [string[]]$FullName,

        # Name of the file(s) to remove in the archive
        [Parameter(Mandatory, ValueFromPipeline, ValueFromRemainingArguments, ParameterSetName="PathName")]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromRemainingArguments, ParameterSetName="ZipName")]
        [string[]]$Name
    )
    begin {
        if (-not $PSCmdlet.ParameterSetName.StartsWith("Zip")) {
            $Stream = [IO.FileStream]::new($Path, [IO.FileMode]::Open)
            $Zip = [IO.Compression.ZipArchive]::new($Stream, [IO.Compression.ZipArchiveMode]::Update)
        }
    }
    process {
        foreach ($File in Get-Variable -Name $PSCmdlet.ParameterSetName.TrimStart('PathZip') -ValueOnly) {
            ($Zip.Entries | Where-Object {$_."$($PSCmdlet.ParameterSetName.TrimStart('PathZip'))" -eq $File}) | ForEach-Object {
                if ($PSCmdlet.ShouldProcess($_.FullName, "Remove")) {
                    $_.Delete()
                }
            }
        }
    }
    end {
        if (-not $PSCmdlet.ParameterSetName.StartsWith("Zip")) {
            $Zip.Dispose()
            $Stream.Close()
            $Stream.Dispose()
        }
    }
}