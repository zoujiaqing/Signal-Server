# Signal-Server Full Installation Guide

- Written for Signal-Server v9.81.0
- Documented with a Debian-based server implementation in mind, though nothing besides the dependancies notes should be Debian-specific
- Currently in a minimum viable state - it starts and runs successfully, but untested
- Has been [dockerized!](#docker)

## Useful Resources

### Config Docs

- [Documentation on filling out a sample.yml](docs/config-documentation.md)
- [A `sample.yml` file with added short-hand comments](docs/documented-sample.yml)
- [A `sample-secrets-bundle.yml` with added comments](docs/documented-sample-secrets-bundle.yml)
- [A sample `secrets.env` script to use with `quickstart.sh`](docs/sample-secrets.env)
- [A sample `secrets.md` to store any other important keys/info](docs/sample-secrets.md)

### Scripts

- [A script to recompile Signal-Server from JJTofflemire/Signal-Server](scripts/main-compiler.sh)
- [A script to remove `zkgroup` dependancies and recompile](scripts/surgery-compiler.sh)
- [A recloner script (run with `source recloner.sh`)](scripts/recloner.sh)
- [A script to automate starting the server](scripts/quickstart.sh)

### Misc

- [The Signal-Android repo with instructions on how to connect it to this server](https://github.com/JJTofflemire/Signal-Android)
- [Dependancies installation notes for Ubuntu / Debian](docs/dependancies.md)

## Docker!

- Signal-Server v9.81.0 has been dockerized!

- This long guide can all be ignored, just follow the [config instructions](docs/config-documentation.md)(including the [docker specific instructions!](docs/config-documentation.md#dockerized-signal-server-documentation)) then follow the [Docker fork's](https://github.com/JJTofflemire/Signal-Server/tree/docker) instructions on getting set up

## Dependancies

Required:
- Java (openjdk)
- Docker and Docker-Compose

Optional:
- Maven (v3.8.6 or newer)
  - If on Debian, you may need to [manually install a newer version](docs/dependancies.md)

## Compilation

### The easy way

```
git clone https://github.com/JJTofflemire/Signal-Server.git

cd Signal-Server/scripts

source surgery-compiler.sh
```

Make sure to compile with `source <script>` so that `cd` and `mvn` function as intended

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

### Recloning

The [recloner.sh](scripts/recloner.sh) bash script moves the folder [personal-config](personal-config) up one level outside of `Signal-Server`, then reclones from this repository

Call it from inside `scripts` with `source recloner.sh`

### Removing zkgroup dependancies manually

- This removes `zkgroup` (originally called from [libsignal](https://github.com/signalapp/libsignal)) which will let the server start

- In [`WhisperServerService.java`](service/src/main/java/org/whispersystems/textsecuregcm/WhisperServerService.java), comment out lines 639, 739-40, 773-777

- Alternatively, copy the `WhisperServerService.java` file from either the folder `intact` or `post-surgery` to `service/src/main/java/org/whispersystems/textsecuregcm` to either include or remove `zkgroup`

- This is automated with [surgery-compiler.sh](scripts/surgery-compiler.sh), run it with `source surgery-compiler.sh`

## Configuration

### Fill out `sample.yml` and `sample-secrets-bundle.yml`, located in `service/config/`

- Any configuration notes related to these two `.yml` files are located [here](docs/config-documentation.md)

### Docker first run

In order to for the redis-cluster to successfully start, it has to start without any modifications to the source [docker-compose.yml](https://github.com/bitnami/containers/blob/main/bitnami/redis-cluster/docker-compose.yml)

This can be done with:

```
sudo docker-compose -f docker-compose-first-run.yml up -d && sudo docker-compose -f docker-compose-first-run.yml down
```

Which will generate the required volumes


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
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:1
cluster_stats_messages_ping_sent:140
cluster_stats_messages_pong_sent:134
cluster_stats_messages_sent:274
cluster_stats_messages_ping_received:134
cluster_stats_messages_pong_received:140
cluster_stats_messages_received:274
total_cluster_links_buffer_limit_exceeded:0
```

If you started the modified [docker-compose.yml](docker-compose.yml) first, this test will fail. Run:

```
docker volume rm signal-server_redis-cluster_data-0
docker volume rm signal-server_redis-cluster_data-1
docker volume rm signal-server_redis-cluster_data-2
docker volume rm signal-server_redis-cluster_data-3
docker volume rm signal-server_redis-cluster_data-4
docker volume rm signal-server_redis-cluster_data-5
```

- Which should erase all volumes created by the dockerized redis-cluster (and erease all data stored on the cluster)

- If those names are wrong, you can find them with `docker volume ls` and paste in the ones starting with `signal-server_`

- Then rerun the first `docker-compose` command

## Starting the server

### The easy way

[Make sure you configure `quickstart.sh` first!](docs/config-documentation.md)

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
curl http://127.0.0.1:7000/v1/accounts/config
curl http://127.0.0.1:7000/v1/accounts/whoami
curl http://127.0.0.1:7000/v1/test/hello
curl -X POST http://127.0.0.1:7000/v1/registration
curl -X POST http://127.0.0.1:7000/v1/session
```

When running Signal-Server in a Docker container, replace port `7000` with port `7006`

### Connecting the server to an Android app (unfinished)

- Current documentation on getting the Android app running and connected to this server is [here](https://github.com/JJTofflemire/Signal-Android)

## To-Do

- Moved to [Signal-Server Docker](https://github.com/JJTofflemire/Signal-Server/tree/docker#to-do) except for documentation To-Do's because all practical implementation work will now be done from the docker branch

- I lied! Get a working EC2 instance running and see if it fixes AWS issues

  - Add relavent documentation

### Documentation

- Finish [AWS Environmental Variables](docs/config-documentation.md#aws-environmental-variables)

- Revisit [AWS appConfig docs](docs/config-documentation.md#aws-appconfig) and clean up the AWS appConfig cloud input

- Update documentation on [scripts](scripts)