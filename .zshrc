# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh

#Path Extensions
export PATH=~/Library/Python/3.9/bin:~/bin:$PATH

#Alias
alias ls="ls -al"
alias home="cd ~"
alias editProfile="vim ~/.zshrc"
alias resource="source ~/.zshrc"
alias v="nvim"
alias snips="vim ~/tools/UltiSnips/"
alias prox="npx localtunnel --port 3000 --subdomain mitch10localdev"
alias vim="nvim";
alias nvimconfig="nvim ~/.config/nvim/init.vim"
alias gprunesquashmerged='git checkout -q main && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base main $branch) && [[ $(git cherry main $(git commit-tree $(git rev-parse "$branch^{tree}") -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'
alias reset="rm -rf node_modules/ package-lock.json .next; npm i"
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#Git tools
alias deleteOldBranches="git branch --merged | egrep -v \"(^\*|main|master|dev|sandbox)\" | xargs git branch -d"

[ -f "$HOME/private.zshrc" ] && source "$HOME/private.zshrc"
[ -f "$HOME/company.zshrc" ] && source "$HOME/company.zshrc"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# TODO: This needs more work
function cleanBranches() {
    branches=()
    eval "$(git for-each-ref --shell --format='branches+=(%(refname)) refs/head')"
    for branch in "${branches[@]}"; do
        prefix="refs/head"
        localBranch=${branch/#$prefix}
        echo $localBranch
    done
}

function localClaude {
  lms server start --port 1234
  export ANTHROPIC_BASE_URL="http://localhost:1234"
  export ANTHROPIC_AUTH_TOKEN="lmstudio"
  claude --model google/gemma-4-31b
}

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

export PATH="/opt/homebrew/opt/dotnet@8/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/mitchellstark/.lmstudio/bin"
# End of LM Studio CLI section

export PATH="$HOME/.local/bin:$PATH"

# Docker desktop in the user space
export PATH="$HOME/.docker/bin:$PATH"

