#Requires -RunAsAdministrator

function check-sccm-policy {
    if ((Get-Service ccmexec).Status -ne "Running") {Start-Service ccmexec -Verbose; sleep 5;}

    Invoke-CimMethod -Namespace 'root\CCM' -ClassName SMS_Client -MethodName TriggerSchedule -Arguments @{sScheduleID='{00000000-0000-0000-0000-000000000021}'} # Machine Policy Retrieval Cycle
    Invoke-CimMethod -Namespace 'root\CCM' -ClassName SMS_Client -MethodName TriggerSchedule -Arguments @{sScheduleID='{00000000-0000-0000-0000-000000000022}'} # Machine Policy Evaluation Cycle
    Invoke-CimMethod -Namespace 'root\CCM' -ClassName SMS_Client -MethodName TriggerSchedule -Arguments @{sScheduleID='{00000000-0000-0000-0000-000000000108}'} # Software Updates Assignments Evaluation Cycle
    Invoke-CimMethod -Namespace 'root\CCM' -ClassName SMS_Client -MethodName TriggerSchedule -Arguments @{sScheduleID='{00000000-0000-0000-0000-000000000113}'} # Software Update Scan Cycle
    Invoke-CimMethod -Namespace 'root\CCM' -ClassName SMS_Client -MethodName TriggerSchedule -Arguments @{sScheduleID='{00000000-0000-0000-0000-000000000121}'} # Application Deployment Evaluation Cycle
}

check-sccm-policy
