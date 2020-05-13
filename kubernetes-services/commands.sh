# 'kubectl expose' command creates a service for existing pods
# but service in kubernetes is different from a service in swarm
# a service can be of type:
# - ClusterIP: single internal IP only valid inside the cluster
# - NodePort: (high number) port allocated on each node for anyone to connect
# (these first 2 are always available in kubernetes)
# - LoadBalancer: controls a LB endpoint external to the cluster (AWS ElasticLoadBalancer i.e.)
#  it creates a NodePort+ClusterIP services and tells LB to send to NodePort
# - ExternalName (not used very often) 
#  it allows the pods to access an external service - adds CNAME DNS record to CoreDNS


# using a dedicated terminal tab:
kubectl get pods -w

# in a different tab:
kubectl create deployment httpenv --image bretfisher/httpenv
kubectl scale deployment/httpenv --replicas=5
kubectl expose deployment/httpenv --port=8888 #clusterIP service by default
kubectl get service
# this will show at least 2, kubernetes (the API) and the httpenv
# since this is a ClusterIP service it is only accessible from inside the cluster (other pods)
# and kubernetes in docker desktop (windows or mac) runs in a linux virtual machine
# so we need to run another pod in the cluster and curl the endpoint from there:
kubectl run --generator run-pod/v1 tmp-shell --rm -it --image bretfisher/netshoot -- bash #space between '--' and 'bash' is required
curl httpenv:8888
# httpenv is the deployment name and the 8888 is the port in which the service was exposed
# curl will return: {"HOME":"/root","HOSTNAME":"httpenv-7cc9888d59-thtcr","KUBERNETES_PORT":"tcp://10.96.0.1:443","KUBERNETES_PORT_443_TCP":"tcp://10.96.0.1:443","KUBERNETES_PORT_443_TCP_ADDR":"10.96.0.1","KUBERNETES_PORT_443_TCP_PORT":"443","KUBERNETES_PORT_443_TCP_PROTO":"tcp","KUBERNETES_SERVICE_HOST":"10.96.0.1","KUBERNETES_SERVICE_PORT":"443","KUBERNETES_SERVICE_PORT_HTTPS":"443","PATH":"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"}
# in linux, since docker containers run natively in the host, it is possible to 'curl [ip_of_service]:8888' but not the name, that is only for inside the cluster

kubectl get all
kubectl expose deployment/httpenv --port 8888 --name httpenv-np --type NodePort
kubectl get service #there will be a service named httpenv-np with port '8888:XXXXX'
# in kubernetes its the other way around... the port 8888 is on the service and XXXXX is on the host
# now the host (mac) can access it on http://localhost:XXXXX/ or 'curl localhost:XXXXX'
# PS: creating a service of type NodePort also creates a ClusterIP, services are additive. So creating a LoadBalancer, will create a NodePort AND a ClusterIP.

# WHEN IN DOCKER DESKTOP, IT PROVIDES A BUILT-IN LOAD BALANCER THAT PUBLISHES THE --port ON LOCALHOST
kubectl expose deployment/httpenv --port 8888 --name httpenv-lb --type LoadBalancer
# so in this case, there is no generated port, the docker desktop will map it to 8888 on the host
curl localhost:8888
# other way to use this service type would be with AWS elastic load balancer
kubectl get service
# httpenv-lb will still show port '8888:XXXXX' because it also creates a NodePort and ClusterIP (additive)

# CLEANUP
kubectl delete \
    service/httpenv \
    service/httpenv-np \
    service/httpenv-lb \
    deployment/httpenv

# ----------------------------------------
# internal DNS in Kubernetes is provided by CoreDNS
# we've been doing 'curl <hostname>', but that is only possible inside the same namespace
# and by default there is a default namespace:
kubectl get namespace
# Services also have a FQDN:
# 'curl <hostname>.<namespace>.svc.cluster.local'
# when curling by the hostname, the default namespace is used
# it is not possible to create 2 pods/deployments/services with the same name in the same namespace
# but, when in different namespaces, the names can repeat, because of this FQDN.
# The 'svc.cluster.local' is the default name for a kubernetes cluster