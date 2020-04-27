echo "--------"
echo "networks"
echo "--------"
docker network create \
    --driver overlay \
    backend

docker network create \
    --driver overlay \
    frontend

docker network ls

echo "--------"
echo "services"
echo "--------"
docker service create \
    --name vote \
    --network frontend \
    --replicas 3 \
    -p 80:80 \
    bretfisher/examplevotingapp_vote

docker service create \
    --name redis \
    --network frontend \
    redis:3.2

docker service create \
    --name worker \
    --network frontend \
    --network backend \
    bretfisher/examplevotingapp_worker:java

docker service create \
    --name db \
    --network backend \
    -e POSTGRES_HOST_AUTH_METHOD=trust \
    --mount type=volume,source=db-data,target=/var/lib/postgresql/data \
    postgres:9.4

docker service create \
    --name result \
    --network backend \
    -p 5001:80 \
    bretfisher/examplevotingapp_result

docker service ls
docker service ps vote redis worker db result
#watch docker service ls
#docker service inspect {serviceName}
#docker service logs {serviceName}
