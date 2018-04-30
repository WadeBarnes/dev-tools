#!/bin/bash

SCRIPT_DIR=$(dirname $0)
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"
export MSYS_NO_PATHCONV=1

# =================================================================================================================
# Usage:
# -----------------------------------------------------------------------------------------------------------------
usage() {
  cat <<-EOF
  Opens a bash shell in a given container or image.

  Usage: ${0} [ -h ] [-c <containername> -i <imagename>] 

  OPTIONS:
  ========
    -h prints the usage for the script

    -c <containername>
      Open a bash shell in a running container.

    -i <imagename>
      Start an image and open a bash shell.
      The container will be automatically removed on exit.
EOF
exit
}

# -----------------------------------------------------------------------------------------------------------------
# Initialization:
# -----------------------------------------------------------------------------------------------------------------
while getopts c:i:h FLAG; do
  case $FLAG in
    c ) CONTAINER=$OPTARG ;;
    i ) IMAGE=$OPTARG ;;
    h ) usage ;;
    \?) #unrecognized option - show help
      echo -e \\n"Invalid script option"\\n
      usage
      ;;
  esac
done

shift $((OPTIND-1))

if [ -z "${CONTAINER}" ] && [ -z "${IMAGE}" ]; then
  usage
fi
# =================================================================================================================

if [ ! -z "${CONTAINER}" ]; then
  echo -e "\nOpening a bash shell to ${CONTAINER} ...\n"
  winpty docker exec -it ${CONTAINER} bash
fi

if [ ! -z "${IMAGE}" ]; then
  echo -e "\nOpening a bash shell to ${IMAGE} ...\n"
  winpty docker run --rm -it --name ${IMAGE} ${IMAGE} bash
fi