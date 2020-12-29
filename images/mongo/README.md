# Infrastructure - MongoDB

This directory functions as build context for the MongoDB image. This image just specifies that the `init-db.sh` is added to the `/docker-entrypoint-initdb.d/` directory into the container. This results in that the script is executed when the container is run automatically when the container starts for the first time.

## init-db.sh

Contents of the script:
```bash
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
```

This script starts a session of the mongo shell in the database to create (name contained in the environment variable `$MONGO_DATABASE`). It then loads the credentials contained in the files mounted as docker secrets. Then it authenticates the root user in the `admin` database to create the new user.
