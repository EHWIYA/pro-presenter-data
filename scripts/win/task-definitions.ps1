# 기존 예약 작업과 원하는 실행 정의가 같은지 비교하고 필요할 때만 등록한다.
function Test-ScheduledTaskDefinition {
    param([string]$Name, $Action, [bool]$NeedsTrigger)
    $current = Get-ScheduledTask -TaskName $Name -ErrorAction SilentlyContinue
    if (-not $current) { return $false }
    $existing = @($current.Actions)[0]
    $actionMatches = $existing.Execute -eq $Action.Execute `
        -and $existing.Arguments -eq $Action.Arguments `
        -and $existing.WorkingDirectory -eq $Action.WorkingDirectory
    $triggers = @($current.Triggers | Where-Object { $null -ne $_ })
    $triggerMatches = ($triggers.Count -gt 0) -eq $NeedsTrigger
    return $actionMatches -and $triggerMatches
}

function Register-ScheduledTaskIfNeeded {
    param(
        [string]$Name, $Action, $Principal, $Settings,
        [string]$Description, $Trigger = $null
    )
    $needsTrigger = $null -ne $Trigger
    if (Test-ScheduledTaskDefinition $Name $Action $needsTrigger) { return }
    $parameters = @{
        TaskName = $Name; Action = $Action; Principal = $Principal
        Settings = $Settings; Description = $Description; Force = $true
    }
    if ($needsTrigger) { $parameters.Trigger = $Trigger }
    Register-ScheduledTask @parameters | Out-Null
}
