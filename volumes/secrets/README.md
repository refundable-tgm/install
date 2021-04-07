# Infrastructure - Volumes

To permanently save and persist the secrets to generate and sign tokens in the application this volume is used. This will result that after a restart of the container the same secrets will be used. This volume is directly mounted into this directory.