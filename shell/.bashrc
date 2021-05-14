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

alias ls="ls -AohvF --color"
alias grep="grep --color=auto"

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

# Linux Bash Completion

if [[ -r "/etc/bash_completion" ]]; then
    source "/etc/bash_completion"
fi 

# Pyenv

if type pyenv &>/dev/null; then
    export PATH="${PATH}:$(pyenv root)/shims"
fi

# Kubernetes

if type krew &>/dev/null; then
    export PATH="${PATH}:${KREW_ROOT:-${HOME}/.krew}/bin"
fi

export KUBE_EDITOR='code -n --wait'

# Bin

export PATH="${PATH}:${HOME}/.local/bin:${HOME}/bin"

# Work

if [[ -r "${HOME}/.bashrc_work" ]]; then
    source "${HOME}/.bashrc_work"
fi
