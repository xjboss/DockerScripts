#! /bin/bash -e
# Original config create by jenkins
# if `docker run` first argument start with `--` the user is passing jenkins launcher arguments
cd $BOT_HOME
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then

  # read JAVA_OPTS and BOT_OPTS into arrays to avoid need for eval (and associated vulnerabilities)
  java_opts_array=()
  while IFS= read -r -d '' item; do
    java_opts_array+=( "$item" )
  done < <([[ $JAVA_OPTS ]] && xargs printf '%s\0' <<<"$JAVA_OPTS")

  if [[ "$DEBUG" ]] ; then
    java_opts_array+=( \
      '-Xdebug' \
      '-Xrunjdwp:server=y,transport=dt_socket,address=5005,suspend=y' \
    )
  fi

  bot_opts_array=( )
  while IFS= read -r -d '' item; do
    bot_opts_array+=( "$item" )
  done < <([[ $BOT_OPTS ]] && xargs printf '%s\0' <<<"$BOT_OPTS")
  cd 
  exec java -Duser.home="$BOT_HOME" "${java_opts_array[@]}" -jar ${JMUSICBOT_APP} "${bot_opts_array[@]}" "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for example a `bash` shell to explore this image
exec "$@"
