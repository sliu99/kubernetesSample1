#/bin/sh
echo "Sam"
mvn clean package
docker build . -t rest-example
