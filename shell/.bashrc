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

# Completion

if [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]]; then
    source "/usr/local/etc/profile.d/bash_completion.sh"
fi

# Homebrew / Bin

if which brew &>/dev/null; then
    export PATH="${PATH}:/usr/local/bin"
fi

export PATH+"${PATH}:${HOME}/.local/bin:${HOME}/bin"

# Pyenv

if which pyenv &>/dev/null; then
    export PATH="${PATH}:$(pyenv root)/shims"
fi

# Kubernetes

if which krew &>/dev/null; then
    export PATH="${PATH}:${KREW_ROOT:-${HOME}/.krew}/bin"
fi

export KUBE_EDITOR='code -n --wait'

# Work

if [[ -r "${HOME}/.bashrc_work" ]]; then
    source "${HOME}/.bashrc_work"
fi
