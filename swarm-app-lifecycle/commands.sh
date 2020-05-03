
#common docker service command examples

#update the service with a newer image
docker service update --image myapp:1.2.1 {serviceName}

#add an environment variable and remove a port binding in the same update
docker service update --env-add NODE_ENV=production --publish-rm 8080

#change the number of replicas on multiple services at the same time
docker service scale web=8 api=6

#rollback a service
docker service rollback web

#with stacks using a yml file, its the same command after editing the yml
docker stack deploy -c {file.yml} {stackName}

#-----------------------------
#some more example commands

docker service create --name web -p 8088:80 nginx:1.13.7
docker service ls
docker service scale web=5
docker service update --image 1.13.6 web
docker service update --publish-rm 8088:80 --publish-add 9090:80 web

#sometimes the replicas are not evenly spread across all nodes, so
#THIS COMMAND IS USEFUL TO TRIGGER A REBALANCE!
docker service update --force web

docker service rm web