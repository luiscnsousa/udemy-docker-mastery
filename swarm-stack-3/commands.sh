#LOCAL DEVELOPMENT ENVIRONMENT
docker-compose up -d
#this command will automatically pickup docker-compose.yml and docker-compose.override.yml

#now to find the name of the container running drupal:
docker container ls
docker inspect swarm-stack-3_drupal_1
#the fact that it has Mounts is proof that the override file was taken into account

#CI ENVIRONMENT
docker-compose -f docker-compose.yml -f docker-compose.test.yml up -d

#this time there are no mounts because we want to throw everything away in the end of a CI run
docker inspect swarm-stack-3_drupal_1

#PRODUCTION ENVIRONMENT
#since there is no docker-compose in production (because its not a production tool), 
#the deploy has to be done via "docker stack deploy" command, so first we have to combine the compose files
docker-compose -f docker-compose.yml -f docker-compose.prod.yml config
#the previous command shows the result, this one writes to a new yml file
docker-compose -f docker-compose.yml -f docker-compose.prod.yml config > output.yml

#and then, use the output.yml file in the docker stack deploy command
docker stack deploy -c output.yml drupal-stack