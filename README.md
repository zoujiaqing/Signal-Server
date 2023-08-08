# Signal-Server Full Installation Guide

- [Roadmap! New readers probably start here](https://github.com/JJTofflemire/Signal-Docker)

- Written for Signal-Server v9.81.0
- Documented with a Debian-based server implementation in mind, though nothing besides the dependancies notes should be Debian-specific
- Currently in a minimum viable state - it starts and runs successfully, but unresponsive

## Useful Resources

### Config Docs

- [Documentation on filling out a sample.yml](docs/signal-server-configuration.md)
  - [A `sample.yml` file with added short-hand comments](docs/documented-sample.yml)
  - [A `sample-secrets-bundle.yml` with added comments](docs/documented-sample-secrets-bundle.yml)
  - [A sample `secrets.env` script to use with `quickstart.sh`](docs/sample-secrets.env)
  - [A sample `secrets.md` to store any other important keys/info](docs/sample-secrets.md)

### Scripts

- [A script to compile Signal-Server from JJTofflemire/Signal-Server](scripts/main-compiler.sh) as well as [a script to remove the `zkgroup` dependancies and compile](scripts/surgery-compiler.sh)
- [A recloner script that preserves the `personal-config` folder](scripts/recloner.sh)
- [A script to automate starting the server](scripts/quickstart.sh)
- [A script to reset your docker installation if you mess it up](scripts/docker-compose-first-run.sh)

- Note: all scripts in this repo should be ran as `source script.sh` from the `scripts` folder if you have a `bash` shell
  - If you are using `zsh`, call them with `./script.sh` from the `scripts` folder instead (running with `source` overrides the bash shebang on the first line of the scripts)
  - If you are not using `bash` or `zsh`, good luck soldier

### Misc

- [The Signal-Android repo with instructions on how to connect it to this server](https://github.com/JJTofflemire/Signal-Android)

## Dependancies

Required:
- `git`
- `java`
- `docker`
- `docker-dompose`

Optional:
- `maven` (v3.8.6 or newer)
  - If on Debian, you may need to manually install a newer version

## Compilation

### The easy way

```
git clone https://github.com/JJTofflemire/Signal-Server.git

cd Signal-Server/scripts

source surgery-compiler.sh
```

Make sure to compile with `source <script>` so that `cd` and `mvn` function as intended (or with `./` or `bash` if you aren't on bash)

Using the scripted compilers are recommended to ensure that the server is in the correct configuration (with or without `zkgroup`)

### Manually

- If you want to pull from signalapp's repo, you can run `git clone https://github.com/signalapp/Signal-Server`, and if you want to specify v9.81.0, also run `git checkout 9c93d37`

Then compile with:

```
./mvnw clean install -DskipTests -Pexclude-spam-filter
```

Which uses the maven build script that comes bundled with Signal-Server. You can also install your own instance of maven and build using that:

```
mvn clean install -DskipTests -Pexclude-spam-filter
```

### Removing zkgroup dependancies manually

- This removes `zkgroup` (originally called from [libsignal](https://github.com/signalapp/libsignal)) which will let the server start

- In [`WhisperServerService.java`](service/src/main/java/org/whispersystems/textsecuregcm/WhisperServerService.java), comment out lines 639, 739-40, 773-777

- Alternatively, copy the `WhisperServerService.java` file from either the folder `intact` or `post-surgery` to `service/src/main/java/org/whispersystems/textsecuregcm` to either include or remove `zkgroup`

- This is automated with [surgery-compiler.sh](scripts/surgery-compiler.sh), run it with `source surgery-compiler.sh`

## Configuration

### Fill out `sample.yml` and `sample-secrets-bundle.yml`, located in `service/config/`

- Any configuration notes related to these two `.yml` files are located [here](docs/si .signal-server-configuration.md)

### Other self-hosted services

- Signal-Server is the brains of the whole Signal operation, but there are a handful of smaller self-hosted pieces on the Signalapp Github that need to be started and configured independantly. Check out [this disambiguation doc](docs/self-hosted-dependancies.md) to get started on these, and to find out what you will need

### Docker first run

In order to for the redis-cluster to successfully start, it has to start without any modifications to the source [docker-compose.yml](https://github.com/bitnami/containers/blob/main/bitnami/redis-cluster/docker-compose.yml)

**The easy way**

This can be done with `bash docker-compose-first-run.sh` inside the `scripts` folder

- Note: this script automatically deletes any currently existing volumes, since the unmodified `docker-compose-first-run.yml` would re-use the incorrect ones

**Manually**

Or you can download the file from [here](https://github.com/bitnami/containers/blob/fd15f56824528476ca6bd922d3f7ae8673f1cddd/bitnami/redis-cluster/7.0/debian-11/docker-compose.yml), rename it to `docker-compose-first-run.yml`, place it next to the existing `docker-compose.yml` here and run it with:

```
sudo docker-compose -f docker-compose-first-run.yml up -d && sudo docker-compose -f docker-compose-first-run.yml down
```

If you want to verify that the first run has correctly started a redis cluster:

- Start the container (`sudo docker-compose -f docker-compose-first-run.yml up -d`)

- Find the name of a container to check the logs of with `sudo docker ps`

- Run `sudo docker logs <name from before>` and look for a line like:

```
1:S 06 Jul 2023 22:53:49.430 * Connecting to MASTER 172.27.0.6:6379
```

- Use that IP and port to connect to the server: `redis-cli -h 172.27.0.6 -p 6379`

- Authenticate yourself with `AUTH bitnami`

- Run `CLUSTER INFO`, and if it started correctly, will output:

```
172.27.0.6:6379> CLUSTER INFO
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
etc
```

If you started the modified [docker-compose.yml](docker-compose.yml) before your first run, this test will fail. You can fix it with the `docker-compose-first-run.sh` or manually:

```
docker volume rm signal-server_redis-cluster_data-0
docker volume rm signal-server_redis-cluster_data-1
docker volume rm signal-server_redis-cluster_data-2
docker volume rm signal-server_redis-cluster_data-3
docker volume rm signal-server_redis-cluster_data-4
docker volume rm signal-server_redis-cluster_data-5
```

Which assumes that you are in a folder named `Signal-Server`

Which should erase all volumes created by the dockerized redis-cluster (and erease all data stored on the cluster)

- Then rerun the first manual generation command

## Starting the server

### The easy way

[Make sure you configure `quickstart.sh` first!](docs/si .signal-server-configuration.md)

```
cd scripts

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

## Running the server

To ping the server, try these commands:

```
curl http://127.0.0.1:8080/v1/accounts/config
curl http://127.0.0.1:8080/v1/accounts/whoami
curl http://127.0.0.1:8080/v1/test/hello
curl -X POST http://127.0.0.1:8080/v1/registration
curl -X POST http://127.0.0.1:8080/v1/session
```

When running Signal-Server in a Docker container, replace port `8080` with port `7006`

### Recloning

The [recloner.sh](scripts/recloner.sh) bash script moves the folder [personal-config](personal-config) up one level outside of `Signal-Server`, then reclones from this repository

Call it from inside `scripts` with `source recloner.sh`

### Connecting the server to an Android app (unfinished)

- Current documentation on getting the Android app running and connected to this server is [here](https://github.com/JJTofflemire/Signal-Android)

## To-Do

### General

- Find a command to add a phone to the "registered" section in Signal-Server

- Figure out how to generate certificates for `generic zkconfig` (possibly in libsignal?)

- Add new sections to the compiler script that automatically grabs the server.jar, dumps the output of `unidentifiedelivery` and `zkgroups` into a `.txt`, and moves everything into a dedicated folder (that can be re-used everywhere)

  - This is most likely neccessary because the app / registration-service will ask for your server's specific output of those commands

- Set up [registration-service](https://github.com/signalapp/registration-service), which will require either another EC2 instance or a docker container that can assume IAM roles

- Move redis-cluster docker notes into Signal-Docker and just link to that README.md

- Add a Docker folder here with all the Docker dependancies, and add nginx (and later registration-service)

  - Maybe add a part of quickstart that looks for flags, ex: `bash quickstart.sh redis-cluster nginx-certbot registration-service`

### Running the server

- Make EC2 role and policy narrower

### Documentation

- Revisit [AWS appConfig docs](docs/si .signal-server-configuration.md#aws-appconfig) and clean up the AWS appConfig cloud input

### Extra Credit

- Write scripts for AWS / Google Cloud cli

- Check out a [local DynamoDB Docker instance](https://github.com/madeindra/signal-setup-guide/blob/master/signal-server-5.xx/docker-compose.yml)

- Set up Signal-iOS and Signal-Desktop