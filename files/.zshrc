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
# zstyle ':omz:update' mode auto      # update automatically without asking
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
plugins=(
	brew
	git
	nvm
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

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

# Control Logging
LOG=1

# zsh settings
export HISTFILE="$HOME/.zsh_history"

# Determine OS
unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) machine="Linux" ;;
Darwin*) machine="Mac" ;;
CYGWIN*) machine="Cygwin" ;;
MINGW*) machine="MinGw" ;;
*) machine="UNKNOWN:${unameOut}" ;;
esac
if [ $LOG == 1 ]; then
	echo "Machine: ${machine}"
fi

# WSL Ubuntu Brew Python
# Potential to use brew env vars
# HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
# HOMEBREW_CELLAR=/home/linuxbrew/.linuxbrew/Cellar
# HOMEBREW_REPOSITORY=/home/linuxbrew/.linuxbrew/Homebrew
if [ $machine == "Linux"]; then
	PYTHON37="/home/linuxbrew/.linuxbrew/Cellar/python@3.7/3.7.16/bin/python3.7"
	PYTHON38="/home/linuxbrew/.linuxbrew/Cellar/python@3.8/3.8.16/bin/python3.8"
	PYTHON39="/home/linuxbrew/.linuxbrew/Cellar/python@3.9/3.9.16/bin/python3.9"
	PYTHON310="/home/linuxbrew/.linuxbrew/Cellar/python@3.10/3.10.9/bin/python3.10"
elif [ $machine == "Mac"]; then
	PYTHON37="/usr/local/Cellar/python@3.7/3.7.16/bin/python3.7"
	PYTHON38="/usr/local/Cellar/python@3.8/3.8.16/bin/python3.8"
	PYTHON39="/usr/local/Cellar/python@3.9/3.9.16/bin/python3.9"
	PYTHON310="/usr/local/Cellar/python@3.10/3.10.9/bin/python3.10"
else
	echo "Unknown machine type. Cannot determine python paths"
fi

# utility-repo-scripts env variables
# export PYTHON=$PYTHON37 # Used to override Python version for virtual environments
export VENV_FOLDER_NAME=".venvs"

# virtualenvwrapper Setup
export VIRTUALENVWRAPPER_PYTHON="$PYTHON310"
export WORKON_HOME="$HOME/$VENV_FOLDER_NAME"
export PROJECT_HOME="$HOME/Documents/GitHub"

if [ "$machine" == "Mac"]; then
	source /usr/local/bin/virtualenvwrapper.sh
elif [ "$machine" == "Linux"]; then
	source /home/linuxbrew/.linuxbrew/bin/virtualenvwrapper.sh
else
	echo "Unknown machine type. Cannot determine virtualenvwrapper.sh location"
fi

# aliases
if [ $LOG == 1 ]; then
	echo "Creating alias laws"
fi
alias laws='aws --endpoint-url=http://localhost:4566'

if [ $LOG == 1 ]; then
	echo "Creating alias mrlonis"
fi
export MRLONIS_HOME="$PROJECT_HOME/mrlonis"
alias mrlonis="cd $MRLONIS_HOME"

if [ $LOG == 1 ]; then
	echo "Creating alias salessync"
fi
export SALESSYNC_HOME="$PROJECT_HOME/salessync"
alias salessync="cd $SALESSYNC_HOME"

# NVM Setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
