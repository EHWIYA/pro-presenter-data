# Git 자산의 준비, pull, 경로 적용, push 순서를 실행한다.
function Initialize-GitAssets {
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
    Invoke-Checked "GitHub 최신 내용 받기" { git pull --rebase }
    Invoke-Checked "이 PC용 경로 적용" { python scripts/path.py smudge-files }
    Invoke-Checked "GitHub에 올리기" { git push }
}
