#first, test that the registry image is working correctly
docker container run -d -p 5000:5000 --name registry registry
docker container ls
docker image ls

#Typically we work with images from Docker Store, so this:
docker pull hello-world
#is the same as 'docker pull docker.io/hello-world:latest'
#If a tag isn’t specified, then the default latest is used. 
#If a registry hostname isn’t specified then the default docker.io for Docker Store is used.

#These commands pull a public image from Docker Store, tag it for use in the private registry
docker tag hello-world 127.0.0.1:5000/hello-world
#and then push it to the registry
docker push 127.0.0.1:5000/hello-world

#remove that image from local cache and pull it from new registry
docker image rm -f hello-world
docker image rm -f 127.0.0.1:5000/hello-world
docker pull 127.0.0.1:5000/hello-world

#Remove the existing registry container by removing the container which holds the storage layer
docker container kill registry
docker container rm registry

#re-create registry using a bind mount and see how it stores data
docker container run -d -p 5000:5000 --name registry -v $(pwd)/registry-data:/var/lib/registry registry
docker push 127.0.0.1:5000/hello-world
ll registry-data
tree registry-data

# on macOS, if the insecure registry (HTTP) is running on any other machine, the docker engine has to be changed.
# Go to Preferences > Docker Engine and this will be the default json:
# {
#   "debug": true,
#   "experimental": false
# }
# add this line to set the insecure registry address:
# ,"insecure-registries" : ["myregistrydomain.com:5000"]

#COMPLETE TUTORIAL TO SETUP A SECURE REGISTRY:
#https://training.play-with-docker.com/linux-registry-part1/
#https://training.play-with-docker.com/linux-registry-part2/