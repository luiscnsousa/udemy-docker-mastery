# consider StatefulSets when considering databases in Kubernetes

# there are 2 types of volumes: 
# - Volumes, tied to the lifecycle of a Pod
# - PersistentVolumes, created at the cluster level and outlive a Pod

# Ingress feature in Kubernetes acts like a reverse HTTP proxy (still beta in 1.15)
# so to route outside connections based on hostname or url: Ingress Controllers
# (which is not installed in kubernetes by default) there are many 3rd party proxies like:
# Nginx, Traefik (probably the best option), HAProxy, etc
# Implementation is specific to the chose controller

# CRDs (Custom Resource Definition) and the operator pattern
# its possible to add 3rd Resources and Controllers that extend the API and CLI
# Operator: automate deployment and management of complex apps (Prometheus i.e.)
# CRDs is great for backups, databases, logging, monitoring and tracing for example. 
# Don't use it unnecessarily because it adds complexity to the command line. 

# (optional) Higher deployment abstractions 
# 'Helm' is the most popular for large production systems (Helm charts to setup Prometheus i.e.)
# 'Compose on Kubernetes' comes with Docker Desktops and it translates stacks (swarm) to Kubernetes
# (has to be inabled in Docker Desktop, to use Kubernetes as the default orchestrator)
# Kustomize is newer, but Helm is still the king for this

# Kubernetes Dashboard (default GUI for "upstream" Kubernetes)
# https://gihub.com/kubernetes/dashboard
# Some distributions have their own GUI (Rancher, Docker Enterprise, OpenShift)
# when working with cloud providers (AWS i.e.) its easier to just use their Kubernetes 
# which is already automated, but doesn't come with a dashboard, so installing this would be great
# CAUTION: do not expose this on a common port to the outside. Restrict access for a particular IP or add authentication

# Namespaces in Kubernetes limit scope (like virtual clusters)
# when running the following command, the default Kubernetes namespaces are displayed
kubectl get namespaces
# so to get all those default pods, replica sets, deployments and services managing the cluster:
kubectl get all --all-namespaces
# notice the pods for CoreDNS, etcd and others, all of them have the namespace 'kube-system'
# and this is why 'kubectl get pods' (i.e.) does not return any of these, its using the 'default' namespace

# Context changes kubectl cluster and namespace 
# ~/.kube/config
# instead of using 'cat' to get these configs, there's this command:
kubectl config get-contexts
# there may be 2 lines for docker-desktop and docker-for-desktop because they changed the name
# and kept the previous for retrocompatibility
# It is also possible to change this file with any of the set options:
# kubectl config set*
# To explore later:
# there are plugins for the command line like the one for git that prints the current branch 
# for kubernetes, it will print the current context

