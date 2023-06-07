Signal-Server Full Installation Guide
=================

- Written for Signal-Server v9.81.0 and ran on Ubuntu 22.04.2 LTS

Table of Contents
------------------
- [Signal-Server Full Installation Guide](#signal-server-full-installation-guide)
  - [Table of Contents](#table-of-contents)
  - [Useful Resources](#useful-resources)
  - [Quick Manual Instructions](#quick-manual-instructions)
  - [Idiot-Proof Manual Instructions](#idiot-proof-manual-instructions)
  - [Starting the sever with quickstart.sh](#starting-the-sever-with-quickstartsh)
  - [To-Do](#to-do)

Useful Resources
-----------------
- [Documentation on filling out a sample.yml](sample-yml-config-documentation.md)
- [A sample.yml file with added short-hand comments](sample-with-added-comments.yml)
- [A script to automate starting the server](quickstart.sh)

Quick Manual Instructions
-----------------

1. Install the latest versions of Java, Maven (Signal-Server wants >=3.8.6), Docker, and Docker-Compose

2. Clone this repo

    2.1. If you clone the Signal-Server on the latest release, you will be a bit in the dark but hopefully you can still use parts like `docker-compose.yml` and simmilar

3. Fill out the `service/config/sample.yml` and `service/config/sample-secrets-bundle.yml` - [here](sample-yml-config-documentation.md) is some documentation

4. Run `mvn clean install -DskipTests -Pexclude-spam-filter`

5. Grab certificates with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar certificate` -----> I don't know if this is needed

6. Configure all other dependancies needed to run - either in `docker-compose.yml` or in `quickstart.sh`

7. Run server with [quickstart.sh](quickstart.sh), or manually start all dependancies and the server with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar server service/config/sample-secrets-bundle.yml`

Idiot-Proof Manual Instructions
-----------------

1. Make sure everything is up-to-date with `sudo apt update` and `sudo apt upgrade`

2. Install the latest version of Java

    2.1. Enter `java --version` into the terminal

    2.2. If Java isn’t installed, you will be prompted with different versions to install. `sudo apt install openjdk-VERSION-jre-headless` the latest openjdk version listed there

3. Manually install the latest version of Maven

    3.1. [Download the latest `maven-apache-VERSION-bin.zip`](https://maven.apache.org/download.cgi?)

    3.2. Unzip the file and place it anywhere that won't get deleted (I put it in Home)

    3.3. Add the path to the `bin` folder inside `maven-apache-VERSION-bin` to `.bashrc`

    3.4. Open `.bashrc` with `sudo nano ~/.bashrc` and add `export PATH=“/path/to/apache-maven-VERSION/bin:$PATH”` then save and exit

    3.5. Apply the changes with `. ~/.bashrc`, then check Maven with `mvn --version`

4. Install Docker and Docker-Compose ([taken from this guide](https://www.howtogeek.com/devops/how-to-install-docker-and-docker-compose-on-linux/))

    Docker: 
    
    4.1. `sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release`

    4.2. `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg`

    4.3. `echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`

    4.4. `sudo apt install docker-ce docker-ce-cli containerd.io`

    4.5. If you want to test the Docker installation, run `sudo docker run hello-world:latest`

    Docker-Compose:
    
    4.6. `sudo curl -L "https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`, or replace `2.18.1` with the [latest stable release](https://github.com/docker/compose/releases)

    4.7. `sudo chmod +x /usr/local/bin/docker-compose`

    4.8. If you want to test the docker-compose isntallation, run `sudo docker-compose --version`

5. Clone this repo with `git clone https://github.com/JJTofflemire/Signal-Server.git`

    4.1. If you want to pull from signalapp's repo, you can run `git clone https://github.com/signalapp/Signal-Server`, and if you want to specify v9.81.0, also run `git checkout 9c93d37`

6. Fill out `sample.yml` and `sample-secrets-bundle.yml`, either in `service/config`

    6.1. [Here is an outline of what needs to be filled out (and what can be left blank) and instructions on the more annoying bits](sample-yml-config-documentation.md)

7. Compile with `mvn clean install -DskipTests -Pexclude-spam-filter`

8. Generate the required certificates with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar certificate`

9.  Run all dependancies wrapped in Docker containers ----> UNFINISHED

10. Start the server with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar server service/config/sample.yml`

Starting the sever with [quickstart.sh](quickstart.sh)
-----------------
- `quickstart.sh` is the bash script currently used for starting Signal-Server and all dependancies required

- Depending on how Signal-Server was compiled, the name of the `TextSecureServer-<version>-<other descriptors>.jar` might differ

- By default, `quickstart.sh` looks for `sample.yml` and `sample-secrets-bundle.yml` in its directory, renamed to `config.yml` and `config-secrets-bundle.yml`

  - This way personal config files can be kept seperate from the rest of the repo

To-Do
-----------------

- ~~Get Signal-Server to compile locally (figure out dependancies and whatnot)~~

- ~~Get Signal-Server to start locally~~

- Fill out `sample.yml` and `sample-secrets-bundle.yml` enough to get the server to run without crashing

    - Document what is required and what is optional

 - ~~Create Docker containers for all other servers and services that Signal-Server needs to run~~

    - ~~Add documentation on extra dependancies needed for said servers and services~~
    
  - Get Google Cloud to create a bucket with a key that I have a copy of
  
  - Confirm that the current Redis setup functions for storing information
  
  - Convert all localhost configs to a real server that a client could connect to

- Figure out what the deal is with extracting certificates with `certificate` when running the server

- Successfully get this fork of Signal-Server to connect to a fork of the android app

- Create a bash script to automate the process (currently [quickstart.sh](quickstart.sh))

    - Make it automatically start the correct file regardless of varying naming schemes
    
    - ~~Add documentation~~

- Add an example `sample.yml` and `sample-secrets-bundle.yml` with shorthand comments on what to fill out
