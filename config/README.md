# Installation - Configuration

During the installation progress the user is prompted for the credentials of the root user and the user of the `refundable` database of the MongoDB instance.

These credentials are then saved into the following files in this directory:
 - `mongodb_root_username` - the username of the root user
 - `mongodb_root_password` - the password of the root user
 - `mongodb_username` - the username of the user of the `refundable` database
 - `mongodb_password` - the password of the user of the `refundable` database

All these files are later mounted into the MongoDB container and the files containing the information of the normal user into the REST-Go container as secrets.
The files are then available at `/run/secrets/<file_name>` in the specified containers.