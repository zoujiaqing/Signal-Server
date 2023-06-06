Signal-Server Full Installation Guide
=================

- Written for Signal-Server v9.81.0 and ran on Ubuntu 22.04.2 LTS
- By and for idiots that don’t know how computers work

Quick Manual Instructions
-----------------

1. `update` and `upgrade`

2. Install the latest versions of Java, Maven, Docker, and Docker-Compose

3. Clone this repo

    3.1. If you clone the Signal-Server, you can grab all the extra files included in this repo and hope that the new commits haven't broken too much

4. Fill out the `service/config/sample.yml` and `service/config/sample-secrets-bundle.yml` - [here is some documentation if needed](sample-yml-config-documentation.md)

5. Run `mvn clean install -DskipTests -Pexclude-spam-filter`

6. Grab certificates with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar certificate`

7. Run all the other dependancies in Docker containers ----> UNFINISHED

8. Run server with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar server service/config/sample.yml`

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

6. Fill out `sample.yml` and `sample-secrets-bundle.yml`, either in `service/config` or in a separate folder if you are using the install script

    5.1. [Here is an outline of what needs to be filled out (and what can be left blank) and short instructions on the more annoying bits](sample-yml-config-documentation.md)

    5.2. Specify your AWS region with `sudo nano ~/.bashrc`, add `export AWS_REGION=your-region` to the end of the file, then run `. ~/.bashrc`

7. Compile with `mvn clean install -DskipTests -Pexclude-spam-filter`

8. Generate the required certificates with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar certificate`

9.  Run all dependancies wrapped in Docker containers ----> UNFINISHED

10. Start the server with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar server service/config/sample.yml`

To-Do
-----------------

- ~~Get Signal-Server to compile locally (figure out dependancies and whatnot)~~

- ~~Get Signal-Server to start locally~~

- Fill out `sample.yml` and `sample-secrets-bundle.yml` enough to get the server to run without crashing

    - Document what is required and what is optional

 - ~~Create Docker containers for all other servers and services that Signal-Server needs to run~~

    - ~~Add documentation on extra dependancies needed for said servers and services~~
    
    - Get Google Cloud to work and document it
  
  - Confirm that the current Redis setup functions for storing information
  
  - Convert all localhost configs to a real server that a client could connect to

- Successfully get this fork of Signal-Server to connect to a fork of the android app

- Create a bash script to automate the process

    - Add short documentation on using script once it is finished and server runs

- Add an example `sample.yml` and `sample-secrets-bundle.yml` with shorthand comments on what to fill out
