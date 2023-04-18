#!/usr/bin/env sh

# The Docker App Container's entry point.
# This is a script used by the project's to setup the app containers and databases upon running.

set -e

RAILS_ENV=${RAILS_ENV}
APP_DIR=${APP_DIR}
PORT=${PORT}

# This vars are correct for ruby platform on EB, but not inside a container
echo "== Unsetting conflicting env vars: BUNDLE_DISABLE_SHARED_GEMS, BUNDLE_PATH and BUNDLE_WITHOUT"
unset BUNDLE_DISABLE_SHARED_GEMS
unset BUNDLE_PATH
unset BUNDLE_WITHOUT

echo "== The env is $RAILS_ENV"
echo "== The location of the app is $APP_DIR"

# Execute the given or default command replacing the pid 1:
if [ $# -gt 0 ]; then
  echo "== Executing custom command: $* ..."
  exec "$@"
else
  if [ "$RAILS_ENV" != "production" ]; then
    echo "== Running migrations ..."

    if ! bundle exec rake db:migrate
    then
      echo
      echo "== Failed to migrate. Running setup first ..."
      echo
      bundle exec rake db:create db:migrate db:seed
    fi
  fi

  if [ "$RAILS_ENV" = "production" ]; then
    echo "== Copying public files to shared file system ..."
    rsync -aP "${APP_DIR}/public/." /efs-stoam/public/

    echo "== Using shared file system as public folder ...."
    rm -rf public && ln -s /efs-stoam/public public

    echo "== Opening robots file ..."
    cp public/robots.txt.open public/robots.txt
  fi

  echo "== Starting server ..."
  exec bundle exec rails s -b 0.0.0.0 -p "${PORT}"
fi
