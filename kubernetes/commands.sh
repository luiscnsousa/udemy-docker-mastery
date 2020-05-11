kubectl version #kubernetes must be enabled in docker desktop
kubectl run my-nginx --image nginx #similar to docker run
kubectl get pods #similar to docker service ls
kubectl get all #this shows the pods, replicas, deployments and cluster
kubectl delete deployment my-nginx # deleting the deployment will also delete the replicas and pods as well
kubectl get all #now only shows the cluster 

#NOTES:
#up to K8s v1.17 'kubectl run' creates a deployment, a replica and a pod
#from v1.18 and above, the 'kubectl run' will only create the pod, it is required to also do:
#kubectl create deployment nginx --image nginx

kubectl run my-apache --image httpd
kubectl get all

#SCALE
kubectl scale deploy/my-apache --replicas 2
kubectl scale deployment my-apache --replicas 2
kubectl get all

#WHAT HAPPENS DURING A SCALE COMMAND:
#The control plane (composed by all the master nodes - like managers in swarm) updates the deployment to 2 replicas
#The replica set controller sets the pod count to 2
#The Control plane assigns node to pod
#The kubelet agent in that node sees that pod is needed and starts the container

#LOGS
kubectl get pods
kubectl logs deployment/my-apache
#by default kubernetes will not merge logs from all pods, like in docker or swarm, only from 1 of those
kubectl logs deployment/my-apache --follow --tail 1 # ctrl + c to exit
#to pull logs from all pods, the label provided in deployment will be used
#so be careful with the deployment naming, or you might get logs from other pods as well
kubectl logs -l run=my-apache
#-l means label, the one applied by the kubectl run command
#this is good for troubleshooting but should not replate a log system - search Stern tool

#DESCRIBE
kubectl get pods
kubectl describe pod/my-apache-6b4dc47d85-4nnp8
kubectl describe pods #be careful if there are many pods

#SIMULATE POD RECOVERY
kubectl get pods -w #(in one tab) -w is like the watch command in docker
#copy one of the pod's name and in a different tab:
kubectl delete pod/my-apache-6b4dc47d85-4nnp8

#CLEANUP
kubectl delete deployment/my-apache