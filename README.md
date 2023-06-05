Signal-Server Full Installation Guide
=================

- Written for Signal-Server v9.81.0 and ran on Ubuntu 22.04.2 LTS
- By and for idiots that don’t know how computers work

Quick Manual Instructions
-----------------

1. `update` and `upgrade`

2. Install the latest versions of Java and Maven

3. Clone this repo \

    a. If you clone the Signal-Server, you can grab all the extra files included in this repo and hope that the new commits haven't broken too much

4. Fill out the `service/config/sample.yml` and `service/config/sample-secrets-bundle.yml`

5. Run `mvn clean install -DskipTests -Pexclude-spam-filter`

6. Grab certificates with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar certificate`

7. Run all the other dependancies ----> UNFINISHED

8. Run server with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar server service/config/sample.yml`

Idiot-Proof Manual Instructions
-----------------

1. Make sure everything is up-to-date with `sudo apt update` and `sudo apt upgrade`
2. Install the latest version of Java \
    a. Enter `java --version` into the terminal \
    b. If Java isn’t installed, you will be prompted with different versions to install. `sudo apt install openjdk-VERSION-jre-headless` the latest openjdk version listed there
3. Manually install the latest version of Maven - apt installs an older version \
    a. [Download the latest `maven-apache-VERSION-bin.zip`](https://maven.apache.org/download.cgi?) \
    b. Unzip the file and place it anywhere that won't get deleted (I put it in Home) \
    c. Add the path to the `bin` folder inside `maven-apache-VERSION-bin` to `.bashrc` \
    d. Open `.bashrc` with `sudo nano ~/.bashrc` and add `export PATH=“/path/to/apache-maven-VERSION/bin:$PATH”` then save and exit \
    e. Apply the changes with `. ~/.bashrc`, then check Maven with `mvn --version`
4. Clone this repo with `git clone https://github.com/JJTofflemire/Signal-Server.git` \
    b. If you want to pull from signalapp's repo, you can run `git clone https://github.com/signalapp/Signal-Server`, and if you want to specify v9.81.0, also run `git checkout 9c93d37`
5. Fill out `sample.yml` and `sample-secrets-bundle.yml`, either in `service/config` or in a separate folder if you are using the install script \
    a. ----> UNFINISHED, add all the dependancies needed to run and all the optional ones \
    b. Specify your AWS region with `sudo nano ~/.bashrc`, add `export AWS_REGION=your-region` to the end of the file, then run `. ~/.bashrc`
6. Compile with `mvn clean install -DskipTests -Pexclude-spam-filter`
7. Generate the required certificates with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar certificate`
8. Run all dependancies wrapped in Docker containers ----> UNFINISHED
9. Start the server with `java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-9.81.0.jar server service/config/sample.yml`

To-Do
-----------------

~~- Get Signal-Server to compile locally (figure out dependancies and whatnot)~~
~~- Get Signal-Server to start locally~~
- Fill out `sample.yml` and `sample-secrets-bundle.yml`
    - Document what is required and what is optional
    - Create Docker containers for all other servers and services that Signal-Server needs to run
    - Add documentation on extra dependancies needed for said servers and services
- Create a bash script to automate the process
    - Add short documentation on 
- Successfully get this fork of Signal-Server to connect to a fork of the android app
- Add an example `sample.yml` and `sample-secrets-bundle.yml` with comments on what to fill out