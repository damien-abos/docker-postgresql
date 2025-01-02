# Docker for PostgreSQL using Linuxserver.io

Trademarks: This software listing is packaged by Damien Abos. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

This image use a [LinuxServer.io](https://linuxserver.io) container base image featuring:

* regular and timely application updates
* easy user mappings (PGID, PUID)
* custom base image with s6 overlay
* weekly base OS updates with common layers across the entire LinuxServer.io ecosystem to minimise space usage, down time and bandwidth
* regular security updates

## What is PostgreSQL?

> PostgreSQL (Postgres) is an open source object-relational database known for reliability and data integrity. ACID-compliant, it supports foreign keys, joins, views, triggers and stored procedures.

[Overview of PostgreSQL](http://www.postgresql.org)

## TL;DR

```console
docker run --name postgresql dabos/postgresql:latest
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Configuration](#configuration) section for a more secure deployment.

## Get this image

The recommended way to get the Bitnami PostgreSQL Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/dabos/postgresql).

```console
docker pull damien-abos/postgresql:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/dabos/postgresql/tags/) in the Docker Hub Registry.

```console
docker pull damien-abos/postgresql:[TAG]
```

## Persisting your database

If you remove the container all your data and configurations will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/config/postgresql` path. If the mounted directory is empty, it will be initialized on the first run.

```console
docker run \
    -v /path/to/postgresql-persistence:/config/postgresql \
    dabos/postgresql:latest
```

> NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID `911`.

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                       | Description                                                                                      | Default Value                              |
|--------------------------------------------|--------------------------------------------------------------------------------------------------|--------------------------------------------|
| `POSTGRESQL_VOLUME_DIR`                    | Persistence base directory                                                                       | `/config/postgresql`                      |
| `POSTGRESQL_DATA_DIR`                      | PostgreSQL data directory                                                                        | `${POSTGRESQL_VOLUME_DIR}/data`            |
| `POSTGRESQL_EXTRA_FLAGS`                   | Extra flags for PostgreSQL initialization                                                        | `nil`                                      |
| `POSTGRESQL_DATABASE`                      | Default PostgreSQL database                                                                      | `postgres`                                 |
| `POSTGRESQL_INITDB_ARGS`                   | Optional args for PostreSQL initdb operation                                                     | `nil`                                      |
| `POSTGRESQL_PORT_NUMBER`                   | PostgreSQL port number                                                                           | `5432`                                     |
| `POSTGRESQL_USERNAME`                      | PostgreSQL default username                                                                      | `postgres`                                 |
| `POSTGRESQL_INITSCRIPTS_USERNAME`          | Username for the psql scripts included in /docker-entrypoint.initdb                              | `$POSTGRESQL_USERNAME`                     |
| `POSTGRESQL_PASSWORD`                      | Password for the PostgreSQL created user                                                         | `nil`                                      |
| `POSTGRESQL_POSTGRES_PASSWORD`             | Password for the PostgreSQL postgres user                                                        | `nil`                                      |
| `POSTGRESQL_INITSCRIPTS_PASSWORD`          | Password for the PostgreSQL init scripts user                                                    | `$POSTGRESQL_PASSWORD`                     |

### Creating a database on first run

By passing the `POSTGRESQL_DATABASE` environment variable when running the image for the first time, a database will be created. This is useful if your application requires that a database already exists, saving you from having to manually create the database using the PostgreSQL client.

```console
docker run --name postgresql -e POSTGRESQL_DATABASE=my_database dabos/postgresql:latest
```

### Creating a database user on first run

You can also create a restricted database user that only has permissions for the database created with the [`POSTGRESQL_DATABASE`](#creating-a-database-on-first-run) environment variable. To do this, provide the `POSTGRESQL_USERNAME` environment variable.

```console
docker run --name postgresql -e POSTGRESQL_USERNAME=my_user -e POSTGRESQL_PASSWORD=password123 -e POSTGRESQL_DATABASE=my_database dabos/postgresql:latest
```

**Note!**
When `POSTGRESQL_USERNAME` is specified, the `postgres` user is not assigned a password and as a result you cannot login remotely to the PostgreSQL server as the `postgres` user. If you still want to have access with the user `postgres`, please set the `POSTGRESQL_POSTGRES_PASSWORD` environment variable (or the content of the file specified in `POSTGRESQL_POSTGRES_PASSWORD_FILE`).

### Modify pg_hba.conf

By default, the PostgreSQL Image generates `local` and `md5` entries in the pg_hba.conf file. In order to adapt to any other requirements or standards, it is possible to change the pg_hba.conf file by:

* Mounting your own pg_hba.conf file in `/condig/postgresql/data`

## Logging

The PostgreSQL Docker image sends the container logs to the `stdout` using `syslog` mechanism. To view the logs:

```console
docker logs postgresql
```

or using Docker Compose:

```console
docker-compose logs postgresql
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/damien-abos/docker-postgresql/issues) or submitting a [pull request](https://github.com/damien-abos/docker-postgresql/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/damien-abos/docker-postgresql/issues/new/choose). For us to provide better support, be sure to fill the issue template.
