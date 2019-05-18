
cd D:\book_code\book_code2016\docker_and_kubernetes_for_java_developers_2017\Docker-and-Kubernetes-for-Java-Developers-master\rest-example-master

mvn clean package

mvn spring-boot:run


curl http://localhost:8080/api/v1/namespaces/default/pods
{"timestamp":1556843791600,"status":404,"error":"Not Found","message":"No messag
e available","path":"/api/v1/namespaces/default/pods"}



curl -H "Content-Type: application/json" -X POST -d '{"id":"1","author":"Krochmalski", "title":"IDEA"}'  http://localhost:8080/books
{"timestamp":1556843791600,"status":404,"error":"Not Found","message":"No messag
e available","path":"/api/v1/namespaces/default/pods"}
D:\temp>curl -H "Content-Type: application/json" -X POST -d '{"id":"1","author":
"Krochmalski", "title":"IDEA"}'  http://localhost:8080/books
curl: (3) [globbing] unmatched close brace/bracket in column 11
{"timestamp":1556843865540,"status":400,"error":"Bad Request","exception":"org.s
pringframework.http.converter.HttpMessageNotReadableException","message":"Could
not read document: Unexpected character (''' (code 39)): expected a valid value
(number, String, array, object, 'true', 'false' or 'null')\n at [Source: java.io
.PushbackInputStream@165cbf74; line: 1, column: 2]; nested exception is com.fast
erxml.jackson.core.JsonParseException: Unexpected character (''' (code 39)): exp
ected a valid value (number, String, array, object, 'true', 'false' or 'null')\n
 at [Source: java.io.PushbackInputStream@165cbf74; line: 1, column: 2]","path":"
/books"}



curl -s http://localhost:8080/api/v1/namespaces/default/services -XPOST -H 'Content-Type: application/json' -d@service.json
{"timestamp":1556844125976,"status":404,"error":"Not Found","message":"No messag
e available","path":"/api/v1/namespaces/default/services"}<html>
<head><title>301 Moved Permanently</title></head>
<body bgcolor="white">
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx</center>
</body>
</html>


curl -s http://localhost:8080/apis/extensions/v1beta1/namespaces/default/deployments -XPOST -H 'Content-Type: application/json' -d@deployment.json
{"timestamp":1556844188026,"status":404,"error":"Not Found","message":"No messag
e available","path":"/apis/extensions/v1beta1/namespaces/default/deployments"}<h
tml>
<head><title>301 Moved Permanently</title></head>
<body bgcolor="white">
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx</center>
</body>
</html>



https://192.168.99.100:8443/api/v1/namespaces/default/pods
curl http://localhost:8080/api/v1/namespaces/default/pods
{"timestamp":1556844249732,"status":404,"error":"Not Found","message":"No messag
e available","path":"/api/v1/namespaces/default/pods"}

=====================================

5/5/2019

//find all books, work
curl http://localhost:8080/books
[]

//use postman for POST works

//not work, single quote does not work in windows
curl -H "Content-Type: application/json" -X POST -d '{"id":1,"author":"Krochmalski", "title":"IDEA"}'  http://localhost:8080/books
//add a book, work
curl -H "Content-Type:application/json" -X POST http://localhost:8080/books -d "{\"id\":1,\"author\":\"Krochmalski\", \"title\":\"IDEA\"}" 

//work
curl  -XPOST http://localhost:8080/books -H "Content-Type: application/json" -d@book2.json



//find a book, work
curl http://localhost:8080/books/1

//delete a book, work
curl -H "Content-Type:application/json" -X DELETE http://localhost:8080/books/1

//getBooks, findBook, saveBook, deleteBook work in postman

=========================

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

5/12/2019
install minikube see /home/sliu/docs/kubernetes/urls_minikube.txt

$ mvn clean package docker:build
[ERROR] Failed to execute goal io.fabric8:docker-maven-plugin:0.20.1:build (default-cli) on project rest-example: Execution default-cli of goal io.fabric8:docker-maven-plugin:0.20.1:build failed: No <dockerHost> given, no DOCKER_HOST environment variable, no read/writable '/var/run/docker.sock' or '//./pipe/docker_engine' and no external provider like Docker machine configured -> [Help 1]

In root's .profile, add env and path as those in sliu's .profile.
# mvn clean package docker:build

# docker images
REPOSITORY                                 TAG                 IMAGE ID            CREATED             SIZE
rest-example                               0.1.0               8871ece5bdfd        6 seconds ago       501MB

# docker ps
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                    NAMES
a9ba87646131        rest-example:0.1.0   "/bin/sh -c 'java -j…"   28 seconds ago      Up 25 seconds       0.0.0.0:8080->8080/tcp   focused_mayer


In another console
# curl http://localhost:8080/books
[]

Right now, every thing is using root, idealy it should be able to use sliu.

================================================

5/13/2019

# minikube status				
# minikube stop					//sometimes may take a while
# minikube delete                                  //may need to delete .minikube dir
# minikube start				//takes about 15 minutes
Starting local Kubernetes v1.10.0 cluster...
Starting VM...
Getting VM IP address...
Moving files into cluster...
Setting up certs...
Connecting to cluster...
Setting up kubeconfig...
Starting cluster components...
Kubectl is now configured to use the cluster.
Loading cached images from config file.


# minikube status
minikube: Running
cluster: Running
kubectl: Correctly Configured: pointing to minikube-vm at 192.168.99.100

# minikube version
minikube version: v0.28.2

# kubectl api-versions

# minikube dashboard
Waiting, endpoint for service is not ready yet...
Running Firefox as root in a regular user's session is not supported.
Solution1: https://askubuntu.com/questions/1037052/running-firefox-as-root-in-a-regular-users-session-is-not-supported-xauthori
Solution2(remote access)
https://stackoverflow.com/questions/47173463/how-to-access-local-kubernetes-minikube-dashboard-remotely
curl http://192.168.99.100:30000
https://stackoverflow.com/questions/36270602/how-to-access-kubernetes-ui-via-browser
https://stackoverflow.com/questions/39864385/how-to-access-expose-kubernetes-dashboard-service-outside-of-a-cluster
https://stackoverflow.com/questions/47173463/how-to-access-local-kubernetes-minikube-dashboard-remotely/52445657#52445657

# kubectl version
Client Version: version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.1", GitCommit:"b7394102d6ef778017f2ca4046abbaa23b88c290", GitTreeState:"clean", BuildDate:"2019-04-08T17:11:31Z", GoVersion:"go1.12.1", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"10", GitVersion:"v1.10.0", GitCommit:"fc32d2f3698e36b93322a3465f63a14e9f0eaead", GitTreeState:"clean", BuildDate:"2018-03-26T16:44:10Z", GoVersion:"go1.9.3", Compiler:"gc", Platform:"linux/amd64"}


# kubectl get nodes     //a node minikube run in virtualbox vm
NAME       STATUS   ROLES    AGE   VERSION
minikube   Ready    master   3m    v1.10.0

//create service in kubernetes
# kubectl create -f service.yaml
service/rest-example created

# kubectl get services
NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
kubernetes     ClusterIP   10.96.0.1       <none>        443/TCP          1h
rest-example   NodePort    10.98.115.130   <none>        8080:30751/TCP   1m

# kubectl get services --all-namespaces
NAMESPACE     NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
default       kubernetes             ClusterIP   10.96.0.1       <none>        443/TCP          1h
default       rest-example           NodePort    10.98.115.130   <none>        8080:30751/TCP   3m
kube-system   kube-dns               ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP    1h
kube-system   kubernetes-dashboard   NodePort    10.96.41.213    <none>        80:30000/TCP     1h

# kubectl describe service rest-example
Name:                     rest-example
Namespace:                default
Labels:                   app=rest-example
                          tier=backend
Annotations:              <none>
Selector:                 app=rest-example,tier=backend
Type:                     NodePort
IP:                       10.98.115.130
Port:                     <unset>  8080/TCP
TargetPort:               8080/TCP
NodePort:                 <unset>  30751/TCP
Endpoints:                <none>
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>

//Create a deployment
Before creating a deployment, we need to have our Docker image ready and published to a registry, the same as the Docker Hub for example.

//push rest-example image into the DockerHub registry.
# docker login         //sliu99/Bluebird1957)

# docker images
REPOSITORY                                 TAG                 IMAGE ID            CREATED             SIZE
rest-example                               0.1.0               8871ece5bdfd        3 hours ago         501MB

# docker tag 8871ece5bdfd sliu99/rest-example

# docker push sliu99/rest-example
The push refers to repository [docker.io/sliu99/rest-example]
f67db482ec37: Pushed 
fcd6896eecf1: Mounted from library/openjdk 
2666aafcfdd9: Mounted from library/openjdk 
c4a7cf6a6169: Mounted from library/openjdk 
latest: digest: sha256:8dff76d94c120a288c7609ecf0b44389627bd6bc4e1d4b2648cc45bbaa11da0e size: 1165

//search in remote docker hub (https://hub.docker.com)
# docker search sliu99
NAME                           DESCRIPTION         STARS               OFFICIAL            AUTOMATED
sliu99/imageforhub                                 0                                       
sliu99/dockerfileimageforhub                       0                                       
sliu99/parse-server                                0                                       
sliu99/rest-example                                0 

//create deployment
# kubectl create -f deployment.yaml
deployment.extensions/rest-example created

# kubectl get deployments
NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
rest-example   1         1         1            0           55s

# kubectl describe deployment rest-example
Name:                   rest-example
Namespace:              default
CreationTimestamp:      Mon, 13 May 2019 08:39:34 -0700
Labels:                 app=rest-example
                        tier=backend
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=rest-example,tier=backend
Replicas:               1 desired | 1 updated | 1 total | 0 available | 1 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
Pod Template:
  Labels:  app=rest-example
           tier=backend
  Containers:
   rest-example:
    Image:      sliu99/rest-example
    Port:       8080/TCP
    Host Port:  0/TCP
    Requests:
      cpu:     100m
      memory:  100Mi
    Environment:
      GET_HOSTS_FROM:  dns
    Mounts:            <none>
  Volumes:             <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    ReplicaSetUpdated
OldReplicaSets:  <none>
NewReplicaSet:   rest-example-8447b654f4 (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  2m1s  deployment-controller  Scaled up replica set rest-example-8447b654f4 to 1


# kubectl get pods
NAME                            READY   STATUS              RESTARTS   AGE
rest-example-8447b654f4-hr2v9   0/1     ContainerCreating   0          3m


# kubectl describe pod rest-example-8447b654f4-hr2v9
Name:           rest-example-8447b654f4-hr2v9
Namespace:      default
Node:           minikube/10.0.2.15
Start Time:     Mon, 13 May 2019 08:39:46 -0700
Labels:         app=rest-example
                pod-template-hash=4003621090
                tier=backend
Annotations:    <none>
Status:         Pending
IP:             
Controlled By:  ReplicaSet/rest-example-8447b654f4
Containers:
  rest-example:
    Container ID:   
    Image:          sliu99/rest-example
    Image ID:       
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       ContainerCreating
    Ready:          False
    Restart Count:  0
    Requests:
      cpu:     100m
      memory:  100Mi
    Environment:
      GET_HOSTS_FROM:  dns
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-z5452 (ro)
Conditions:
  Type           Status
  Initialized    True 
  Ready          False 
  PodScheduled   True 
Volumes:
  default-token-z5452:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-z5452
    Optional:    false
QoS Class:       Burstable
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason                 Age    From               Message
  ----    ------                 ----   ----               -------
  Normal  Scheduled              5m1s   default-scheduler  Successfully assigned rest-example-8447b654f4-hr2v9 to minikube
  Normal  SuccessfulMountVolume  5m     kubelet, minikube  MountVolume.SetUp succeeded for volume "default-token-z5452"
  Normal  Pulling                4m45s  kubelet, minikube  pulling image "sliu99/rest-example"



To be able to execute the service from the outside world, we have used the NodePort mapping,
and we know that is was given the port 30751, all we need to call the service is the IP of the cluster.
We can get it using the following command:
# minikube ip
192.168.99.100

//get externally accessible service URL
# minikube service rest-example --url
http://192.168.99.100:30751

# curl http://192.168.99.100:30751/books
[]

//add a book
curl -H "Content-Type:application/json" -X POST http://192.168.99.100:30751/books -d "{\"id\":1,\"author\":\"Krochmalski\", \"title\":\"IDEA\"}"
{"id":1,"author":"Krochmalski","title":"IDEA"}

//try to list books from running container
curl http://192.168.99.100:30751/books
[{"id":1,"author":"Krochmalski","title":"IDEA"}


===================================

5/13/2019
Interacting with containers and viewing logs

//access pod log
# kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
rest-example-8447b654f4-ctv4r   1/1     Running   0          7m


//show log for a pod
# kubectl logs rest-example-8447b654f4-ctv4r

//to get a shell to the running container
# kubectl exec -it rest-example-8447b654f4-ctv4r -- /bin/bash

//open a shell for a container (myContainer) in the pod
# kubectl exec -it rest-example-8447b654f4-ctv4r -c myContainer -- /bin/bash



===================================

5/13/2019
Scaling manually
# kubectl get deployments
NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
rest-example   1         1         1            1           37m

# kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
rest-example-8447b654f4-ctv4r   1/1     Running   0          37m

# kubectl scale deployment rest-example --replicas=3
replicas=3
deployment.extensions/rest-example scaled

# kubectl get deployments
NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
rest-example   3         3         3            1           38m

# kubectl get pods


Clean up

# kubectl delete deployment rest-service

# kubectl delete service rest-service

# kubectl delete pod pod1


===================================

5/14/2019
Create service, deployment using api

//start a proxy to the api-server
# kubectl proxy --port=8080
Starting to serve on 127.0.0.1:8080

//check if api-server is running
# curl http://localhost:8080/api
{
  "kind": "APIVersions",
  "versions": [
    "v1"
  ],
  "serverAddressByClientCIDRs": [
    {
      "clientCIDR": "0.0.0.0/0",
      "serverAddress": "192.168.99.100:8443"
    }
  ]
}

//creating a service using the api
# curl -s http://localhost:8080/api/v1/namespaces/default/services -XPOST -H "Content-Type: application/json" -d@service.json

# kubectl get services
NAME           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
kubernetes     ClusterIP   10.96.0.1      <none>        443/TCP          3h
rest-example   NodePort    10.99.192.47   <none>        8080:32653/TCP   54s


//creating a deployment using the api
# curl -s http://localhost:8080/apis/extensions/v1beta1/namespaces/default/deployments -XPOST -H "Content-Type: application/json" -d@deployment.json


# kubectl get deployments
NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
rest-example   1         1         1            1           9m

# kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
rest-example-7f7f8b686b-w9wx6   1/1     Running   0          9m


# kubectl get pods -v6
I0513 21:27:45.208415   28904 loader.go:359] Config loaded from file /root/.kube/config
I0513 21:27:45.591482   28904 round_trippers.go:438] GET https://192.168.99.100:8443/api/v1/namespaces/default/pods?limit=500 200 OK in 335 milliseconds
I0513 21:27:45.651858   28904 get.go:570] no kind is registered for the type v1beta1.Table in scheme "k8s.io/kubernetes/pkg/api/legacyscheme/scheme.go:29"
NAME                            READY   STATUS    RESTARTS   AGE
rest-example-7f7f8b686b-w9wx6   1/1     Running   0          10m


Deleting a service and deployment
//delete deployment, not work
# curl http://localhost:8080/apis/extensions/v1beta1/namespaces/default/deployments/rest-example -XDELETE

//delete service, not work
# curl http://localhost:8080/apis/extensions/v1beta1/namespaces/default/services/rest-example -XDELETE

=========================================



















