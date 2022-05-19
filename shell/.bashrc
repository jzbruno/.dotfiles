# Prompt

if [[ -z "${PS1}" ]]; then
	return
fi

function _prompt() {
    PS1="\w \$ "
}

export PROMPT_COMMAND=_prompt

# MacOS now defauls to zsh and won't shut up about it.

export BASH_SILENCE_DEPRECATION_WARNING=1

# Colors

export CLICOLOR=1
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History

export HISTCONTROL=ignoreboth
shopt -s histappend

# Aliases

if [[ "$OSTYPE" == "darwin"* ]]; then
	alias ls="ls -AohvF"
else
	alias ls="ls -AohvF --color"
fi
alias grep="grep --color=auto"

# Linux Bash Completion

if [[ -r "/etc/bash_completion" ]]; then
    source "/etc/bash_completion"
fi 

# Homebrew

if type brew &>/dev/null; then
    eval $(brew shellenv)
    
    if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [[ -r "$COMPLETION" ]] && source "$COMPLETION"
        done
    fi
fi

# Pyenv

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Kubernetes

export KUBE_EDITOR='code -n --wait'

# Bin

export HOMEBREW_PREFIX="/usr/local";
export HOMEBREW_CELLAR="/usr/local/Cellar";
export HOMEBREW_REPOSITORY="/usr/local/Homebrew";
export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}";
export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/usr/local/share/info:${INFOPATH:-}";

# Work

if [[ -r "${HOME}/.bashrc_work" ]]; then
    source "${HOME}/.bashrc_work"
fi
