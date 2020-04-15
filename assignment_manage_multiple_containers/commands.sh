docker container run --publish 3306:3306 --detach --env MYSQL_RANDOM_ROOT_PASSWORD=yes --name db mysql
docker container run --publish 8080:80 --detach --name webserver httpd
docker container run --publish 80:80 --detach --name proxy nginx