# Signal-Server Full Installation Guide

- Written for Signal-Server v9.81.0
- Documented with a Debian-based server implementation in mind, though nothing besides the dependancies notes should be Debian-specific
- Currently in a minimum viable state - it starts and runs successfully, but who knows what it can do

## Branches

- Currently this project is split into two branches: [main](https://github.com/JJTofflemire/Signal-Server/tree/main) and [post-surgery](https://github.com/JJTofflemire/Signal-Server/tree/post-surgery)

  - `main` is for the original Signal-Server v9.81.0 source code (with irrelevant files stripped out) and `post-surgery` is for any modifications made to the source code (while being very barebones)

    - Currently, `post-surgery` has only removed the `zkconfig` dependancy

- These branches function identically, so for ease-of-use [main-recloner.sh](main-recloner.sh) and [post-surgery-recloner.sh](post-surgery-recloner.sh) manage switching between branches (and both get started with `quickstart.sh`)

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

For recloning and recompiling, use either `main-recloner.sh` or `post-surgery-recloner.sh` for each respective branch

- NOTE: If switching to `post-surgery`, clone the main branch and compile with `post-surgery-recloner.sh` (since `main` will receive updates while `post-surgery` is just storage for the pruned and edited Signal-Server)

## Configuration

### Fill out `sample.yml` and `sample-secrets-bundle.yml`, located in `service/config/`

- Any configuration notes related to these two `.yml` files are located [here](config-documentation.md)

### Removing zkgroup dependancies

- This is the change that was done to `main` to turn it into `post-surgery`

- In [`WhisperServerService.java`](service/src/main/java/org/whispersystems/textsecuregcm/WhisperServerService.java), comment out lines 639, 739-40, 773-777

- Then run the following (make sure to back up all personal config bits)

```
mvn clean install -Dmaven.test.skip=true -Pexclude-spam-filter

mvn install -Dmaven.test.skip=true -Pexclude-spam-filter
```

- This surgery is done to remove the `genericZkConfig.serverSecret` dependancy (and probably `zkConfig.serverSecret`) because Signal-Server requires `genericZkConfig` and provides no documentation on it or a way to generate it. It is definitely solvable but not within the timeframe that I have

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

- By default, `quickstart.sh` looks for `sample.yml` and `sample-secrets-bundle.yml` in the directory `gitignore`, renamed to `config.yml` and `config-secrets-bundle.yml` to keep personal config files seperated from the sample files

- Currently, `quickstart.sh` exports any environmental variables needed by the server so that they don't have to live permanently in `.bashrc`

  - If you want to do the same thing, make a `secrets.sh` file with the AWS environmental variables from [config-documentation.md](config-documentation.md#aws-iam-configuration) - [here](sample-secrets.sh) is a `sample-secrets.sh`

- `quickstart.sh` also automatically stops all dependancies when it recieves a keyboard interrupt (Ctrl+C) or when the server crashes

### [surgerystart.sh](surgerystart.sh) in `post-surgery`

- Inside the branch `post-surgery`, a seperate bash script is used to seperate config and startup with or without `zkconfig`

- It works the same way as `quickstart.sh`, but it refers to `docker-compose-surgery.yml`, `config-surgery.yml`, and `config-secrets-bundle-surgery.yml`

## Connecting the server to an Android app (unfinished)

- Current documentation on getting the Android app running and connected to this server is [here](https://github.com/JJTofflemire/Signal-Android)

## To-Do

### Configuring the server:

- Figure out what configuration [appConfig](config-documentation.md#aws-appconfig) wants in its .json file

- Add firebase documentation to Signal-Android and change the folder structure in Signal-Android

- Get `redis-cluster` recognizable and usable by Signal-Server

### Running the server:

- Be able to ping the server on `localhost`:

  - [Madeindra's](https://github.com/madeindra/signal-setup-guide/tree/master/signal-android) has instructions on this

  - NOTE: the server expects the [`X-Forwarded-for` header](https://github.com/madeindra/signal-setup-guide/tree/master/signal-server-4.xx#proxy)

- Convert all localhost configs to a real server (using NGINX) that a client could connect to following [this guide](https://github.com/madeindra/signal-setup-guide/tree/master/signal-server-2.92)

- Confirm that AWS / Google Cloud function as intended

- Check out a [local DynamoDB Docker instance](https://github.com/madeindra/signal-setup-guide/blob/master/signal-server-5.xx/docker-compose.yml)