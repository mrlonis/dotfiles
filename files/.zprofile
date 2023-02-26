# shellcheck disable=SC2148
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
	# Had to add this since brew command was not found after a restart
	# I suspect pyenv has something to do with this but I am unsure
	export BREW_HOME="/home/linuxbrew/.linuxbrew/bin"
	export PATH="$PATH:$BREW_HOME"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# pyenv Setup
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
