echo "-----------"
echo "setup swarm"
echo "-----------"
#./../docker-machine-swarm/setup_swarm_cluster_aws.sh

echo "--------------------"
echo "setup docker-machine"
echo "--------------------"
docker-machine env swarm-aws1
eval $(docker-machine env swarm-aws1)

echo "--------------"
echo "create secrets"
echo "--------------"
#in the next command, the dash in the end tells the command to read from the stdin
echo "pass" | docker secret create psql-pw -
docker secret ls
docker secret inspect psql-pw

echo "------------"
echo "deploy stack"
echo "------------"
docker stack deploy -c docker-compose.yml drupal-stack
docker stack ls
docker stack ps drupal-stack
docker stack services drupal-stack

#DRUPAL SHOULD BE AVAILABLE AT {PublicIPv4}:8080 
#THE DATABASE SETUP SHOULD BE:
#database: drupal
#user: user
#pass: pass
#host: postgres

#TO SEE THE SECRET IN PLAIN TEXT:

# #we first need to find out the node where the postgres service/container is running
# docker stack ps drupal-stack
# #in this case was node 3
# docker-machine env swarm-aws3
# eval $(docker-machine env swarm-aws3)
# docker service ps drupal-stack_postgres
# #get the container name
# docker container ls 
# docker exec -it drupal-stack_postgres.1.jlmfm9ec9b8pdi0r7sdzqldv0 bash
# cd /run/secrets/
# cat psql-pw





