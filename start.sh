#!/bin/sh
# Modified from the jupyter base-notebook start.sh script
# https://github.com/jupyter/docker-stacks/blob/master/base-notebook/start.sh

set -e

# If root user
if [ $(id -u) == 0 ] ; then
  # Only the username "datalab" was created in docker build, 
  # therefore rename "datalab" to $MINIO_USER
  usermod -d /home/$MINIO_USER -l $MINIO_USER datalab

   # Change UID of MINIO_USER to MINIO_UID if it does not match.
  if [ "$MINIO_UID" != $(id -u $MINIO_USER) ] ; then
    echo "Set user UID to: $MINIO_UID"
    usermod -u $MINIO_UID $MINIO_USER
  fi

  # Change GID of MINIO_USER to MINIO_GID, if given.
  if [ "$MINIO_GID" ] ; then
    echo "Change GID to $MINIO_GID"
    groupmod -g $MINIO_GID -o $(id -g -n $MINIO_USER)
  fi

  # Exec minio docker-entrypoint as $MINIO_USER
  echo "Execute the command as $MINIO_USER"
  exec su-exec $MINIO_USER /usr/bin/docker-entrypoint.sh $*
else
  if [[ ! -z "$MINIO_UID" && "$MINIO_UID" != "$(id -u)" ]]; then
    echo 'Container must be run as root to set $MINIO_UID'
  fi
  if [[ ! -z "$MINIO_GID" && "$MINIO_GID" != "$(id -g)" ]]; then
    echo 'Container must be run as root to set $MINIO_GID'
  fi

  echo "Execute the command"
  exec /usr/bin/docker-entrypoint.sh $*
fi
