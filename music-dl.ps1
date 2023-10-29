param(
    [CmdletBinding()]
    [Parameter(Mandatory=$true)]
    [string]
    $urls
)

$executable = Get-Command -Name yt-dlp -ErrorAction SilentlyContinue
if (!$executable) { $executable = Get-Command -Name youtube-dl -ErrorAction SilentlyContinue }
if (!$executable) {
    Write-Error "No executable found for youtube-dl or yt-dlp"
    Write-Error "Make sure either is installed and try again"
    exit 1
}
$executable = $executable.Source


& $executable `
    --sponsorblock-remove all `
    --embed-metadata `
    --embed-thumbnail `
    --format bestaudio `
    --extract-audio --audio-format mp3 --audio-quality 0 `
    --output "%(title)s.%(ext)s" `
    $urls

if ($LASTEXITCODE -eq 1) {
    Write-Host "Retrying download as batch file"
    & $executable `
        --sponsorblock-remove all `
        --embed-metadata `
        --embed-thumbnail `
        --format bestaudio `
        --extract-audio --audio-format mp3 --audio-quality 0 `
        --output "%(title)s.%(ext)s" `
        --batch-file $urls
}
