# run_load_test.ps1
param(
    [int]$vus = 50,
    [string]$duration = "1m"
)

# Set environment variables for k6
$env:VUS = $vus
$env:DURATION = $duration

# Ensure k6 is installed
if (-not (Get-Command k6 -ErrorAction SilentlyContinue)) {
    Write-Host "k6 not found. Installing via winget..."
    winget install -e --id Grafana.k6 -h
    if (-not (Get-Command k6 -ErrorAction SilentlyContinue)) {
        Write-Error "Failed to install k6. Please install it manually."
        exit 1
    }
}

# Run the k6 script
k6 run "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\k6_script.js" --out json=k6-output.json
