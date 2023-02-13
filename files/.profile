# shellcheck disable=SC2034,SC2148,SC2155
# Format this file by running: shfmt -l -w -p .profile

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

if [ "$machine" = "Linux" ]; then
	# ~/.profile: executed by the command interpreter for login shells.
	# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
	# exists.
	# see /usr/share/doc/bash/examples/startup-files for examples.
	# the files are located in the bash-doc package.

	# the default umask is set in /etc/profile; for setting the umask
	# for ssh logins, install and configure the libpam-umask package.
	#umask 022

	# if running bash
	if [ -n "$BASH_VERSION" ]; then
		# include .bashrc if it exists
		if [ -f "$HOME/.bashrc" ]; then
			. "$HOME/.bashrc"
		fi
	fi

	# set PATH so it includes user's private bin if it exists
	if [ -d "$HOME/bin" ]; then
		PATH="$HOME/bin:$PATH"
	fi

	# set PATH so it includes user's private bin if it exists
	if [ -d "$HOME/.local/bin" ]; then
		PATH="$HOME/.local/bin:$PATH"
	fi
else
	# Control Logging
	LOG=1

	# zsh settings
	export HISTFILE="$HOME/.zsh_history"
	export HISTFILESIZE=1000000
	export HISTSIZE=1000000
	setopt INC_APPEND_HISTORY
	export HISTTIMEFORMAT="[%F %T] "
	setopt EXTENDED_HISTORY
	setopt HIST_FIND_NO_DUPS # Doesn't show duplicate commands using the UP and DOWN arrow keys
	# setopt HIST_IGNORE_ALL_DUPS # Doesn't write duplicate commands to history

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
		PYTHON310="/home/linuxbrew/.linuxbrew/Cellar/python@3.10/3.10.10/bin/python3.10"
	elif [ "$machine" = "Mac" ]; then
		PYTHON37="/usr/local/Cellar/python@3.7/3.7.16/bin/python3.7"
		PYTHON38="/usr/local/Cellar/python@3.8/3.8.16/bin/python3.8"
		PYTHON39="/usr/local/Cellar/python@3.9/3.9.16/bin/python3.9"
		PYTHON310="/usr/local/Cellar/python@3.10/3.10.10/bin/python3.10"
	else
		echo "Unknown machine type. Cannot determine python paths"
	fi

	# utility-repo-scripts env variables
	# export PYTHON=$PYTHON37 # Used to override Python version for virtual environments
	unset PYTHON
	export VENV_FOLDER_NAME=".venvs"

	# virtualenvwrapper Setup
	export VIRTUALENVWRAPPER_PYTHON="$PYTHON310"
	export WORKON_HOME="$HOME/$VENV_FOLDER_NAME"
	export VIRTUALENVWRAPPER_HOOK_DIR="$WORKON_HOME"
	export PROJECT_HOME="$HOME/Documents/GitHub"
	if [ "$machine" = "Mac" ]; then
		source /usr/local/bin/virtualenvwrapper.sh
	elif [ "$machine" = "Linux" ]; then
		source /home/linuxbrew/.linuxbrew/bin/virtualenvwrapper.sh
	else
		echo "Unknown machine type. Cannot determine virtualenvwrapper.sh location"
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

	# NVM Setup
	if [ "$machine" = "Linux" ]; then
		export NVM_DIR="$HOME/.nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
		[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
	elif [ "$machine" = "Mac" ]; then
		export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
	fi
fi
