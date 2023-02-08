Start-Sleep -Seconds (1 * 3600)

$PowerState = [System.Windows.Forms.PowerState]::Suspend;

# 2. Choose whether or not to force the power state
$Force = $false;

# 3. Choose whether or not to disable wake capabilities
$DisableWake = $false;

# Set the power state
[System.Windows.Forms.Application]::SetSuspendState($PowerState, $Force, $DisableWake);

