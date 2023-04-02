function proj {
    Set-Location C:/Users/Mitch/projects/soccersage.io;
}

function home {
    Set-Location C:/Users/Mitch;
}

function cleanBranches {
  git branch --merged | Select-String -Pattern '^(?!.*(master|dev|release|main)).*$' | ForEach-Object { git branch -d $_.ToString().Trim() }
}