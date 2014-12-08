# If not running interactively, don't do anything

if [[ -z "$PS1" ]]; then
	return
fi

# Colors

export CLICOLOR=1
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LSCOLORS=GxFxCxDxBxegedabagaced

C_RESET="$(tput sgr0)"
C_RED="$(tput setaf 1)"
C_GREEN="$(tput setaf 2)"
C_BLUE="$(tput setaf 4)"

# Prompt

function _prompt() {
	local code="$?"

	if [[ "$code" != "0" ]]; then
		# ~ [1] $
		PS1="\w [error \[${C_RED}\]${code}\[${C_RESET}\]] \$ "
	else
		# ~ $ 
		# ~/src/ $ 
		PS1="\w \$ "
	fi
}

export PROMPT_COMMAND=_prompt
export HISTCONTROL=ignoreboth

# Aliases

alias ls="ls -lhF"
alias grep="grep --color=auto"

# Bash completion

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Git

alias gitcb='git add . && git commit -m "cowboy" && git push origin'

function git-size() {
	git rev-list --objects --all | \
	git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | \
	sed -n 's/^blob //p' | \
	sort --numeric-sort --key=2 | \
	cut -c 1-12,41- | \
	$(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
}

# Homebrew

export PATH="/usr/local/bin:$PATH"

# Go

export GOPATH="$HOME/go"
mkdir -p $GOPATH
export PATH="$PATH:$GOPATH/bin"

# Pyenv

export PATH="$(pyenv root)/shims:$PATH"

# AWS

function _awsProfiles() {
	local credsFile="${AWS_CONFIG_FILE:-}"
	if [[ -z "$credsFile" ]]; then
		credsFile="$HOME/.aws/credentials"
	fi

    local profiles="$(grep -oP '(?<=\[)\w+(?=\])' $credsFile)"
    echo $profiles # unquoted to get space separated
}

function _awsRegions() {
	echo "us-east-1 us-west-2"
}

function _awsCreds() {
	local c=${COMP_WORDS[COMP_CWORD]}
	local p=${COMP_WORDS[COMP_CWORD-1]}

	case ${COMP_CWORD} in 
		1)
			COMPREPLY=( $(compgen -W "$(_awsProfiles)" -- $c) )
			;;
		2)
			COMPREPLY=( $(compgen -W "$(_awsRegions)" -- $c) )
			;;
	esac
}

function aws-env() {
	local profile="${1:-}"
	if [[ -z "${profile}" ]]; then
		echo "Missing required argument: profileName"
		return 1
	fi

	local region="${2:-"us-west-2"}"

    local credsfile="${HOME}/.aws/credentials"

    if [[ ! -f "${credsfile}" ]]; then
        echo "Credentials file does not exist at ${credsfile}"
        return 1
    fi

    if ! grep "^\[""${profile}""\]$" "${credsfile}" &>/dev/null; then
        echo "Profile not found in ${credsfile}"
        return 1
    fi

	echo export AWS_PROFILE="${profile}"
	echo export AWS_DEFAULT_REGION="${region}"
	echo export AWS_REGION="${region}"
    echo export AWS_ACCESS_KEY_ID="$(aws configure get aws_access_key_id --profile="${profile}")"
    echo export AWS_SECRET_ACCESS_KEY="$(aws configure get aws_secret_access_key --profile="${profile}")"
    echo export AWS_SESSION_TOKEN="$(aws configure get aws_session_token --profile="${profile}")"
}

# Kubernetes

alias krew="kubectl-krew"
alias kns="kubectl-ns"
alias kctx="kubectl-ctx"

export PATH="$PATH:${HOME}/.krew/bin"
export KUBE_EDITOR='code -n --wait'
