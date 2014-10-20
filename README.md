OSIAM Docker Image
==================

This project builds a docker image with OSIAM installed and configured ready to 
use for development purposes. **WARNING:** This image is for development purposes 
only! Do not even think about using it in a production-like environment!

Installation details
--------------------

* includes resource-server, auth-server, addon-self-administration, addon-administration
* full postgres database already installed
* default sample data included

Use the image
--------------

Run with:

    $ docker run -i -t -p 8080:8080 -p 5432:5432 osiamorg/osiam:1.2

or in daemon mode with:

    $ docker run -d -p 8080:8080 -p 5432:5432 osiamorg/osiam:1.2

This will bind ports 8080 (tomcat) and 5432 (postgres) on the docker host.
Access database with

    ong:b4s3dg0d

access OSIAM with

    marissa:koala

See [Next Steps](https://github.com/osiam/server/wiki/detailed_reference_installation#next-steps)
chapter in official docs how to use OSIAM.

Build
-----

Build image with:

    $ ./build

Stuff that does not work (TODOs)
--------------------------------

* setting db password and other security stuff on run
* sending emails (register, change email)
* convenient retrieval of server logs
* persisting data in external bind-mounted volume
* externalizing configuration in external bind-mounted volume
* automatically pushing the image to the docker index 
* using the puppet module for easy installation
* making image suitable for production deployment
