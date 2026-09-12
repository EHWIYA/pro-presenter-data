# 외부 명령의 단계 표시와 종료 코드 검사를 공통 처리한다.
function Invoke-Checked {
    param([string]$Name, [scriptblock]$Command)
    $script:StepNumber++
    Write-Host "`n[$StepNumber/$StepTotal] $Name" -ForegroundColor Yellow
    $global:LASTEXITCODE = 0
    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw "$Name failed with exit code $LASTEXITCODE"
    }
    Write-Host "      [완료] $Name" -ForegroundColor Green
}

function Invoke-RcloneQuiet {
    param([string[]]$Arguments)
    $previous = $ErrorActionPreference
    try {
        $ErrorActionPreference = "SilentlyContinue"
        $output = & rclone @Arguments 2>&1 | Out-String
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previous
    }
    [pscustomobject]@{ ExitCode = $code; Output = $output }
}
