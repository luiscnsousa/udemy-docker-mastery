#to setup a docker registry in a docker swarm use this:
#https://labs.play-with-docker.com/
#click on the wrench and choose 'X managers and no workers'
#or swarm cluster in aws
docker node ls

#since we're running a swarm, a container on just one of the managers just won't do
#we have to create a service. This way all nodes can reach it to push a pull images from.
#and thanks to the routing mesh, all nodes can see 127.0.0.1:5000 
docker service create --name registry --publish 5000:5000 registry
docker service ps registry

#if using play-with-docker, everytime a port is exposed, like with the previous command
#a new link appear above the console with a button that when clicked, opens a url with the service
#http://ip172-18-0-68-bqov0g2osm4g00di8mqg-5000.direct.labs.play-with-docker.com/
#concat 'v2/_catalog' at the end to get a json response with the current repositories

docker pull hello-world
docker tag hello-world 127.0.0.1:5000/hello-world
docker push 127.0.0.1:5000/hello-world

#refreshing the url http://ip172-18-0-68-bqov0g2osm4g00di8mqg-5000.direct.labs.play-with-docker.com/v2/_catalog
#will show something like this: {"repositories":["hello-world"]}

#NOW to create a service with an image from the local registry:
docker pull nginx
docker tag nginx 127.0.0.1:5000/nginx
docker push 127.0.0.1:5000/nginx
docker service create --name nginx -p 80:80 --replicas 5 --detach=false 127.0.0.1:5000/nginx
docker service ls
docker service ps nginx

#after this a new port will also appear above the console in play-with-docker to access the new service on port 80