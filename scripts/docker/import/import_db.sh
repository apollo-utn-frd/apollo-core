#!/bin/sh

set -e

dump=/tmp/db_latest.dump

if [ -e "$dump" ]; then
  procn=$(( $(getconf _NPROCESSORS_ONLN) - 2 )) # Number of processors available - 2
  jobsn=$(( procn < 1 ? 1 : procn )) # Jobs option for pg_restore

  createdb -U postgres  -e apollo_development
  createdb -U postgres  -e apollo_test

  pg_restore --verbose --clean --no-acl --no-owner -U postgres -d apollo_development -j "$jobsn" $dump || true

  # rm $dump

  echo
  echo "Import DB - Done"
else
  echo
  echo "Ignore import DB: Dump not exists"
fi
