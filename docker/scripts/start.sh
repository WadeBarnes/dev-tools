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

  Usage: ${0} [ -h ] -n <imagename>

  OPTIONS:
  ========
    -h prints the usage for the script
    -n the name of the image

EOF
exit
}

# -----------------------------------------------------------------------------------------------------------------
# Initialization:
# -----------------------------------------------------------------------------------------------------------------
while getopts n:h FLAG; do
  case $FLAG in
    n ) IMAGE=$OPTARG ;;
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
docker run -d ${IMAGE} --name ${IMAGE}