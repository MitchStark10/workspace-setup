# zsh configuration
export ZSH="/Users/mitchstark/.oh-my-zsh"
ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh

#Path Extensions
export PATH=~/Library/Python/3.9/bin:~/bin:$PATH

export CYPRESS_CACHE_FOLDER=/Users/mitchstark/Library/Caches/Cypress

#Alias
alias scNode="nvm use 12.16.1"
alias devNode="nvm use 16.15.1"
alias tstNode="nvm use 14.17.4"
alias ls="ls -al"
alias proj="tstNode; ~/projects/tst2"
alias tss="cd ~/projects/netsuite"
alias tekSca="scNode;cd ~/projects/tekton-2019-2"
alias conSca="scNode;cd ~/projects/tekton-connect-2019-2"
alias db="cd ~/projects/shopping-database"
alias home="cd ~"
alias editProfile="vim ~/.zshrc"
alias resource="source ~/.zshrc"
alias fetchext="gulp extension:fetch"
alias fetchtheme="gulp theme:fetch"
alias runext="gulp extension:local"
alias runtheme="gulp theme:local"
alias deployComplete="osascript -e 'tell app \"System Events\" to display dialog \"Deploy Complete\"'"
alias ed="gulp extension:deploy --to; deployComplete "
alias td="gulp theme:deploy --to; deployComplete "
alias el="tekSca;cd extensions;gulp extension:local"
alias elp="tekSca;cd extensions;gulp extension:local --dev tekton-mitch"
alias wf="tekSca;cd extensions;gulp watch-folder"
alias cel="conSca;cd extensions; gulp extension:local"
alias cwf="conSca;cd extensions; gulp watch-folder"
alias v="nvim"
alias snips="vim ~/tools/UltiSnips/"
alias lt="nvm use 13.8.0;npx localtunnel --port 8080"
alias ltSca="nvm use 13.8.0;npx localtunnel --port 7777"
alias gitcojson="git co -- extensions/Workspace/TektonCustomizations/manifest.json;git co -- extensions/Workspace/TektonLiveChat/manifest.json;git co -- extensions/Workspace/TektonSupportForms/manifest.json;git co -- extensions/gulp/config/config.json;git co -- extensions/Workspace/SSPLocalNavigation/manifest.json;git co -- extensions/Workspace/RemoveAll/manifest.json"
alias mergeMasterIntoSandbox="tekSca;git co master;git pull;git co sandbox;git pull;git merge master"
alias pic="devNode;cd ~/projects/commerce/"
alias pl="pic;npm run dev;"
alias prox="npx localtunnel --port 3000 --subdomain mitch10localdev"
alias saf="pic; npm run local-proxy"
alias stb="pic;npm run storybook"
alias vim="nvim";
alias nvimconfig="nvim ~/.config/nvim/init.vim"
alias vendure="cd ~/projects/vendure"
alias saleor="cd ~/projects/saleor-platform"
alias arc="cd ~/projects/arcjs-test/;devNode;"
alias pint="devNode;cd ~/projects/pint/"
alias lib="devNode;cd ~/projects/npmlib/"
alias gprunesquashmerged='git checkout -q main && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base main $branch) && [[ $(git cherry main $(git commit-tree $(git rev-parse "$branch^{tree}") -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'
alias apps="cd ~/projects/ct-applications"
alias ter="cd ~/projects/ct-terraform"
alias scripts="cd ~/projects/ctCliScripts"
alias sync="cd ~/projects/ct-project-sync"

function prs() {
    currentDir=$(pwd)
    pic;gh pr status;
    echo "Press any key to continue"
    read anyKey;
    pint;gh pr status;
    echo "Press any key to continue"
    read anyKey;
    lib;gh pr status;
    echo "Press any key to continue"
    read anyKey;
    apps;gh pr status;
    echo "Press any key to continue"
    read anyKey;
    scripts;gh pr status;
    echo "Press any key to continue"
    read anyKey;
    ter;gh pr status;
    echo "Press any key to continue"
    read anyKey;
    cd $currentDir;
}

export PASSWORD_PROTECT_SITE="false"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#Default version of node
devNode

#Git tools
alias deleteOldBranches="git branch --merged | egrep -v \"(^\*|main|master|dev|sandbox)\" | xargs git branch -d"

source ~/private.zshrc

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
