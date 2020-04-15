docker network create elastic_net

(another tab)
docker container run -it --rm --name elastic1 --network elastic_net --network-alias search elasticsearch:2

(another tab)
docker container run -it --rm --name elastic2 --network elastic_net --network-alias search elasticsearch:2

(back to the first tab)
docker container run -it --rm --network elastic_net alpine nslookup search
(should list 2 containers)
docker container run -it --rm --network elastic_net centos curl -s search:9200
(running multiple times should resolve different containers)