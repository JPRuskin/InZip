function Update-FileInArchive {
    <#
        .Synopsis
            Updates a text file in an archive
        .Description
            In order to remove references to given files from install scripts, you may want to update a file within an archive (without repacking it).
            This function will update the content of files in the archive you specify.
        .Example
            Update-FileInArchive -Path $Nupkg -FullName "tools/chocolateyInstall.ps1" -Value $UpdatedScript
        .Example
            Update-FileInArchive -Zip $Zip -Name "chocolateyInstall.ps1" -Value $UpdatedScript
    #>
    [CmdletBinding(DefaultParameterSetName="PathFullName", SupportsShouldProcess)]
    param(
        # Path to the archive
        [Parameter(Mandatory, ParameterSetName = "PathFullName")]
        [Parameter(Mandatory, ParameterSetName = "PathName")]
        [string]$Path,

        # Zip object for the archive
        [Parameter(Mandatory, ParameterSetName = "ZipFullName")]
        [Parameter(Mandatory, ParameterSetName = "ZipName")]
        [IO.Compression.ZipArchive]$Zip,

        # Name of the file to update in the archive
        [Parameter(Mandatory, ParameterSetName = "PathFullName")]
        [Parameter(Mandatory, ParameterSetName = "ZipFullName")]
        [string]$FullName,

        # Name of the file to update in the archive
        [Parameter(Mandatory, ParameterSetName = "PathName")]
        [Parameter(Mandatory, ParameterSetName = "ZipName")]
        [string]$Name,

        # Value to set the file to
        [Parameter(Mandatory)]
        [string]$Value
    )
    begin {
        if (-not $PSCmdlet.ParameterSetName.StartsWith("Zip")) {
            $Stream = [IO.FileStream]::new($Path, [IO.FileMode]::Open)
            $Zip = [IO.Compression.ZipArchive]::new($Stream, [IO.Compression.ZipArchiveMode]::Update)
        }
    }
    process {
        if (-not $FullName) {
            $MatchingEntries = $Zip.Entries | Where-Object {$_.Name -eq $Name}
            if ($MatchingEntries.Count -ne 1) {
                Write-Error "File '$Name' not found in archive" -ErrorAction Stop
            }
            $FullName = $MatchingEntries[0].FullName
        }
        if ($PSCmdlet.ShouldProcess("Update", $_.FullName)) {
            # Either remove file, create entry
            Remove-FileInArchive -Zip $Zip -FullName $FullName
            $Zip.CreateEntry()

            # Or update existing entry and length

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