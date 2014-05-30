OSIAM Docker Image
==================

This project builds a docker image with OSIAM installed and configured ready to 
use for development purposes. **NOTE:** This image is for development purposes only! Do not even think about using it in a production-like environment!

Build image with:

    mvn clean initialize docker:package

After the build you can tag the new image (named "osiam-docker_osiam-dev") and upload it to the index or a private repository.

    docker tag osiam-docker_osiam-dev osiam/dev

Cleanup with:

    mvn docker:clean
    
This project proudly uses [docker-maven-plugin](https://github.com/alexec/docker-maven-plugin) by [Alex Collins](https://github.com/alexec), so see the documentation there for more information.

Installation details
--------------------

* resource-server, auth-server, self-administration
* full postgres as backing service already installed
* default sample data included

Use the image
--------------

Run with:
    
    docker run -it -p 8080:8080 -p 5432:5432 osiam-docker_osiam-dev

or in daemon mode with:

    docker run -d -p 8080:8080 -p 5432:5432 osiam-docker_osiam-dev

This will also bind ports 8080 (tomcat) and 5432 (postgres) on the docker host. Access database with

    ong:b4s3dg0d
    
access OSIAM with

    marissa:koala

See [Next Steps](https://github.com/osiam/server/wiki/detailed_reference_installation#next-steps) chapter in official docs how to use OSIAM.

Stuff that does not work (TODOs)
--------------------------------

* sending emails (register, change email)
* convenient retrieval of server logs
* persisting data in external bind-mounted volume
* externalizing configuration in external bind-mounted volume
* automatically pushing the image to the docker index 
* using the puppet module for easy installation
