#!/bin/bash

SCRIPT_DIR=$(dirname $0)
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"
export MSYS_NO_PATHCONV=1

# =================================================================================================================
# Usage:
# -----------------------------------------------------------------------------------------------------------------
usage() {
  cat <<-EOF
  Runs a given docker image.

  Usage: ${0} [ -h -p] -n <imagename>

  OPTIONS:
  ========
    -h prints the usage for the script
    -p Give extended privileges to this container
    -n the name of the image

EOF
exit
}

# -----------------------------------------------------------------------------------------------------------------
# Initialization:
# -----------------------------------------------------------------------------------------------------------------
while getopts n:ph FLAG; do
  case $FLAG in
    n ) IMAGE=$OPTARG ;;
    p) PRIVILEGED=--privileged;;
    h ) usage ;;
    \?) #unrecognized option - show help
      echo -e \\n"Invalid script option"\\n
      usage
      ;;
  esac
done

shift $((OPTIND-1))

if [ -z "${IMAGE}" ]; then
  usage
fi
# =================================================================================================================

echo -e "\nStarting ${IMAGE} ...\n"
docker run ${PRIVILEGED} -d ${IMAGE} --name ${IMAGE}