### game of life document
* write docker file for game of life
```Dockerfile
  FROM tomcat:8-jdk8
  EXPOSE 8080
  ADD https://referenceapplicationskhaja.s3.us-west-2.amazonaws.com/gameoflife.war /usr/local/tomcat/webapps/gameoflife.war
  CMD ["catalina.sh", "run"]
```
* build docker image for gol using below command
`docker image build -t gol:1.0 .`
* After image build we run container
`docker container run -d -P gol:1.0`
* after image build then push that image to docker hub
* before image push we tag them that image
* docker image tag <image-name> dockerhubusername/<image-name>
   `docker image tag gol ruchithakomali/gol`
* docker image push
  * docker image push dockerhubusername/<image-name>
  * `docker image push ruchithakomali/gol:1.0 `
* After start deployment in K8s
* we write k8s deployment manifest file
``` yml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-gol-deploy
spec:
  minReadySeconds: 5
  replicas: 2
  selector:
    matchLabels:
      app: gol
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25
      maxUnavailable: 25
  template:
    metadata:
      name: gol-pod
      labels:
        app: gol
    spec:
      containers:
        - name: my-gol
          image: ruchithakomali/gol:1.0
          ports:
            - containerPort: 8080
          command:
            - catalina.sh
            - run
            - 0.0.0.0:8080
```
* Write a service file for deployment
```yml
---
apiVersion: v1
kind: Service
metadata:
  name: my-gol-svc
spec:
  type: LoadBalancer
  selector:
    app: gol
  ports:
    - name: webport
      port: 8080
      targetPort: 8080
```
* in k8s write command
 `kubectl apply -f gol.yml`
 `kubectl get svc`
* After its showing cluster ip