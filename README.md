# Bitwarden REST API Server
https://hub.docker.com/r/ebette1/bitwarden-rest-api-server

## Overview
Use this Docker file to set up a local REST API server for interacting with Bitwarden resources.

This is an all-in-one implementation of Bitwarden's CLI based solution for setting up a local REST API server for making CLI calls through HTTP requests.

The docker image is updated nightly using the latest Bitwarden CLI.

## Usage
### Set up environment variables
The image uses the environment variables `BW_CLIENTID` and `BW_CLIENTSECRET` to authenticate the API connection.

1. [Follow these instructions](https://bitwarden.com/help/personal-api-key/#get-your-personal-api-key) to get your `client_id` and `client_secret`
2. Put these values into a local file (ie. `$HOME/.env`) to pass to the container at runtime:
```sh
echo BW_CLIENTID=<your_client_id> >> $HOME/.env && \
echo BW_CLIENTSECRET=<your_client_secret> >> $HOME/.env
```

> 🔗 [Using an API key](https://bitwarden.com/help/cli/#using-an-api-key)
### Run
You can run the container by using `docker run`:

```sh
docker run --env-file .env -td -p 8087:8087 ebette1/bitwarden-rest-api-server:latest
```

### Docker Compose
Alternatively, you can set your container up in a `docker-compose.yml` file:

```yaml
services:
  # Service name
  bitwarden-rest-api-server:
  # Image 
  image: ebette1/bitwarden-rest-api-server:latest
  # Container
  container_name: bitwarden-rest-api-server
  # Environment
  environment:
    # Sources from $HOME/.env file (assume docker-compose.yml is also in $HOME)
    - BW_CLIENTID=$BW_CLIENTID
    - BW_CLIENTSECRET=$BW_CLIENTSECRET
  # Networking
  ports:
    - 8087:8087
  # Config
  restart: unless-stopped
```

### Example Usage
You can run commands in the local host's shell using `curl`:

#### Unlock
```sh
curl http://localhost:8087/unlock -d '{"password": "$BT_PASSWORD"}' --header "Content-Type: application/json"
```
#### Handling session keys
> ❗ In order to run additional vault management commands using this API, it is necessary to save and use the [**session key**](https://bitwarden.com/help/cli/#using-a-session-key) provided in the  response to the unlock command.

This command will export the session key **to the docker container's environment**:

```sh
docker container exec -e BW_SESSION=$(curl http://localhost:8087/unlock -d '{"password": "$BT_PASSWORD"}' --header "Content-Type: application/json" | grep -P '(?<="raw":").*(?=")' -o) bitwarden-rest-api-server env
```

## Building the image
If you want to build the image locally, the easiest way is to clone the Github repo and build from there:

```sh
git clone https://github.com/eebette/BitwardenRESTAPIServerDocker
```
```sh
docker build ./BitwardenRESTAPIServerDocker
```

## Thanks
Many thanks to [DarrellTang](https://github.com/DarrellTang), whose work inspired and helped the development of this.

## Links
[Bitwarden Password Manager CLI Documentation](https://bitwarden.com/help/cli/)

[Bitwarden Vault Management API Documentation](https://bitwarden.com/help/vault-management-api/)