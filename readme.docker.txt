

5/6/2019

//build app jar
mvn clean package

//build docker image, need to run as root
docker build . -t rest-example

Sending build context to Docker daemon  31.75MB
Step 1/4 : FROM jeanblanchard/java:8
8: Pulling from jeanblanchard/java
6c40cc604d8e: Pull complete
93e89d51b14f: Pull complete
11bc4328183c: Pull complete
Digest: sha256:68ec59e0a735d1e0264b43cdba655509da2370b051ad03f18fa53eeb17ae5be8
Status: Downloaded newer image for jeanblanchard/java:8
 ---> 1a7a055a6252
Step 2/4 : COPY target/rest-example-0.1.0.jar rest-example-0.1.0.jar
 ---> 5e3b415ea37f
Step 3/4 : CMD java -jar rest-example-0.1.0.jar
 ---> Running in be2d394ed652
Removing intermediate container be2d394ed652
 ---> b7b0c43095d1
Step 4/4 : EXPOSE 8080
 ---> Running in 856dcd7df8b8
Removing intermediate container 856dcd7df8b8
 ---> 50ffc20eba6c
Successfully built 50ffc20eba6c
Successfully tagged rest-example:latest
SECURITY WARNING: You are building a Docker image from Windows against a non-Windows Docker host. All files and directories added to build context will have '-rwxr-xr-x' permissions. It is recommended to double check and reset permissions for sensitive files and directories.


//show images
docker images     (or docker image ls)
REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
rest-example               latest              50ffc20eba6c        7 minutes ago       195MB
ubuntu                     latest              d131e0fa2585        9 days ago          102MB
tomcat                     latest              5a069ba3df4d        3 weeks ago         465MB
busybox                    latest              af2f74c517aa        4 weeks ago         1.2MB
jeanblanchard/java         8                   1a7a055a6252        2 months ago        164MB
hello-world                latest              fce289e99eb9        4 months ago        1.84kB
docker4w/nsenter-dockerd   latest              2f1c802f322f        6 months ago        187kB


//run the image
docker run -it rest-example

//list running containers in another console
docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
904be5970e0e        rest-example        "/bin/sh -c 'java -j"   3 minutes ago       Up 3 minutes        8080/tcp            silly_euler

//try to list books from running container
curl http://localhost:8080/books
curl: (7) Failed to connect to localhost port 8080: Connection refused         //the container port 8080 is not mapped to localhost port yet


//stop container
docker stop 904be5970e0e
904be5970e0e


//run and map the container
docker run -it --name rest-example-container -p 8080:8080 rest-example


//list containers
docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
0b76e48d7161        rest-example        "/bin/sh -c 'java -j"   17 seconds ago      Up 16 seconds       0.0.0.0:8080->8080/tcp   rest-example-container

//try to list books from running container
curl http://localhost:8080/books
[]

//add a book
curl -H "Content-Type:application/json" -X POST http://localhost:8080/books -d "{\"id\":1,\"author\":\"Krochmalski\", \"title\":\"IDEA\"}"
{"id":1,"author":"Krochmalski","title":"IDEA"}

//try to list books from running container
curl http://localhost:8080/books
[{"id":1,"author":"Krochmalski","title":"IDEA"}]

=========================================================

5/6/2019 

//delegating the build process to the Docker daemon itself, failed

//clean up local jars
mvn clean

//build image, takes much longer time
docker build -f Dockerfile2 . -t rest-example2

Sending build context to Docker daemon  57.34kB
Step 1/8 : FROM java:8
 ---> d23bdf5b1b1b
Step 2/8 : RUN apt-get update
 ---> Running in e4c379f9a018
Get:1 http://security.debian.org jessie/updates InRelease [44.9 kB]
Ign http://deb.debian.org jessie InRelease
Get:2 http://deb.debian.org jessie-updates InRelease [7340 B]
Ign http://deb.debian.org jessie-backports InRelease
Get:3 http://deb.debian.org jessie Release.gpg [2420 B]
Ign http://deb.debian.org jessie-backports Release.gpg
Get:4 http://deb.debian.org jessie Release [148 kB]
Ign http://deb.debian.org jessie-backports Release
Err http://deb.debian.org jessie-backports/main amd64 Packages

Get:5 http://security.debian.org jessie/updates/main amd64 Packages [832 kB]
Err http://deb.debian.org jessie-backports/main amd64 Packages

Err http://deb.debian.org jessie-backports/main amd64 Packages

Get:6 http://deb.debian.org jessie/main amd64 Packages [9098 kB]
Err http://deb.debian.org jessie-backports/main amd64 Packages
  404  Not Found
Fetched 10.1 MB in 19s (507 kB/s)
W: Failed to fetch http://deb.debian.org/debian/dists/jessie-updates/InRelease  Unable to find expected entry 'main/binary-amd64/Packages' in Release file (Wrong sources.list entry or malformed file)

W: Failed to fetch http://deb.debian.org/debian/dists/jessie-backports/main/binary-amd64/Packages  404  Not Found

E: Some index files failed to download. They have been ignored, or old ones used instead.
The command '/bin/sh -c apt-get update' returned a non-zero code: 100

======================

5/6/2019
//Use maven to build image

//remove image
docker rmi rest-example

//build image without Dockerfile (rename Dockerfile to Dockerfile_orig)
//It generates Dockerfile in target/docker/rest-example/0.1.0/build
mvn clean package docker:build

//list images
docker images
REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
rest-example               0.1.0               a481db440fa7        40 seconds ago      501MB

//remove image
docker rmi a481db440fa7

=============================

//run container with image created with maven
docker run -it --name rest-example-container -p 8080:8080 rest-example:0.1.0
   Caused by: java.lang.ClassNotFoundException: javax.xml.bind.JAXBException

================================

5/8/2019

//Fabric8 Docker Maven plugin
//run container with image created with maven using maven, run app in background
mvn clean package docker:start

//list containers
docker ps -a
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS                          PORTS               NAMES
e65a2ca19d5e        rest-example:0.1.0   "/bin/sh -c 'java -j"   2 minutes ago       Exited (1) About a minute ago                       objective_ellis


//check logs
docker logs e65a2ca19d5e
   Caused by: java.lang.ClassNotFoundException: javax.xml.bind.JAXBException
   
mvn docker:stop

//run app interactively
mvn clean package docker:run
   Caused by: java.lang.ClassNotFoundException: javax.xml.bind.JAXBException
   
//solution to the above error, add below dependency to pom.xml
<dependency>
     <groupId>javax.xml.bind</groupId>
     <artifactId>jaxb-api</artifactId>
     <version>2.3.0</version>
</dependency>


mvn clean package docker:build
mvn clean package docker:start
docker ps
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                    NAMES
b5cfa0880852        rest-example:0.1.0   "/bin/sh -c 'java -j"   13 seconds ago      Up 12 seconds       0.0.0.0:8080->8080/tcp   happy_nobel

curl http://localhost:8080/books
[]

mvn docker:stop

mvn clean package docker:run
docker ps
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                    NAMES
13f6582a3e66        rest-example:0.1.0   "/bin/sh -c 'java -j"   22 seconds ago      Up 20 seconds       0.0.0.0:8080->8080/tcp   trusting_shirley

curl http://localhost:8080/books
[]

mvn docker:stop

===========================

