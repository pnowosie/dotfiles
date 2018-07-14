RED='\033[1;31m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NOCOLOR='\033[0m'

#USAGE: say $COLOR "Text to say"
function say () {
  printf "$1$2 ${NOCOLOR}\n"
}

#USAGE: runtest mix compile
function runtest {
  "$@"
  local status=$?
  if [ $status -ne 0 ]; then
    say $RED "Command \'$2\' has failed!"
  else
    say $BLUE "Command \'$2\' succeed!"
  fi
  return $status
}

# Fo(rmat) Co(mpile)
function foco () {
  runtest mix format && \
  runtest mix compile
}

# Fo(rmat) Co(mpile) (Cre)do
function focodo () {
  foco && \
  runtest mix credo
}
