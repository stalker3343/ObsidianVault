param(
    [string]$SourceDir = $PSScriptRoot,
    [int]$Year = 2026,
    [int[]]$Months = @(4, 5, 6)
)

$ErrorActionPreference = 'Stop'

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$dateFileRegex = '^(?<date>\d{4}-\d{2}-\d{2})\.md$'

function Read-Utf8File {
    param([string]$Path)

    if ((Get-Item -LiteralPath $Path).Length -eq 0) {
        return ''
    }

    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

function Normalize-NoteBody {
    param(
        [string]$Content,
        [string]$Date
    )

    $body = $Content -replace "^\uFEFF", ''
    $body = $body -replace "`r`n", "`n"
    $body = $body -replace "`r", "`n"

    # Remove existing first-level date headings so every note has one clean heading.
    $escapedDate = [System.Text.RegularExpressions.Regex]::Escape($Date)
    $body = [System.Text.RegularExpressions.Regex]::Replace(
        $body,
        "(?m)^\s*#\s+$escapedDate\s*$\n?",
        ''
    )

    return $body.Trim()
}

foreach ($month in $Months) {
    $monthText = '{0:D2}' -f $month
    $outputPath = Join-Path $SourceDir ('{0}-{1}.md' -f $Year, $monthText)

    $notes = Get-ChildItem -LiteralPath $SourceDir -File |
        Where-Object {
            $match = [System.Text.RegularExpressions.Regex]::Match($_.Name, $dateFileRegex)
            if (-not $match.Success) {
                return $false
            }

            $date = $match.Groups['date'].Value
            return $date.StartsWith(('{0}-{1}-' -f $Year, $monthText))
        } |
        Sort-Object Name |
        ForEach-Object {
            $date = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
            $content = Read-Utf8File -Path $_.FullName
            $body = Normalize-NoteBody -Content $content -Date $date

            if ([string]::IsNullOrWhiteSpace($body)) {
                return "# $date"
            }

            return "# $date`n`n$body"
        }

    $monthlyContent = ($notes -join "`n`n")
    if ($monthlyContent.Length -gt 0) {
        $monthlyContent += "`n"
    }

    [System.IO.File]::WriteAllText($outputPath, $monthlyContent, $utf8NoBom)
    Write-Host "Wrote $outputPath ($($notes.Count) notes)"
}
