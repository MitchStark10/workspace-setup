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
alias tekSca="scNode;cd ~/projects/tekton-2019-2"
alias conSca="scNode;cd ~/projects/tekton-connect-2019-2"
alias db="cd ~/projects/shopping-database"
alias shop="cd ~/projects/shopify"
alias prox="cd ~/projects/shopify-proxy"
alias sssh="ssh \"Mitch Stark\"@192.168.1.110"
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
alias picasso="nvm use 14.17.4;cd ~/projects/commerce/"
alias pl="picasso;npm run dev;"
alias stb="picasso;npm run storybook"
alias vim="nvim";
alias nvimconfig="nvim ~/.config/nvim/init.vim"
alias vendure="cd ~/projects/vendure"
alias saleor="cd ~/projects/saleor-platform"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#Default version of node
devNode

#Git tools
alias deleteOldBranches="git branch --merged | egrep -v \"(^\*|master|dev)\" | xargs git branch -d"


source ~/private.zshrc
