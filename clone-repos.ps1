# Clone Scott Hanselman's repositories
# Run this AFTER: gh auth login

$repoRoot = "D:\github"

# Verify gh is authenticated
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Not authenticated to GitHub. Run 'gh auth login' first." -ForegroundColor Red
    exit 1
}

Write-Host "Authenticated to GitHub. Cloning repos to $repoRoot..." -ForegroundColor Green

# Fetch Nightscout URL from private gist and set as user env var
Write-Host "Setting up Nightscout URL..." -ForegroundColor Cyan
try {
    $nightscoutRaw = gh gist view 985fa5febe6dbf7f2df70d6582d734d9 --raw
    if ($nightscoutRaw -and ($nightscoutRaw -match '(https://[^\s]+)')) {
        $nightscoutUrl = $matches[1]
        [Environment]::SetEnvironmentVariable("OSTENSIBLY_NIGHTSCOUT_URL", $nightscoutUrl, "User")
        $env:OSTENSIBLY_NIGHTSCOUT_URL = $nightscoutUrl
        Write-Host "Nightscout URL configured: $nightscoutUrl" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Could not parse Nightscout URL from gist" -ForegroundColor Yellow
    }
} catch {
    Write-Host "WARNING: Could not fetch Nightscout URL from gist: $_" -ForegroundColor Yellow
}

# List of repos to clone (add your repos here)
$repos = @(
    "shanselman/azurefridayaggregator"
    "shanselman/hanselminutes-core"
    "shanselman/HanselminutesAdmin"
    "shanselman/WindowsEdgeLight"
    "shanselman/hanselman-core"
    "shanselman/devchangelog"
    "shanselman/azure-friday-yaml"
    "shanselman/azurefridayanalysis"
    "shanselman/LLMStudyGuide"
    "shanselman/babysmashwebsite"
    "shanselman/babysmash"
)

foreach ($repo in $repos) {
    $repoName = $repo.Split("/")[-1]
    $targetPath = Join-Path $repoRoot $repoName
    
    if (Test-Path $targetPath) {
        Write-Host "SKIP: $repoName already exists" -ForegroundColor Yellow
    } else {
        Write-Host "Cloning: $repo" -ForegroundColor Cyan
        gh repo clone $repo $targetPath
    }
}

Write-Host ""
Write-Host "Done! Your repos are in $repoRoot" -ForegroundColor Green
