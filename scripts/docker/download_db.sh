#!/bin/sh

set -e

curl -o ../../tmp/db_latest.dump "$(heroku pg:backups:public-url --app apollo-core)"
