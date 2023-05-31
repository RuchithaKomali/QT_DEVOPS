### open mrs
* launch ubuntu instance
* Write Dockerfile for Openmrs core
```Dockerfile
FROM maven:3-jdk-8 as mavenbuild
RUN git clone https://github.com/srvarri/openmrs-core.git && \
    cd openmrs-core/ && \
    mvn package
# Dockerfile ,,,openmrs run i,e stage-2
#war file location: /openmrs/openmrs-core/target/openmrs.war
FROM tomcat:8-jdk8
LABEL author="Ruchithakomali"
EXPOSE 8080
VOLUME /root/.OpenMRS
COPY --from=mavenbuild /openmrs-core/webapp/target/openmrs.war /usr/local/tomcat/webapps/openmrs.war
CMD ["catalina.sh", "run"]
```
* After build the image
`docker image build -t openmrscore:1.0 .`
* Run the container
` $ docker container run -d -P openmrscore:1.0 `
* tag them that image
* docker image tag <image-name> dockerhubusername/<image-name>
   `docker image tag openmrscore:1.0 ruchithakomali/openmrscore`
* docker image push
  * docker image push dockerhubusername/<image-name>
  * `docker image push ruchithakomali/openmrscore`