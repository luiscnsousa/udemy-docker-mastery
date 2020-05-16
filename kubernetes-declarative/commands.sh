# create/update resources in a file
kubectl apply -f filename.yaml

# create/update a whole directory of yaml files 
kubectl apply -f folder/

# list of resources the cluster supports (the KIND column goes into 'kind' element in yaml files)
kubectl api-resources
# there is also an important column named APIGROUP, which is a prefix for the api version in yaml file:
# - pods have no APIGROUP, so it would be just 'v1' in apiVersion
# - deployments have the APIGROUP app, so it would be 'apps/v1' in apiVersion
#  (there is also an older APIGROUP for deployments called 'extensions')

# the following command displays possible values for 'apiVersion' in yaml files
kubectl api-versions

# for the metadata part of the yaml file, only the name is required

# in 'k8s-yaml' folder of this repo, there are 3 example yaml files:
# pod.yaml
# deployment.yaml
# app.yaml (this one contains multiple resources and the '---' is required to separate them)

# ------------------ SPEC

# for the spec section the follwing command shows all the possible elements for a specific resource (Service in this case)
kubectl explain service --recursive

# but the previous command does not explain what each element is for, this one does
kubectl explain service.spec

# for a particular element inside spec, it is also possible to do:
kubectl explain service.spec.type
# ExternalName, ClusterIP, NodePort and LoadBalancer

# it is possible to go down many levels, like nfs server for volumes i.e.
kubectl explain deployment.spec.template.spec.volumes.nfs.server
# caution: the documentation on these commands may be outdated and mention an older apiVersion
#          it is better to use 'kubectl api-versions' command for that

# There is also the complete Kubernetes API documentation at:
# https://kubernetes.io/docs/reference/#api-reference

# ------------------ Dry runs and diffs this is still in beta (1.15)

# unlike the dry-run in 'kubectl create' command that are only client-side,
# dry-runs with apply yaml actually send the yaml to the server and report back to the client what's going to change

# using the app.yaml file in k8s-yaml folder:
kubectl apply -f app.yml --server-dry-run
# service/app-nginx-service created (server dry run)
# deployment.apps/app-nginx-deployment created (server dry run)
kubectl apply -f app.yml # to actually create the service and deployment
# and then:
kubectl apply -f app.yml --server-dry-run
# service/app-nginx-service unchanged (server dry run)
# deployment.apps/app-nginx-deployment unchanged (server dry run)
# now it says unchanged because the yaml was sent to the server and it was already exactly like in the yaml

# the folliwing command will state the diff between what's in the file and the server
kubectl diff -f app.yml
# it may return an empty response at this point because the same yml file is was already deployed above,
# but changing the replicas from 3 to 2 and adding a dummy label to the metadata:
#   labels:
#    servers: dmz
# and executing the same command again:
kubectl diff -f app.yml
# will show the diff (lines with '+' are added and with '-' are removed)

# ------------------ Labels and annotations

# these may be useful for filtering and grouping resources later on
# they go in the metadata section and they are a simple key-value list
# examples: tier: frontend, app ; end: prod ; customer: acme.co

# filter a get command
kubectl get pods -l app=nginx

# apply only matching labels (powerfull stuff)
kubectl apply -f myfile.yaml -l app=nginx

# labels are meant for simple data, to better describe the resources,
# while annotations are more for configuration

# Label Selectors: these tell the Services which pods are theirs
# (see app.yml file in k8s-yaml folder as an example)
# the Service will have a selector pointing to a label (key-value pair)
# as well as the replica set. The pods will have the label itself

# Taints and tolerations (some even more advance stuff, to only use when necessary)

# CLEANUP
# kubectl delete <resourceType>/<resourceName> OR
kubectl detele -f app.yml
kubectl get all