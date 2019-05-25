
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





















