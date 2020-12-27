#!/bin/bash

root_username=$(<"$MONGO_INITDB_ROOT_USERNAME_FILE")
root_password=$(<"$MONGO_INITDB_ROOT_PASSWORD_FILE")
root_db=$MONGO_INITDB_DATABASE
user_username=$(<"$MONGO_USERNAME_FILE")
user_password=$(<"$MONGO_PASSWORD_FILE")
new_db=$MONGO_DATABASE

mongo -- root_db << EOF
db.auth(root_username, root_password);
var sib = db.getSiblingDB(new_db);
sib.createUser({user: user_username, pwd: user_password, roles: [{role: 'readWrite', db: new_db}]};
EOF
