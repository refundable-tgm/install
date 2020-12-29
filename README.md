# Refundable - installation

## Quickstart

### a) Cloning via git

To install Refundable `git` is required (further instructions can be viewed [here](#dependencies))

```bash
mkdir refundable
cd refundable
git clone https://github.com/refundable-tgm/install .
sudo chmod +x refundable.sh
```

### b) Downloading via GitHub

Another way to install Refundable is to download the latest release of this repository. The releases can be found [here](https://github.com/refundable-tgm/install/releases).
The downloaded archive is then unpacked using either the command `unzip <file>` or `tar xfv <file>` depending on which archive was downloaded.
To make the unpacked script then executable the following command must be executed:
```bash
sudo chmod +x refundable.sh
```

### Installing

To install the required files the script has to be executed as follows:
```bash
./refundable.sh install -d
```

If Docker and Docker-Compose are already installed, you are strongly advised to omit the `-d` flag (more [here](#subcommands)). Leaving you with the following command:
```bash
./refundable.sh install
```

## Dependencies

To download repositories via `git clone`, `git` has to be installed. For the uncommon case that `git` is not preinstalled on your local machine, you can easily install it using the following commands:
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

# Installing Process

During the installing process, the script will prompt for user credentials (see [here](config/README.md)) and will download repositories containing the source code of the back- and frontend.

These repositories are the following:
 - [huginn](https://github.com/refundable-tgm/huginn) - the backend
 - [web](https://github.com/refundable-tgm/web) - the frontend