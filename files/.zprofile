# shellcheck disable=SC2148,SC2155
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

# Brew Setup
if [ "$machine" = "Linux" ]; then
	export BREW_HOME="/home/linuxbrew/.linuxbrew/bin"
	export PATH="$PATH:$BREW_HOME"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
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
# if [ "$machine" = "Linux" ] || [ "$machine" = "Mac" ]; then
# 	export PATH="$HOME/.local/bin:$PATH"
# fi

# Pyenv Setup
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# if [ "$machine" = "Linux" ]; then
# 	export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/openssl@3/lib"
# 	export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/openssl@3/include"
# 	export PKG_CONFIG_PATH="/home/linuxbrew/.linuxbrew/opt/openssl@3/lib/pkgconfig"
# fi

# Java
if [ "$machine" = "Linux" ]; then
	export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
	export PATH="$JAVA_HOME:$PATH"
fi

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
