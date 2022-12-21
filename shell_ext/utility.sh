# All handy functions and env to source from

export RED='\033[1;31m'
export BLUE='\033[1;34m'
export GREEN='\033[1;32m'
export YELLOW='\033[0;33m'
export NOCOLOR='\033[0m'

#USAGE: say $COLOR "Text to say"
function say () {
    printf "$1$2 ${NOCOLOR}\n"
}

# doc: Exit the script with error message, you can pass `exit_code` as a 2nd arg
#> fail "unrecoverable error"
#> fail "stops with exit_code 5" 5
fail() {
    say $REay "$1" >&2
    exit ${2:-1}
}

assert_cd() {
	expected_dir=$1
	echo "$(pwd)" | grep "${expected_dir}" > /dev/null
	ret=$?
	if [[ $ret != 0 ]]; then
		printf "Not in ${expected_dir}\ncd ${expected_dir}\n"
		fail "Starting from the wrong directory" 17
	fi
}
