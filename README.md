Android Open Source Project (AOSP) build environment in a Docker image.

### Building the docker image

Get a pre-built image from Docker hub with `docker pull jftr/aosp-build-env` or use the [Dockerfile](https://github.com/justfortherec/aosp-build-env/blob/master/Dockerfile) to build yourself.

### Running the image

The image can be run with the following command:

    docker run --rm -i -t \
        -v $PATH_ON_HOST:/opt/aosp/ \
        -e USER_ID=$(id -u) \
        -e GROUD_ID=$(id -g) \
        jftr/aosp-build-env

When running the image, an AOSP build environment is setup:

 * Dependencies are installed in a Ubuntu 16.04 LTS system.
 * `repo` is installed for project management.
 * Working directory inside the image is created as a volume.
 * User `aosp` has the same group ID and user ID as your user on the host.

#### Mount shared volume

In order to make all changes persistent, `/opt/aosp/` should be mounted as a shared volume by calling `docker run` with the `-v $PATH_ON_HOST/:/opt/aosp/` option (where `$PATH_ON_HOST` is the path at which you would want to store the repository and builds on your host.

    docker run --rm -i -t -v $PATH_ON_HOST:/opt/aosp/ jftr/aosp-build-env

#### Pass user and group IDs

When running the container, `entrypoint.sh` creates a user `aosp` with `USER_ID` 1000 and `GROUD_ID` 1000.

This can lead to missing permissions to access data (e.g. build artifacts) from the host If your user on the host has a different ID.
To make sure host and container user IDs match, you can pass environment variables when running the container:

    docker run --rm -i -t -e USER_ID=$(id -u) -e GROUD_ID=$(id -g) jftr/aosp-build-env
