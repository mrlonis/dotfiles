#!/bin/bash
# shellcheck disable=SC1090,SC2015,SC2034,SC2155,SC2139,SC2148
# Format this file by running: shfmt -l -w -p .bashrc

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

	# Brew Setup
	if [ "$machine" = "Linux" ]; then
		export BREW_HOME="/home/linuxbrew/.linuxbrew/bin"
		export PATH="$PATH:$BREW_HOME"
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	fi
fi

export PROJECT_HOME="$HOME/Documents/GitHub"

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

if [ "$current_directory" = "$HOME" ]; then
	if [ "$machine" = "Linux" ]; then
		sysupdate
	else
		brewupdate
	fi
	pipxupdate
fi

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

# Java
if [ "$machine" = "Linux" ]; then
	export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
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

# https://github.com/nvm-sh/nvm#bash
cdnvm() {
	command cd "$@" || return $?
	nvm_path=$(nvm_find_up .nvmrc | tr -d '\n')

	# If there are no .nvmrc file, use the default nvm version
	if [[ ! $nvm_path = *[^[:space:]]* ]]; then

		declare default_version
		default_version=$(nvm version default)

		# If there is no default version, set it to `node`
		# This will use the latest version on your machine
		if [[ $default_version == "N/A" ]]; then
			nvm alias default node
			default_version=$(nvm version default)
		fi

		# If the current version is not the default version, set it to use the default version
		if [[ $(nvm current) != "$default_version" ]]; then
			nvm use default
		fi

	elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
		declare nvm_version
		nvm_version=$(<"$nvm_path"/.nvmrc)

		declare locally_resolved_nvm_version
		# `nvm ls` will check all locally-available versions
		# If there are multiple matching versions, take the latest one
		# Remove the `->` and `*` characters and spaces
		# `locally_resolved_nvm_version` will be `N/A` if no local versions are found
		locally_resolved_nvm_version=$(nvm ls --no-colors "$nvm_version" | tail -1 | tr -d '\->*' | tr -d '[:space:]')

		# If it is not already installed, install it
		# `nvm install` will implicitly use the newly-installed version
		if [[ "$locally_resolved_nvm_version" == "N/A" ]]; then
			nvm install "$nvm_version"
		elif [[ $(nvm current) != "$locally_resolved_nvm_version" ]]; then
			nvm use "$nvm_version"
		fi
	fi
}

alias cd='cdnvm'
cdnvm "$PWD" || exit

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
