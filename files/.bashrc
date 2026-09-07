# shellcheck disable=SC2086,SC2139,SC2148,SC2155
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

cdnvm() {
	command cd "$@" || return $?
	nvm_path="$(nvm_find_up .nvmrc | command tr -d '\n')"

	# If there are no .nvmrc file, use the default nvm version
	if [[ ! $nvm_path = *[^[:space:]]* ]]; then

		declare default_version
		default_version="$(nvm version default)"

		# If there is no default version, set it to `node`
		# This will use the latest version on your machine
		if [ $default_version = 'N/A' ]; then
			nvm alias default node
			default_version=$(nvm version default)
		fi

		# If the current version is not the default version, set it to use the default version
		if [ "$(nvm current)" != "${default_version}" ]; then
			nvm use default
		fi
	elif [[ -s "${nvm_path}/.nvmrc" && -r "${nvm_path}/.nvmrc" ]]; then
		declare nvm_version
		nvm_version=$(<"${nvm_path}"/.nvmrc)

		declare locally_resolved_nvm_version
		# `nvm ls` will check all locally-available versions
		# If there are multiple matching versions, take the latest one
		# Remove the `->` and `*` characters and spaces
		# `locally_resolved_nvm_version` will be `N/A` if no local versions are found
		locally_resolved_nvm_version=$(nvm ls --no-colors "${nvm_version}" | command tail -1 | command tr -d '\->*' | command tr -d '[:space:]')

		# If it is not already installed, install it
		# `nvm install` will implicitly use the newly-installed version
		if [ "${locally_resolved_nvm_version}" = 'N/A' ]; then
			nvm install "${nvm_version}"
		elif [ "$(nvm current)" != "${locally_resolved_nvm_version}" ]; then
			nvm use "${nvm_version}"
		fi
	fi
}

alias cd='cdnvm'
cdnvm "$PWD" || exit

export OLLAMA_LOAD_TIMEOUT=30m
