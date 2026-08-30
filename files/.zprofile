# shellcheck disable=SC2139,SC2148,SC2155
# Mac
defaults write .GlobalPreferences com.apple.mouse.scaling -1
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.apple.Finder AppleShowAllFiles true
export CAPACITOR_ANDROID_STUDIO_PATH="$HOME/Applications/Android Studio.app"

## rbenv setup
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"

# Pyenv Setup
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Pipx / Poetry Setup
export PATH="$PATH:$HOME/.local/bin"

# Java
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH="$JAVA_HOME:$PATH"

alias j8="export JAVA_HOME=$(/usr/libexec/java_home -v 1.8); java -version"
alias j11="export JAVA_HOME=$(/usr/libexec/java_home -v 11); java -version"
alias j17="export JAVA_HOME=$(/usr/libexec/java_home -v 17); java -version"
alias j21="export JAVA_HOME=$(/usr/libexec/java_home -v 21); java -version"
alias j25="export JAVA_HOME=$(/usr/libexec/java_home -v 25); java -version"

export JAVA_HOME=$(/usr/libexec/java_home -v 25)

# NVM Setup
export NVM_SYMLINK_CURRENT=true
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

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

# Unity CLI
. "/Users/mrlonis/.unity/env"

# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/mrlonis/.docker/bin"
# End of Docker Desktop section.
