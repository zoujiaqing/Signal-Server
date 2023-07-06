# Signal-Server Full Installation Guide

- Written for Signal-Server v9.81.0
- Documented with a Debian-based server implementation in mind, though nothing besides the dependancies notes should be Debian-specific
- Currently in a minimum viable state - it starts and runs successfully, but untested

## Useful Resources

### Config Docs

- [Documentation on filling out a sample.yml](docs/config-documentation.md)
- [A `sample.yml` file with added short-hand comments](docs/documented-sample.yml)
- [A `sample-secrets-bundle.yml` with added comments](docs/documented-sample-secrets-bundle.yml)
- [A sample `secrets.sh` script to use with `quickstart.sh`](docs/sample-secrets.sh)

### Scripts

- [A script to recompile Signal-Server from JJTofflemire/Signal-Server](scripts/main-compiler.sh)
- [A script to remove `zkgroup` dependancies and recompile](scripts/surgery-compiler.sh)
- [A recloner script (run with `source recloner.sh`)](scripts/recloner.sh)
- [A script to automate starting the server](scripts/quickstart.sh)

### Misc

- [The Signal-Android repo with instructions on how to connect it to this server](https://github.com/JJTofflemire/Signal-Android)
- [Dependancies installation notes for Ubuntu / Debian](docs/dependancies.md)

## Dependancies

- Java (openjdk)
- Maven (v3.8.6 or newer)
  - If on Debian, you may need to [manually install a newer version](docs/dependancies.md)
- Docker and Docker-Compose

## Compilation

### The easy way

```
git clone https://github.com/JJTofflemire/Signal-Server.git

cd Signal-Server/scripts

source surgery-compiler.sh
```

### Manually

- If you want to pull from signalapp's repo, you can run `git clone https://github.com/signalapp/Signal-Server`, and if you want to specify v9.81.0, also run `git checkout 9c93d37`

Then compile with:

```
mvn clean install -DskipTests -Pexclude-spam-filter
```

### Removing zkgroup dependancies manually

- This removes `zkgroup` (originally called from [libsignal](https://github.com/signalapp/libsignal)) which will let the server start

- In [`WhisperServerService.java`](service/src/main/java/org/whispersystems/textsecuregcm/WhisperServerService.java), comment out lines 639, 739-40, 773-777

- This is automated with [surgery-compiler.sh](scripts/surgery-compiler.sh), run it with `source surgery-compiler.sh`

## Configuration

### Fill out `sample.yml` and `sample-secrets-bundle.yml`, located in `service/config/`

- Any configuration notes related to these two `.yml` files are located [here](docs/config-documentation.md)

## Starting the server

### The easy way

[Make sure you configure `quickstart.sh` first!](docs/config-documentation.md)

```
source quickstart.sh
```

### Manually

Call your environmental variables (if not in `.bashrc`)

Make sure your AWS environmental variables are sorted out

Run redis:

```
sudo docker-compose up -d
```

Start the server with:

``` 
java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar server service/config/sample.yml
```

## Connecting the server to an Android app (unfinished)

- Current documentation on getting the Android app running and connected to this server is [here](https://github.com/JJTofflemire/Signal-Android)

## To-Do

### Running the server:

- Be able to ping the server on `localhost`:

- Convert all localhost configs to a real server (using NGINX) that a client could connect to following [this guide](https://github.com/madeindra/signal-setup-guide/tree/master/signal-server-2.92)

- Confirm that AWS / Google Cloud function as intended

- Check out a [local DynamoDB Docker instance](https://github.com/madeindra/signal-setup-guide/blob/master/signal-server-5.xx/docker-compose.yml)