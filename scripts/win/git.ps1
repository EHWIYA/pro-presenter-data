# Git 자산의 준비, pull, 경로 적용, push 순서를 실행한다.
function Assert-GitSyncReady {
    foreach ($state in @("rebase-merge", "rebase-apply", "MERGE_HEAD", "CHERRY_PICK_HEAD", "REVERT_HEAD")) {
        $statePath = git rev-parse --git-path $state
        if ($LASTEXITCODE -ne 0) { throw "Git 저장소 상태를 확인할 수 없습니다." }
        if (Test-Path -LiteralPath $statePath) {
            $conflicts = @(git -c core.quotepath=false diff --name-only --diff-filter=U) -join ", "
            throw "GIT_SYNC_BLOCKED: 중단된 Git 작업($state)이 있습니다. 충돌 파일: $conflicts. git status로 확인하고 해결 후 다시 실행하세요."
        }
    }
    git symbolic-ref --quiet HEAD | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "GIT_SYNC_BLOCKED: 브랜치에서 분리된 HEAD입니다. 현재 커밋을 보존하고 브랜치 복구 후 다시 실행하세요."
    }
}

function Initialize-GitAssets {
    Assert-GitSyncReady
    Invoke-Checked "경로 필터 확인" {
        git config --get filter.pp-paths.clean | Out-Null
    }
    Invoke-Checked "변경 자산 준비" {
        git add -- Libraries Playlists Presets Themes Fonts
    }
    git diff --cached --quiet
    if ($LASTEXITCODE -eq 1) {
        $script:StepTotal++
        Invoke-Checked "자동 커밋" {
            git commit -m "예배 세션 자동 동기화 $Timestamp"
        }
    } elseif ($LASTEXITCODE -eq 0) {
        Write-Host "      [건너뜀] 커밋할 자산이 없습니다." -ForegroundColor DarkGray
    } else {
        throw "Git 변경 사항 확인에 실패했습니다."
    }
}

function Invoke-GitRemote {
    try { Invoke-Checked "GitHub 최신 내용 받기" { git pull --rebase } }
    catch { Assert-GitSyncReady; throw }
    Invoke-Checked "이 PC용 경로 적용" { python scripts/path.py smudge-files }
    Invoke-Checked "GitHub에 올리기" { git push }
}
