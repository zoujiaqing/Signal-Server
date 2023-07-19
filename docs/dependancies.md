# Dependancies Installation

## Notes

- I wrote this on Ubuntu 22.04.2 LTS, but these notes should be the same for running plain Debian
- These notes should be pretty dummy-proof since I wrote them for myself

## Instructions

1. Make sure everything is up-to-date with `sudo apt update && sudo apt upgrade`

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