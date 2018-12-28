#!/bin/bash

OCTOOLSBIN=$(dirname $0)

# =================================================================================================================
# Usage:
# -----------------------------------------------------------------------------------------------------------------
usage() {
  cat <<-EOF
  Tests to see if a port is open.

  Usage: $0 [ options ] [host:port]

  Examples:
    $0 google.com:80

    $0 -f ./listOfUrisToTest.txt

  OPTIONS:
  ========
    -f read the connection list from a file
    -h prints the usage for the script
EOF
exit 1
}
# =================================================================================================================

# =================================================================================================================
# Funtions:
# -----------------------------------------------------------------------------------------------------------------
readList(){
  (
    if [ -f ${listFile} ]; then
      # Read in the file minus any comments ...
      echo "Reading list from ${listFile} ..." >&2
      _value=$(sed '/^[[:blank:]]*#/d;s/#.*//' ${listFile})
    fi
    echo "${_value}"
  )
}
# =================================================================================================================

# =================================================================================================================
# Initialization:
# -----------------------------------------------------------------------------------------------------------------
# In case you wanted to check what variables were passed
# echo "flags = $*"
while getopts f:h FLAG; do
  case $FLAG in
    f) export listFile=$OPTARG ;;
    h ) usage ;;
    \?) #unrecognized option - show help
      echo -e \\n"Invalid script option"\\n
      usage
      ;;
  esac
done

shift $((OPTIND-1))

if [ ! -z "${listFile}" ]; then
  list=$(readList)
else
  list=${@}
fi

if [ -z "${list}" ]; then
  echo -e \\n"Missing parameters."\\n
  usage
fi
# =================================================================================================================

# =================================================================================================================
# Main Script
# Inspired by; https://stackoverflow.com/questions/4922943/test-from-shell-script-if-remote-tcp-port-is-open/9463554
# -----------------------------------------------------------------------------------------------------------------
for item in ${list}; do
  IFS=':' read -r -a segments <<< "${item}"  && unset IFS
  host=${segments[0]}
  port=${segments[1]}

  echo -n "${host}:${port}"
  timeout 1 bash -c "cat < /dev/null > /dev/tcp/${host}/${port}" && echo " - Open" || echo " - Closed"
done
# =================================================================================================================