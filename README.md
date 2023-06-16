# Signal-Server Full Installation Guide

- Written for Signal-Server v9.81.0
- Documented with a Debian-based server implementation in mind, though nothing besides the dependancies notes should be Debian-specific

## Useful Resources

- [The Signal-Android repo with instructions on how to connect it to this server](https://github.com/JJTofflemire/Signal-Android)
- [Documentation on filling out a sample.yml](config-documentation.md)
- [A `sample.yml` file with added short-hand comments](documented-sample.yml)
- [A `sample-secrets-bundle.yml` with added comments](documented-sample-secrets-bundle.yml)
- [A script to automate starting the server](quickstart.sh)
- [Dependancies installation notes for Ubuntu / Debian](dependancies.md)

## Dependancies

- Java (openjdk)
- Maven (v3.8.6 or newer)
  - If on Debian, you may need to manually install a newer version
- Docker and Docker-Compose

## Installation

1. Clone this repo with `git clone https://github.com/JJTofflemire/Signal-Server.git`

    1.1. If you want to pull from signalapp's repo, you can run `git clone https://github.com/signalapp/Signal-Server`, and if you want to specify v9.81.0, also run `git checkout 9c93d37`

2. Fill out `sample.yml` and `sample-secrets-bundle.yml`, located in `service/config/`

    2.1. [Here](config-documentation.md) are some notes on filling out the config files

3. Compile with `mvn clean install -DskipTests -Pexclude-spam-filter`

4. Generate the required certificates with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar certificate`
  
    4.1. NOTE: currently I have no idea what this is for, but every old Signal-Server guide includes this, so it will probably be important in connecting to Signal-Android

5.  Run all dependancies wrapped in Docker containers with `sudo docker-compose up -d`

6. Start the server with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar server service/config/sample.yml`

    6.1. `quickstart.sh` skips steps 5-6, but requires a modified `sample.yml`/`sample-secrets-bundle.yml` setup ([see the `quickstart.sh` section](#starting-the-sever-with-quickstartsh))

    6.2. You can test the server to make sure everything is working right by going to `localhost:8080`

      NOTE: This doesn't work yet, so getting the server to talk to the android app is still ambitious

## Starting the sever with [quickstart.sh](quickstart.sh)

- `quickstart.sh` is a bash script used to starting Signal-Server and all dependancies required with `source quickstart.sh`

- Currently the script should correctly identify the correct `server.jar` to start regardless of version or which repository is used

  - If `quickstart.sh` can't run the correct server, there is a bare-bones version commented out at the bottom of the script

- By default, `quickstart.sh` looks for `sample.yml` and `sample-secrets-bundle.yml` in the working directory, renamed to `config.yml` and `config-secrets-bundle.yml` to keep personal config files seperated from the sample files

- Currently, `quickstart.sh` exports any environmental variables needed by the server so that they don't have to live permanently in `.bashrc`

  - If you want to do the same thing, make a `secrets.sh` file with the AWS environmental variables described [here](config-documentation.md) (if not, just comment it out)
  
- `quickstart.sh` also automatically stops all dependancies when it recieves a keyboard interrupt (Ctrl+C)

## Connecting the server to an Android app (unfinished)

- Current documentation on getting the Android app running and connected to this server is [here](https://github.com/JJTofflemire/Signal-Android)

## To-Do

- ~~Get Signal-Server to compile locally (figure out dependancies and whatnot)~~

- ~~Get Signal-Server to start locally~~

- ~~Fill out `sample.yml` and `sample-secrets-bundle.yml` enough to get the server to run without crashing~~

    - ~~Document what is required and what is optional~~

 - ~~Create Docker containers for all other servers and services that Signal-Server needs to run~~

    - ~~Add documentation on extra dependancies needed for said servers and services~~
    
  - ~~Get Google Cloud to create a bucket with a key that I have a copy of~~

  - ~~Fix Braintree (it's unhappy with `unset`)~~

- get the server to be reachable on `localhost`

- Confirm that the current Redis setup functions for storing information

- Confirm that AWS / Google Cloud function as intended

- ~~Sort out the requirements that can be dockerized~~

- Figure out what the deal is with extracting certificates with `certificate` when running the server

- Successfully get this fork of Signal-Server to connect to a fork of the android app

- Convert all localhost configs to a real server that a client could connect to

- ~~Create a bash script to automate the process (currently [quickstart.sh](quickstart.sh))~~

    - ~~Make it automatically start the correct file regardless of varying naming schemes~~
    
    - ~~Add documentation~~

- ~~Add an example `sample.yml` and `sample-secrets-bundle.yml` with shorthand comments on what to fill out~~

### Extra Credit

- Also get Signal-iOS and Signal-Desktop working with a personal Signal-Server

- Completely strip out some of the parts I don't want (payment, calls, stories etc)

- Remove all cloud dependancies (basically impossible)

  - [Replace AWS with Minio](https://github.com/aqnouch/Signal-Setup-Guide/tree/master/signal-minio) (outdated guide most likely)