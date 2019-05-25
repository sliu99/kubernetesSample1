
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

