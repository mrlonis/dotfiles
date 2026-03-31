#!/bin/bash
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
	export TMPDIR="/tmp"
	export TMP="/tmp"
	export TEMP="/tmp"
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/mrlonis/.sdkman"
[[ -s "/Users/mrlonis/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/mrlonis/.sdkman/bin/sdkman-init.sh"
