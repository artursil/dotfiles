# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"


# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/cat.json)"


export PATH=$PATH:/home/artursil/.local/bin
export PATH=$HOME/.npm-global/bin:$PATH
export PATH="$HOME/.fzf/bin:$PATH"

# Misc options
unsetopt beep # removing annoying beep

# Vim keybindings
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab


# Load completions
autoload -Uz compinit && compinit

zinit snippet OMZP::git
zinit snippet OMZP::sudo


zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'



bindkey '^f' autosuggest-accept


# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias cat='batcat'
alias bat='batcat'
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'
alias fcd='cd "$(find ${1:-.} -mindepth 1 -type d 2>/dev/null | fzf)"'
alias fls='lsd -ah "$(find ${1:-.} -mindepth 1 -type d 2>/dev/null | fzf)"'
alias gh='cd $HOME'
alias zs='source $HOME/.zshrc'


# Shell integrations

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"
