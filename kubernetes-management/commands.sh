kubectl create deployment test --image nginx --dry-run -o yaml
# this commands is using a dry-run (it won't make any changes in the cluster)
# and the '-o yaml' part is to output in a yaml format
# this yaml can even be used as a baseline for a yaml file for kubernetes 
# it has multiple layers since a deployment creates a replica set and pods

kubectl create job test --image nginx --dry-run -o yaml
# a job, unlike deployment, sets the pods to not restart
# also, there are fewer layers because a job does creates the pods directly
# notice the 'restartPolicy: Never' because tipically when a job finishes, it is done

kubectl expose deployment/test --port 80 --dry-run -o yaml
# the deployment has to be created for this command to work, even if it is a dry run
# so run this first: 'kubectl create deployment test --image nginx'

# CLEANUP
kubectl delete deployment/test

#----------------------------------------------------------------------------------
#                                                    <'kubectl run' - the old ways>

kubectl run test --image nginx --dry-run 
# as of today (v1.15.5) 'kubectl run' creates a deployment but is it already giving a warning:
# "kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead."
# This means that in the future 'kubectl run' will create a pod instead of a deployment by default. Workarounds:
# 1- use 'kubectl run' command with the '--generator=run-pod/v1' parameter
# 2- use 'kubectl create' instead
# The idea is for 'kubectl run' work just like 'docker run' in the future

kubectl run test --image nginx --port 80 --expose --dry-run
# This is a way to create a deployment and a service with a single command, but this is going away
# The preferred way would be to use 'kubectl create deployment' and 'kubectl expose' commands

kubectl run test --image nginx --restart OnFailure --dry-run
# simply by replacing the '--expose' parameter with the '--restart OnFailure',
# this 'kubectl run' command will create a job instead (for one shot containers, it will only recreate on failure)

kubectl run test --image nginx --restart Never --dry-run
# by setting '--restart Never' the command will create a pod! (will be the default in the future)

kubectl run test --image nginx --schedule "*/1 * * * *" --dry-run
# and finally, this will create a cron job (once a day)

