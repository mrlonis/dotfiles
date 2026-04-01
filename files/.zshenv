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

if [ "$machine" = "Linux" ]; then
	export TMPDIR="/tmp"
	export TMP="/tmp"
	export TEMP="/tmp"
fi
