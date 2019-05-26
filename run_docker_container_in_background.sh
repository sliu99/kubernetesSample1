#/bin/sh
echo "Sam"
mvn clean package
docker build . -t rest-example
docker run -d --name rest-example-container -p 8080:8080 rest-example
