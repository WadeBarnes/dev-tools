#!/bin/bash
SCRIPT_DIR=$(dirname $0)
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"
export MSYS_NO_PATHCONV=1

# =================================================================================================================
# Usage:
# -----------------------------------------------------------------------------------------------------------------
usage() {
  cat <<-EOF
  Opens a shell in a given container or image.

  Usage: ${0} [ -h ] [-c <containername> -i <imagename> -s <shell>] 

  OPTIONS:
  ========
    -h prints the usage for the script

    -c <containername>
      Open a shell in a running container.

    -i <imagename>
      Start an image and open a shell.
      The container will be automatically removed on exit.

    -s <shell>
      The shell to use; bash, sh, etc.  Defaults to bash
EOF
exit
}

# -----------------------------------------------------------------------------------------------------------------
# Initialization:
# -----------------------------------------------------------------------------------------------------------------
while getopts c:i:s:h FLAG; do
  case $FLAG in
    c ) CONTAINER=$OPTARG ;;
    i ) IMAGE=$OPTARG ;;
    s ) SHELL_CMD=$OPTARG ;;
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

if [ -z "${SHELL_CMD}" ]; then
  SHELL_CMD='bash'
fi
# =================================================================================================================

if [ ! -z "${CONTAINER}" ]; then
  echo -e "\nOpening a '${SHELL_CMD}' shell to ${CONTAINER} ...\n"
  winpty docker exec -it ${CONTAINER} ${SHELL_CMD}
fi

if [ ! -z "${IMAGE}" ]; then
  echo -e "\nOpening a '${SHELL_CMD}' shell to ${IMAGE} ...\n"
  # Override the entrypoint otherwise we could just be trying to issue a command via the container's entrypoint.
  winpty docker run --rm -it --name $(echo ${IMAGE} | sed 's~\(^.*\):.*$~\1~;s~\(/\|\\\)~\.~g;') --entrypoint ${SHELL_CMD} ${IMAGE} 
fi