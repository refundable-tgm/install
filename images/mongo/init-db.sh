#!/bin/bash

mongo -- "$MONGO_DATABASE" << EOF
    var rootUser = '$(cat "$MONGO_INITDB_ROOT_USERNAME_FILE")';
    var rootPassword = '$(cat "$MONGO_INITDB_ROOT_PASSWORD_FILE")';
    var admin = db.getSiblingDB("$MONGO_INITDB_DATABASE");
    admin.auth(rootUser, rootPassword);

    var user = '$(cat "$MONGO_USERNAME_FILE")';
    var passwd = '$(cat "$MONGO_PASSWORD_FILE")';
    db.createUser({user: user, pwd: passwd, roles: ["readWrite"]});
EOF
