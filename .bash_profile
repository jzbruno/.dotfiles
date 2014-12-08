# On most *nix systems this file is run only on login.
# But on MacOS this file is run for each new shell.

# Install user specific applications and settings on first run.
# Remove ~/.os-install-lock to re-run.

GITHUB_REPO="https://github.com/jzbruno/dotfiles"
GITHUB_BRANCH="charter"

DOTFILE_NAMES=(
    ".bashrc"
    ".inputrc"
    ".sshconfig"
    ".gitconfig"
    ".vimrc"
    "Brewfile"
    "Defaultsfile"
    "com.googlecode.iterm2.plist"
    "vscode-settings.json"
)

VSCODE_DIR="$HOME/Library/Application Support/Code/User"
VSCODE_EXTENSIONS=(
    "ms-vscode.go"
    "ms-python.python"
    "mauve.terraform"
    "marioterron.one-dark-bimbo"
    "rogalmic.bash-debug"
)

LOCK_FILE="$HOME/.os-install-lock"

if [[ ! -f "$LOCK_FILE" ]]; then
    mkdir -p "$HOME/tmp"

    echo "Downloading dotfiles ..."

    for name in "${DOTFILE_NAMES[@]}"; do
        url="$GITHUB_REPO/raw/$GITHUB_BRANCH/"
        file="$HOME/tmp/$name"

        status="$(curl -sSLw "%{http_code}" "$url" -o "$file")"

        if [[ "$status" -ne "200" ]]; then
            echo "Failed to download $url with status $status."
        fi
    done

    echo "Installing Homebrew ..."

    if ! type brew &> /dev/null; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo "Running Brewfile ..."

    brew bundle

    echo "Configuring system ..."

    if [[ -f "$HOME/Defaultsfile" ]]; then
        echo "Running Defaultsfile (requires sudo) ..."
        bash "$HOME/Defaultsfile"
    fi

    if [[ -f "$HOME/.sshconfig" ]]; then
        echo "Configuring SSH ..."
        mkdir "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
        cp "$HOME/.sshconfig" "$HOME/.ssh/config"
    fi

    if type code > /dev/null; then
        settingsFile="$HOME/vscode-settings.json"
        if [[ -f "$settingsFile" ]]; then
            cp "$settingsFile" "$VSCODE_DIR/settings.json"
        fi

        for name in "${VSCODE_EXTENSIONS[@]}"; do
            code --install-extension "$name" --force
        done
    fi

    echo "Setup Complete"

    touch "$LOCK_FILE"
fi

# MacOS now defauls to zsh and won't shut up about it.

export BASH_SILENCE_DEPRECATION_WARNING=1

# Run the bash customizations.

if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi
