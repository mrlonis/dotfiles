# shellcheck disable=SC2034,SC2155,SC2148,SC1090,SC2139
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
# if [ "$machine" = "Linux" ]; then
# 	export BREW_HOME="/home/linuxbrew/.linuxbrew/bin"
# 	export PATH="$PATH:$BREW_HOME"
# 	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# fi

plugins=(
	poetry
	git
	nvm
	dotenv
	zsh-autosuggestions
)

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

export PROJECT_HOME="$HOME/GitHub"

# aliases
current_directory="$PWD"
if [ $LOG = 1 ]; then
	echo "Creating alias laws"
fi
alias laws='aws --endpoint-url=http://localhost:4566'

if [ $LOG = 1 ]; then
	echo "Creating alias mrlonis"
fi
export MRLONIS_HOME="$PROJECT_HOME/mrlonis"
alias mrlonis='cd $MRLONIS_HOME'

if [ "$machine" = "Linux" ]; then
	if [ $LOG = 1 ]; then
		echo "Creating alias sysupdate"
	fi
	alias sysupdate='sudo apt update && sudo apt -y upgrade && sudo apt -y dist-upgrade && sudo apt -y autoremove'
fi

if [ $LOG = 1 ]; then
	echo "Creating alias brewupdate"
fi
alias brewupdate='brew update && brew upgrade && brew cleanup'

if [ $LOG = 1 ]; then
	echo "Creating alias pipxupdate"
fi
alias pipxupdate='pipx upgrade-all'

if [ $LOG = 1 ]; then
	echo "Creating alias update"
fi
if [ "$machine" = "Linux" ]; then
	alias update='sysupdate && pipxupdate'
else
	alias update='pipxupdate && brewupdate'
fi

# Mac
if [ "$machine" = "Mac" ]; then
	defaults write .GlobalPreferences com.apple.mouse.scaling -1
	defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
	defaults write com.apple.Finder AppleShowAllFiles true
fi

# Ruby Setup
export PATH="/usr/local/opt/ruby/bin:$PATH"

## rbenv setup
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
if [ "$machine" = "Mac" ]; then
	export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"
fi

# Pyenv Setup
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"

# Poetry Setup
if [ "$machine" = "Linux" ] || [ "$machine" = "Mac" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

# Java
if [ "$machine" = "Linux" ]; then
	export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
	export PATH="$JAVA_HOME:$PATH"
elif [ "$machine" = "Mac" ]; then
	export JAVA_HOME=$(/usr/libexec/java_home)
	export PATH="$JAVA_HOME:$PATH"

	###############
	# Java Switcher
	###############
	alias j8="export JAVA_HOME=$(/usr/libexec/java_home -v 1.8); java -version"
	alias j11="export JAVA_HOME=$(/usr/libexec/java_home -v 11); java -version"
	alias j17="export JAVA_HOME=$(/usr/libexec/java_home -v 17); java -version"
	alias j21="export JAVA_HOME=$(/usr/libexec/java_home -v 21); java -version"

	# Set java 8 as default
	export JAVA_HOME=$(/usr/libexec/java_home -v 17)
fi

# Maven Setup
export M2_HOME='/opt/apache-maven-3.9.6'
export PATH="$M2_HOME/bin:$PATH"

# NVM Setup
export NVM_SYMLINK_CURRENT=true
if [ "$machine" = "Linux" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
elif [ "$machine" = "Mac" ]; then
	export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
fi

# https://github.com/nvm-sh/nvm#zsh
autoload -U add-zsh-hook

load-nvmrc() {
	local nvmrc_path
	nvmrc_path="$(nvm_find_nvmrc)"

	if [ -n "$nvmrc_path" ]; then
		local nvmrc_node_version
		nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

		if [ "$nvmrc_node_version" = "N/A" ]; then
			nvm install
		elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
			nvm use
		fi
	elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
		echo "Reverting to nvm default version"
		nvm use default
	fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Load Angular CLI autocompletion.
if command -v ng &>/dev/null; then
	source <(ng completion script)
else
	if command -v npm &>/dev/null; then
		npm i -g @angular/cli
		source <(ng completion script)
	else
		echo "npm not installed. Cannot install Angular CLI"
	fi
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
