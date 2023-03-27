## How to run it
If this repository is private, you'll need to ensure that either your `token`
or your `SSH key` is being used. You also need to create a secret for the
repo in the `openshift-gitops` project, which is used to access the private
GitHub repository.  It is suggested to use a team based SSH key, that way
this repository could be used by multiple teams.


### Patch Storage Class
```shell
export KUBECONFIG=</path/to/kubeconfig>
oc patch storageclass lso-filesystemclass -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
until oc apply -k vse-carslab-hub/bootstrap/overlays/default; do sleep 3; done

<output suppressed>
```

#### Create Secrets
```shell
oc delete secrets -n openshift-gitops private-hub-repo
oc create -n openshift-gitops secret generic vse-carslab-hub-repo \
    --from-literal=username=<username> \
    --from-literal=password=<token> \
    --from-literal=type=git \
    --from-literal=url=< The https URL of your vse-carslab-hub fork >
    --from-literal=insecure=true 
oc label -n openshift-gitops secret vse-carslab-hub-repo argocd.argoproj.io/secret-type=repository
```

Look at output from `oc describe applicationset cluster -n openshift-gitops` to ensure the secret being used has proper access.  Output from the OpenShift GUI also will confirm installation of necessary Operators to configure your OpenShift cluster as a Hub cluster.

---
[Previous](1_prerequisites.md) | [Main](../README.md) | [Next](3_deploying_the_repo.md)
