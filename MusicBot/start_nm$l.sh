#! /bin/bash -e
# Original config create by jenkins mit license
# if `docker run` first argument start with `--` the user is passing jenkins launcher arguments
APP_HOME=${BOT_HOME}
APP_OPTS=${BOT_OPTS}
APP_JAR=${JMUSICBOT_APP}
cd $APP_HOME

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

  app_opts_array=( )
  while IFS= read -r -d '' item; do
    app_opts_array+=( "$item" )
  done < <([[ $APP_OPTS ]] && xargs printf '%s\0' <<<"$APP_OPTS")
  cd 
  exec java -Duser.home="$APP_HOME" "${java_opts_array[@]}" -jar $APP_JAR "${app_opts_array[@]}" "$@"