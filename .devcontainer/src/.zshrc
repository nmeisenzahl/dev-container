export ZSH="/home/devcontainer/.oh-my-zsh"

ZSH_THEME="agnoster"

DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-completions
)

autoload -U compinit && compinit
source $ZSH/oh-my-zsh.sh

# autocomplete
complete -o nospace -C /usr/local/bin/terraform terraform
source /etc/bash_completion.d/azure-cli

# main prompt
prompt_kubecontext() {
  prompt_segment white black "`echo -n "☸️  "; kubectl config current-context`/`kubectl config get-contexts --no-headers | grep '*' | awk '{print $5}'`"
}

prompt_azcontext() {
  prompt_segment white black "`echo -n "☁️  "; cat /home/devcontainer/.azure/azureProfile.json | jq -r '.subscriptions[] | select(.isDefault == true) | .name'`"
  }

build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_dir
  prompt_git
  if [ -f "/home/devcontainer/.azure/azureProfile.json" ]; then prompt_azcontext; fi
  if [ -f "/home/devcontainer/.kube/config" ]; then prompt_kubecontext; fi

  prompt_end

}
PROMPT='%{%f%b%k%}$(build_prompt) '

# fix performance paste performance issue with syntax highlighting
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# some aliases and exports
alias k="kubectl"
alias kx="kubectx"
alias kn="kubens"
alias kt="kubetail"
alias t="terraform"

export GOPATH="$HOME/go"
export AZURE_CONFIG_DIR=$HOME/.azure
