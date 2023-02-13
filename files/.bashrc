#!/bin/bash
# shellcheck disable=SC1090,SC2015,SC2034,SC2155
# Format this file by running: shfmt -l -w -p .bashrc

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
	# ~/.bashrc: executed by bash(1) for non-login shells.
	# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
	# for examples

	# If not running interactively, don't do anything
	case $- in
	*i*) ;;
	*) return ;;
	esac

	# don't put duplicate lines or lines starting with space in the history.
	# See bash(1) for more options
	HISTCONTROL=ignoreboth

	# append to the history file, don't overwrite it
	shopt -s histappend

	# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
	HISTSIZE=1000
	HISTFILESIZE=2000

	# check the window size after each command and, if necessary,
	# update the values of LINES and COLUMNS.
	shopt -s checkwinsize

	# If set, the pattern "**" used in a pathname expansion context will
	# match all files and zero or more directories and subdirectories.
	#shopt -s globstar

	# make less more friendly for non-text input files, see lesspipe(1)
	[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

	# set variable identifying the chroot you work in (used in the prompt below)
	if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
		debian_chroot=$(cat /etc/debian_chroot)
	fi

	# set a fancy prompt (non-color, unless we know we "want" color)
	case "$TERM" in
	xterm-color | *-256color) color_prompt=yes ;;
	esac

	# uncomment for a colored prompt, if the terminal has the capability; turned
	# off by default to not distract the user: the focus in a terminal window
	# should be on the output of commands, not on the prompt
	#force_color_prompt=yes

	if [ -n "$force_color_prompt" ]; then
		if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
			# We have color support; assume it's compliant with Ecma-48
			# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
			# a case would tend to support setf rather than setaf.)
			color_prompt=yes
		else
			color_prompt=
		fi
	fi

	if [ "$color_prompt" = yes ]; then
		PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	else
		PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
	fi
	unset color_prompt force_color_prompt

	# If this is an xterm set the title to user@host:dir
	case "$TERM" in
	xterm* | rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*) ;;

	esac

	# enable color support of ls and also add handy aliases
	if [ -x /usr/bin/dircolors ]; then
		test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
		alias ls='ls --color=auto'
		#alias dir='dir --color=auto'
		#alias vdir='vdir --color=auto'

		alias grep='grep --color=auto'
		alias fgrep='fgrep --color=auto'
		alias egrep='egrep --color=auto'
	fi

	# colored GCC warnings and errors
	#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

	# some more ls aliases
	alias ll='ls -alF'
	alias la='ls -A'
	alias l='ls -CF'

	# Add an "alert" alias for long running commands.  Use like so:
	#   sleep 10; alert
	alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

	# Alias definitions.
	# You may want to put all your additions into a separate file like
	# ~/.bash_aliases, instead of adding them here directly.
	# See /usr/share/doc/bash-doc/examples in the bash-doc package.

	if [ -f ~/.bash_aliases ]; then
		. ~/.bash_aliases
	fi

	# enable programmable completion features (you don't need to enable
	# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
	# sources /etc/bash.bashrc).
	if ! shopt -oq posix; then
		if [ -f /usr/share/bash-completion/bash_completion ]; then
			. /usr/share/bash-completion/bash_completion
		elif [ -f /etc/bash_completion ]; then
			. /etc/bash_completion
		fi
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
