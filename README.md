# docker-backportpackage
A Dockerfile for backporting Ubuntu packages.

## Usage

The image need the environment variables `DEBFULLNAME`, `DEBEMAIL` and `DEBSIGN_KEYID`.
They can either be passed to the `docker run` command, or imported from the local
shell environment.

A simple way to run the image is to use the `backport` script
in this repository; for instance, in order to backport the package `init-system-helpers`
from `trusty` to `precise`, run the command

    $ ./backport init-system-helpers trusty precise

The above will create source and binary packages, and will put the files in
`./pkg` (creating it if necessary).

    $ ls ./pkg/buildresult/
    dh-systemd_1.14~ubuntu12.04.1_all.deb
    init-system-helpers_1.14~ubuntu12.04.1.dsc
    init-system-helpers_1.14~ubuntu12.04.1.tar.gz
    init-system-helpers_1.14~ubuntu12.04.1_all.deb
    init-system-helpers_1.14~ubuntu12.04.1_amd64.changes

Once satisfied with the result, the source package (`.dsc`) can be re-generated
and uploaded to a PPA for distribution:

    $ ./backport init-system-helpers trusty precise ppa:myuser/mybackports

## Building the image

The Docker image can be built by issuing the standard command

    $ docker build -t bcandrea/backportpackage .
