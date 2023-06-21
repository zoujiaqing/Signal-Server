# Signal-Server Full Installation Guide

- Written for Signal-Server v9.81.0
- Documented with a Debian-based server implementation in mind, though nothing besides the dependancies notes should be Debian-specific

## Useful Resources

- [The Signal-Android repo with instructions on how to connect it to this server](https://github.com/JJTofflemire/Signal-Android)
- [Documentation on filling out a sample.yml](config-documentation.md)
- [A `sample.yml` file with added short-hand comments](documented-sample.yml)
- [A `sample-secrets-bundle.yml` with added comments](documented-sample-secrets-bundle.yml)
- [A script to automate starting the server](quickstart.sh)
- [A sample `secrets.sh` script to use with `quickstart.sh`](sample-secrets.sh)
- [A script for fast recloning, compiling, and running](server-recloner.sh)
- [Dependancies installation notes for Ubuntu / Debian](dependancies.md)

## Dependancies

- Java (openjdk)
- Maven (v3.8.6 or newer)
  - If on Debian, you may need to [manually install a newer version](dependancies.md)
- Docker and Docker-Compose

## Compilation

Clone this repo:

```
git clone https://github.com/JJTofflemire/Signal-Server.git
```

- If you want to pull from signalapp's repo, you can run `git clone https://github.com/signalapp/Signal-Server`, and if you want to specify v9.81.0, also run `git checkout 9c93d37`

Compile with:

```
mvn clean install -DskipTests -Pexclude-spam-filter
```

For quick recloning, [here](server-recloner.sh) is a script that moves personal `config.yml`, `config-secrets-bundle.yml`, and `secrets.sh` files out of `Signal-Server` before recloning and rebuilding with `source server-recloner.sh`

- Make sure you move `sever-recloner.sh` one directory up from `Signal-Server`

## Configuration

Fill out `sample.yml` and `sample-secrets-bundle.yml`, located in `service/config/`

- Any configuration notes related to these two .yml files are located [here](config-documentation.md)

## Starting the server

Run all dependancies wrapped in Docker containers with

```
sudo docker-compose up -d
```

Start the server with:

``` 
java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar server service/config/sample.yml
```

## Starting the sever with [quickstart.sh](quickstart.sh)

- `quickstart.sh` is a bash script used to starting Signal-Server and all dependancies required with `source quickstart.sh`

- Currently the script should correctly identify the correct `server.jar` to start regardless of version or which repository is used

  - If `quickstart.sh` can't run the correct server, there is a bare-bones version commented out at the bottom of the script

- By default, `quickstart.sh` looks for `sample.yml` and `sample-secrets-bundle.yml` in the working directory, renamed to `config.yml` and `config-secrets-bundle.yml` to keep personal config files seperated from the sample files

- Currently, `quickstart.sh` exports any environmental variables needed by the server so that they don't have to live permanently in `.bashrc`

  - If you want to do the same thing, make a `secrets.sh` file with the AWS environmental variables from [config-documentation.md](config-documentation.md#aws-iam-configuration) - [here](sample-secrets.sh) is a `sample-secrets.sh`
  
- `quickstart.sh` also automatically stops all dependancies when it recieves a keyboard interrupt (Ctrl+C) or when the server crashes

## Connecting the server to an Android app (unfinished)

- Current documentation on getting the Android app running and connected to this server is [here](https://github.com/JJTofflemire/Signal-Android)

## To-Do

### Configuring the server:

- Figure out what to put in `genericZkConfig` - is it the same as `zkConfig`?

- Figure out what configuration [appConfig](config-documentation.md#aws-appconfig) wants in its .json file

- Figure out how to configure `DynamicConfigurationManager` so it doesn't throw an error when running

### Running the server:

- Be able to ping the server on `localhost`:

  - [Madeindra's](https://github.com/madeindra/signal-setup-guide/tree/master/signal-android) has instructions on this

  - NOTE: the server expects the [`X-Forwarded-for` header](https://github.com/madeindra/signal-setup-guide/tree/master/signal-server-4.xx#proxy)

- Convert all localhost configs to a real server (using NGINX) that a client could connect to following [this guide](https://github.com/madeindra/signal-setup-guide/tree/master/signal-server-2.92)

- Confirm that AWS / Google Cloud function as intended

- Check out a [local DynamoDB Docker instance](https://github.com/madeindra/signal-setup-guide/blob/master/signal-server-5.xx/docker-compose.yml)