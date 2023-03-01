# shellcheck disable=SC2034,SC2155,SC2148
# Control Logging
LOG=1

# Determine OS
unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) machine=Linux ;;
Darwin*) machine=Mac ;;
CYGWIN*) machine=Cygwin ;;
MINGW*) machine=MinGw ;;
*) machine="UNKNOWN:${unameOut}" ;;
esac

if [ "$LOG" = 1 ]; then
	echo "Machine: ${machine}"
fi

# Format this file by running: shfmt -l -w -p .zshrc
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# Brew Setup
if [ "$machine" = "Linux" ]; then
	# Had to add this since brew command was not found after a restart
	# I suspect pyenv has something to do with this but I am unsure
	export BREW_HOME="/home/linuxbrew/.linuxbrew/bin"
	export PATH="$PATH:$BREW_HOME"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

env_zsh_exists=0
if [ ! -d "${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}/plugins/env" ]; then
	echo "Cloning env-zsh plugin..."
	git clone https://github.com/johnhamelink/env-zsh.git "${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}/plugins/env"
else
	echo "env-zsh plugin already exists!"
	env_zsh_exists=1
fi

plugins=(
	poetry
	git
	nvm
	zsh-autosuggestions
)

pyenv_installed=0
if command -v pyenv >/dev/null; then
	pyenv_installed=1
else
	echo "pyenv not installed! Enabling virtualenvwrapper ohmyzsh plugin..."
	plugins+=(virtualenvwrapper)
fi

if [ "$env_zsh_exists" = 1 ]; then
	echo "Enabling env-zsh plugin..."
	plugins+=(env)
fi

source "$ZSH/oh-my-zsh.sh"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# zsh settings
export HISTFILE="$HOME/.zsh_history"
export HISTFILESIZE=1000000
export HISTSIZE=1000000
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS # Doesn't show duplicate commands using the UP and DOWN arrow keys
# setopt HIST_IGNORE_ALL_DUPS # Doesn't write duplicate commands to history

# WSL Ubuntu Brew Python
# Potential to use brew env vars
# HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
# HOMEBREW_CELLAR=/home/linuxbrew/.linuxbrew/Cellar
# HOMEBREW_REPOSITORY=/home/linuxbrew/.linuxbrew/Homebrew
#
# Only HOMEBREW_PREFIX seems to exist on Mac
if [ "$machine" = "Linux" ]; then
	PYTHON37="/home/linuxbrew/.linuxbrew/Cellar/python@3.7/3.7.16/bin/python3.7"
	PYTHON38="/home/linuxbrew/.linuxbrew/Cellar/python@3.8/3.8.16/bin/python3.8"
	PYTHON39="/home/linuxbrew/.linuxbrew/Cellar/python@3.9/3.9.16/bin/python3.9"
	PYTHON310="/home/linuxbrew/.linuxbrew/Cellar/python@3.10/3.10.10_1/bin/python3.10"
	PYTHON311="/home/linuxbrew/.linuxbrew/Cellar/python@3.11/3.11.2_1/bin/python3.11"
elif [ "$machine" = "Mac" ]; then
	PYTHON37="/usr/local/Cellar/python@3.7/3.7.16/bin/python3.7"
	PYTHON38="/usr/local/Cellar/python@3.8/3.8.16/bin/python3.8"
	PYTHON39="/usr/local/Cellar/python@3.9/3.9.16/bin/python3.9"
	PYTHON310="/usr/local/Cellar/python@3.10/3.10.10_1/bin/python3.10"
	PYTHON311="/usr/local/Cellar/python@3.11/3.11.2_1/bin/python3.11"
else
	echo "Unknown machine type. Cannot determine python paths"
fi

# virtualenvwrapper Setup
export PROJECT_HOME="$HOME/Documents/GitHub"
if [ "$pyenv_installed" = 0 ]; then
	echo "pyenv not installed! Activating virtualenvwrapper..."
	export VIRTUALENVWRAPPER_PYTHON="$PYTHON310"
	export WORKON_HOME="$HOME/$VENV_FOLDER_NAME"
	export VIRTUALENVWRAPPER_HOOK_DIR="$WORKON_HOME"
	if [ "$machine" = "Mac" ]; then
		source /usr/local/bin/virtualenvwrapper.sh
	elif [ "$machine" = "Linux" ]; then
		source /home/linuxbrew/.linuxbrew/bin/virtualenvwrapper.sh
	else
		echo "Unknown machine type. Cannot determine virtualenvwrapper.sh location"
	fi
fi

# aliases
if [ $LOG = 1 ]; then
	echo "Creating alias laws"
fi
alias laws='aws --endpoint-url=http://localhost:4566'

if [ $LOG = 1 ]; then
	echo "Creating alias mrlonis"
fi
export MRLONIS_HOME="$PROJECT_HOME/mrlonis"
alias mrlonis='cd $MRLONIS_HOME'

if [ $LOG = 1 ]; then
	echo "Creating alias salessync"
fi
export SALESSYNC_HOME="$PROJECT_HOME/salessync"
alias salessync='cd $SALESSYNC_HOME'

# Mac
if [ "$machine" = "Mac" ]; then
	defaults write .GlobalPreferences com.apple.mouse.scaling -1
	defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
	defaults write com.apple.Finder AppleShowAllFiles true
fi

# aws
export AWS_ACCESS_KEY_ID=AKIA2C4LUUR7GQMFQ2GH
export AWS_SECRET_ACCESS_KEY=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

# Ruby Setup
export PATH="/usr/local/opt/ruby/bin:$PATH"

## rbenv setup
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"

# Poetry Setup
if [ "$machine" = "Linux" ] || [ "$machine" = "Mac" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

# Pyenv Setup
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

if [ "$machine" = "Linux" ]; then
	export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/openssl@3/lib"
	export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/openssl@3/include"
	export PKG_CONFIG_PATH="/home/linuxbrew/.linuxbrew/opt/openssl@3/lib/pkgconfig"
fi

# NVM Setup
if [ "$machine" = "Linux" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
elif [ "$machine" = "Mac" ]; then
	export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
fi
