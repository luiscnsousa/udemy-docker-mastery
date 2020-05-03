#HEALTHCHECKS
# 0 - OK
# 1 - NOK

#containers states: 
# - starting
# - healthy
# - unhealthy

#services states: 
# - preparing (downloading the image)
# - starting (executing the container)
# - running 
#PS: without a heathcheck, it changes from starting to running very quickly
# with a healthcheck, it will wait for the first healthcheck (30s by default)

#this command will show the status of the last healthcheck
docker container ls

#this command will show the last 5 healthchecks
docker container inspect {container}

#docker will not take action according to healthchecks, but services will catch that NOK 
#and fire another task to run another container, possibly in a different node


#HEALTHCHECK example in a docker run command
#PS: the '|| false' and '|| exit 1' portions of the health-cmd examples bellow do exactly the same
docker run \
    --health-cmd="curl -f localhost:9200/_cluster/health || false" \
    --health-interval=5s \
    --health-retries=3 \
    --health-timeout=2s \
    --health-start-period=15s \
    elasticsearch:2

docker container run --name p1 -d --health-cmd="pg_isready -U postgres || exit 1" postgres


#HEALTHCHECK example in a docker service command
docker service create --name p1 --health-cmd="pg_isready -U postgres || exit 1" postgres


#HEALTHCHECK example in a Dockerfile
#PS: different application might have different healthchecking methods like nginx and postgres examples bellow
FROM nginx:1.13

HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/ || exit 1

#----------------

FROM postgres

HEALTHCHECK --interval=5s --timeout=3s \
    CMD pg_isready -U postgres || exit 1


#HEALTHCHECK example in a compose file
version: '2.1' #minimum for healthchecks WITHOUT start_period
services:
    web:
        image: nginx
        healthcheck:
            test: ["CMD", "curl", "-f", "http://localhost"]
            interval: 1m30s
            timeout: 10s
            retries: 3
            start_period: 1m #requires version 3.4 in compose file