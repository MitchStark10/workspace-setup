# zsh configuration
export ZSH="/Users/mitchstark/.oh-my-zsh"
ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh

#Path Extensions
export PATH=~/Library/Python/3.9/bin:$PATH

#Alias
alias scNode="nvm use 12.16.1"
alias devNode="nvm use 14.17.4"
alias ls="ls -al"
alias proj="nvm use 13.8.0;cd ~/projects/tst2"
alias mitSand="cd ~/projects/TektonSuiteScript/MIT\ SuiteScript\ -\ Sandbox"
alias mitProd="cd ~/projects/TektonSuiteScript/MIT\ SuiteScript\ -\ Production"
alias tekSand="cd ~/projects/TektonSuiteScript/Tekton\ SuiteScript\ -\ Sandbox"
alias tekProd="cd ~/projects/TektonSuiteScript/Tekton\ SuiteScript\ -\ Production"
alias tss="cd ~/projects/TektonSuiteScript"
alias conSca="scNode;cd ~/projects/tekton-connect-2019-2"
alias sssh="ssh \"Mitch Stark\"@192.168.1.110"
alias home="cd ~"
alias resource="source ~/.zshrc"
alias deployComplete="osascript -e 'tell app \"System Events\" to display dialog \"Deploy Complete\"'"
alias ed="gulp extension:deploy --to; deployComplete "
alias td="gulp theme:deploy --to; deployComplete "
alias cel="conSca;cd extensions; gulp extension:local"
alias cwf="conSca;cd extensions; gulp watch-folder"
alias v="nvim"
alias pl="picasso;npm run dev;"
alias vim="nvim";
alias nvimconfig="nvim ~/.config/nvim/init.vim"
alias todo="vim scp://root@159.223.180.95/todo.txt"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#Default version of node
devNode

#Git tools
alias deleteOldBranches="git branch --merged | egrep -v \"(^\*|master|dev)\" | xargs git branch -d"


source ~/private.zshrc
