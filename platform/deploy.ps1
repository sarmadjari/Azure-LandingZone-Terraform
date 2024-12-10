# Define variables
$TfVarsFile = "terraform-test.tfvars"
$LogFile    = "terraform-apply.log"

# Set strict mode to catch common scripting issues
Set-StrictMode -Version Latest

# Check if terraform is installed and accessible
if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
    Write-Host "Terraform is not installed or not in the PATH."
    exit 1
}

# Check if the tfvars file exists
if (-not (Test-Path $TfVarsFile)) {
    Write-Host "Variable file '$TfVarsFile' does not exist. Please ensure it is present."
    exit 1
}

# Clear previous log file if it exists
if (Test-Path $LogFile) {
    Remove-Item $LogFile
}

try {
    Write-Host "Starting Terraform deployment..."
    Write-Host "Logs will be recorded in: $LogFile"
    
    # Record the start time
    $StartTime = Get-Date

    # Run terraform apply without color
    terraform apply -var-file="$TfVarsFile" -auto-approve -no-color 2>&1 | Tee-Object -FilePath $LogFile

    # Record the end time
    $EndTime = Get-Date
    # Calculate execution time
    $ExecutionTime = $EndTime - $StartTime
    $TotalSeconds = [math]::Round($ExecutionTime.TotalSeconds)

    # Format the time dynamically
    if ($TotalSeconds -lt 60) {
        Write-Host "Terraform deployment time: $TotalSeconds seconds"
    } elseif ($TotalSeconds -lt 3600) {
        $Minutes = [math]::Floor($TotalSeconds / 60)
        $Seconds = $TotalSeconds % 60
        Write-Host "Terraform deployment time: ${Minutes}:${Seconds} (minutes:seconds)"
    } else {
        $Hours   = [math]::Floor($TotalSeconds / 3600)
        $Minutes = [math]::Floor(($TotalSeconds % 3600) / 60)
        $Seconds = $TotalSeconds % 60
        Write-Host "Terraform deployment time: ${Hours}:${Minutes}:${Seconds} (hours:minutes:seconds)"
    }

    Write-Host "Terraform deployment completed successfully. Logs saved to $LogFile"
} catch {
    Write-Host "Terraform deployment failed."
    Write-Host "Error: $($_.Exception.Message)"
    Write-Host "Check the log file for details: $LogFile"
    exit 1
}
