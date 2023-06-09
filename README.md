# Signal-Server Full Installation Guide

- Written for Signal-Server v9.81.0 and ran on Ubuntu 22.04.2 LTS

## Useful Resources

- <a href="https://github.com/JJTofflemire/Signal-Server/blob/main/sample-yml-config-documentation.md" target="_blank">Documentation on filling out a sample.yml</a>
- <a href="https://github.com/JJTofflemire/Signal-Server/blob/main/sample-with-added-comments.yml" target="_blank">A sample.yml file with added short-hand comments</a>
- <a href="https://github.com/JJTofflemire/Signal-Server/blob/main/quickstart.sh" target="_blank">A script to automate starting the server</a>
- <a href="https://github.com/JJTofflemire/Signal-Server/blob/main/dependancies.md" target="_blank">Dependancies installation notes</a>

## Dependancies

- Java (openjdk)
- Maven (v3.8.6 or newer)
- Docker and Docker-Compose

## Installation

1. Clone this repo with `git clone https://github.com/JJTofflemire/Signal-Server.git`

    1.1. If you want to pull from signalapp's repo, you can run `git clone https://github.com/signalapp/Signal-Server`, and if you want to specify v9.81.0, also run `git checkout 9c93d37`

2. Fill out `sample.yml` and `sample-secrets-bundle.yml`, either in `service/config`

    2.1. <a href="https://github.com/JJTofflemire/Signal-Server/blob/main/sample-yml-config-documentation.md" target="_blank">Here is some notes on filling out the config files</a>

3. Compile with `mvn clean install -DskipTests -Pexclude-spam-filter`

4. Generate the required certificates with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar certificate`

5.  Run all dependancies wrapped in Docker containers ----> UNFINISHED

6. Start the server with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar server service/config/sample.yml`

## Starting the sever with [quickstart.sh](quickstart.sh)

- `quickstart.sh` is the bash script currently used for starting Signal-Server and all dependancies required

- Depending on how Signal-Server was compiled, the name of the `TextSecureServer-<version>-<other descriptors>.jar` might differ

- By default, `quickstart.sh` looks for `sample.yml` and `sample-secrets-bundle.yml` in its directory, renamed to `config.yml` and `config-secrets-bundle.yml`

  - This way personal config files can be kept seperate from the rest of the repo

## To-Do

- ~~Get Signal-Server to compile locally (figure out dependancies and whatnot)~~

- ~~Get Signal-Server to start locally~~

- Fill out `sample.yml` and `sample-secrets-bundle.yml` enough to get the server to run without crashing

    - ~~Document what is required and what is optional~~

 - ~~Create Docker containers for all other servers and services that Signal-Server needs to run~~

    - ~~Add documentation on extra dependancies needed for said servers and services~~
    
  - ~~Get Google Cloud to create a bucket with a key that I have a copy of~~
  
  - Confirm that the current Redis setup functions for storing information

  - Fix Braintree (it's unhappy with `unset`)

- Figure out what the deal is with extracting certificates with `certificate` when running the server

- Successfully get this fork of Signal-Server to connect to a fork of the android app

- Convert all localhost configs to a real server that a client could connect to

- Create a bash script to automate the process (currently [quickstart.sh](quickstart.sh))

    - Make it automatically start the correct file regardless of varying naming schemes
    
    - ~~Add documentation~~

- ~~Add an example `sample.yml` and `sample-secrets-bundle.yml` with shorthand comments on what to fill out~~

### Extra Credit

- Also get Signal-iOS and Signal-Desktop working with a personal Signal-Server

- Strip out some of the parts I don't want (payment, calls, stories etc)
