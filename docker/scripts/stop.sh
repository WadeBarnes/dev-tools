#!/bin/bash

SCRIPT_DIR=$(dirname $0)
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"
export MSYS_NO_PATHCONV=1

# =================================================================================================================
# Usage:
# -----------------------------------------------------------------------------------------------------------------
usage() {
  cat <<-EOF
  Stops and removes a given docker container.

  Usage: ${0} [ -h ] -n <containername>

  OPTIONS:
  ========
    -h prints the usage for the script
    -n the name of the container

EOF
exit
}

# -----------------------------------------------------------------------------------------------------------------
# Initialization:
# -----------------------------------------------------------------------------------------------------------------
while getopts n:h FLAG; do
  case $FLAG in
    n ) CONTAINER=$OPTARG ;;
    h ) usage ;;
    \?) #unrecognized option - show help
      echo -e \\n"Invalid script option"\\n
      usage
      ;;
  esac
done

shift $((OPTIND-1))

if [ -z "${CONTAINER}" ]; then
  usage
fi
# =================================================================================================================

echo -e "\nStopping ${CONTAINER} ...\n"
docker stop ${CONTAINER}
echo -e "\nRemoving ${CONTAINER} ...\n"
docker rm ${CONTAINER}