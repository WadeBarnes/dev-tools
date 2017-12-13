#!/bin/bash

SCRIPT_DIR=$(dirname $0)
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"
export MSYS_NO_PATHCONV=1

# =================================================================================================================
# Usage:
# - https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes
# -----------------------------------------------------------------------------------------------------------------
usage() {
  cat <<-EOF
  A script to remove docker containers and images.

  Usage: ${0} [ -hfcia ]

  OPTIONS:
  ========
    -h prints the usage for the script
    -f force the operation(S)
    -c remove containers
    -i remove images
    -a remove all images or containers

EOF
exit
}

# -----------------------------------------------------------------------------------------------------------------
# Initialization:
# -----------------------------------------------------------------------------------------------------------------
while getopts aicfh FLAG; do
  case $FLAG in
    a ) ALL=1 ;;
    i ) IMAGES=1 ;;
    c ) CONTAINERS=1 ;;
    f ) FORCE='-f' ;;
    h ) usage ;;
    \?) #unrecognized option - show help
      echo -e \\n"Invalid script option"\\n
      usage
      ;;
  esac
done

shift $((OPTIND-1))

if [ -z "${IMAGES}" ] && [ -z "${CONTAINERS}" ]; then
  usage
fi
# =================================================================================================================

if [ ! -z "${IMAGES}" ]; then
  if [ ! -z "${ALL}" ]; then
    # Remove all images
    _images=$(docker images -a -q)
    if [ ! -z "${_images}" ]; then
      echo -e "\nRemoving all images ...\n"
      docker rmi ${_images} ${FORCE}
    else
      echo -e "\nNo images to remove ...\n"    
    fi
  else
    # Remove dangling images
    _images=$(docker images -f dangling=true -q)
    if [ ! -z "${_images}" ]; then
      echo -e "\nRemoving dangling images ...\n"
      docker rmi ${_images} ${FORCE}
    else
      echo -e "\nNo dangling images to remove ...\n"    
    fi
  fi  
fi

if [ ! -z "${CONTAINERS}" ]; then
  if [ ! -z "${ALL}" ]; then
    # Stop and remove ALL containers
    _containers=$(docker ps -a -q)  
    if [ ! -z "${_containers}" ]; then    
      echo -e "\nStopping and removing all containers ...\n"
      echo -e "\nStopping all containers ...\n"
      docker stop ${_containers}
      echo -e "\nRemoving all containers ...\n"
      docker rm ${_containers} ${FORCE}
    else
      echo -e "\nNo containers to remove ...\n"    
    fi
  else
    # Remove all exited containers
    _containers=$(docker ps -a -f status=exited -q)  
    if [ ! -z "${_containers}" ]; then
    echo -e "\nRemoving all exited containers ...\n"
      docker rm ${_containers} ${FORCE}
    else
      echo -e "\nNo exited containers to remove ...\n"    
    fi  
  fi  
fi