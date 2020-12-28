# Refundable - installation

## Quickstart

To install Refundable `git` is required (further instructions can be viewed [here](#dependencies))

```bash
mkdir refundable
cd refundable
git clone https://github.com/refundable-tgm/install .
sudo chmod +x refundable.sh
```

To install the required files the script has to be executed as follows:
```bash
./refundable.sh install -d
```

If Docker and Docker-Compose are already installed, you are strongly advised to omit the `-d` flag (more [here](#subcommands)). Leaving you with the following command:
```bash
./refundable.sh install
```

## Dependencies

To download this installer git repository `git` has to be installed. For the uncommon case that `git` is not preinstalled on your local machine, you can easily install it using the following commands:
```bash
sudo apt update
sudo apt install git
```

## Subcommands

The following subcommands are available, when using the `refundable.sh` script:

|  Subcommand  |                      Description                       |
| :----------: | :----------------------------------------------------: |
|   install    |          installs refundable on this machine           |
| install [-d] | if the '-d' flag is provided, docker will be installed |
|    start     |                 starts the application                 |
|     stop     |                 stops the application                  |
|   restart    |                restarts the application                |
|    update    |  updates all components of refundable (incl. restart)  |
|    clean     |             cleans all dangling components             |
|    purge     |             removes refundable completely              |
|  uninstall   |                     alias to purge                     |
