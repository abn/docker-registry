# Docker Registry (v2) Container

This project puts [Docker Registry (v2)](https://github.com/docker/distribution) in scratch docker container. It is available on [Docker Hub](https://registry.hub.docker.com/u/alectolytic/registry/) and can be pulled using the following command.

```sh
docker pull alectolytic/registry
```

You will note that this is a tiny image.
```
$ docker images | grep docker.io/alectolytic/registry
docker.io/alectolytic/registry    latest    ad31451bf846    19 minutes ago    9.967 MB
```

## Persisted data deployment
In this example we deploy Docker Registry with data persisted via a data container.

#### Create data container
```sh
# create data container
docker create  --entrypoint=_ -v /var/lib/registry --name docker-registry-data scratch
```

#### Start registry (with example configuration)
```sh
docker run -d --name docker-registry -p 5000:5000 \
  --volumes-from docker-registry-data \
  alectolytic/registry
```

#### Start registry (with custom configuration)
```sh
docker run -d --name docker-registry -p 5000:5000 \
  --volumes-from docker-registry-data \
  -v /path/to/config.yml:/config.yml \
  alectolytic/registry
```

**NOTE:** If running on an SELinux enabled system, run `chcon -Rt svirt_sandbox_file_t /path/to/config.yml` before staring the registry.

#### Starting and stopping
You can start or stop `docker-registry` container using the following command.
```sh
# Starting
docker start docker-registry
# stopping
docker stop docker-registry
```

#### Accessing data
You can access data from the data container using any container of your choice.
```sh
# using alpine (tiny busybox)
docker run --rm -it --volumes-from docker-registry-data alpine sh

# using fedora
docker run --rm -it --volumes-from docker-registry-data fedora:latest bash
```
