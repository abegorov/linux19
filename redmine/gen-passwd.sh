#!/bin/bash

PWDLEN=26
DIR=$(dirname "${0}")
for pwdfile in redmine-secret postgres-passwd; do
  tr -dc A-Za-z0-9 </dev/urandom | head -c "${PWDLEN}" > "${DIR}/${pwdfile}"
done
