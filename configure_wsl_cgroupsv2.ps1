# Read the file if it exists
if (Test-Path $env:USERPROFILE\.wslconfig) {
    $fileContent = Get-Content -Path $env:USERPROFILE\.wslconfig
    # Create a timestamp-based backup
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    Copy-Item -Path $env:USERPROFILE\.wslconfig -Destination "$env:USERPROFILE\.wslconfig.$timestamp.backup"
} else {
    $fileContent = @()
}

# Check if [wsl2] section exists
$wslSectionExists = $fileContent -match "\[wsl2\]"

# Check if specific line exists
$lineExists = $fileContent -match "kernelCommandLine = cgroup_no_v1=all systemd.unified_cgroup_hierarchy=1"

if ($wslSectionExists -and $lineExists) {
    Write-Output "The configuration is already set."
} elseif ($wslSectionExists -and -not $lineExists) {
    Add-Content -Path $env:USERPROFILE\.wslconfig -Value "kernelCommandLine = cgroup_no_v1=all systemd.unified_cgroup_hierarchy=1"
    Write-Output "The configuration has been updated. Shutting down WSL..."
    wsl --shutdown
} else {
    Add-Content -Path $env:USERPROFILE\.wslconfig -Value "`n[wsl2]`nkernelCommandLine = cgroup_no_v1=all systemd.unified_cgroup_hierarchy=1"
    Write-Output "The configuration has been set. Shutting down WSL..."
    wsl --shutdown
}
