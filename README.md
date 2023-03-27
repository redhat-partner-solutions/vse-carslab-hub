# vse-carslab-hub
A repository for deploying OpenShift clusters with Red Hat Advanced Cluster Management for Kubernetes and OpenShift GitOps.  
All cluster lifecycle is managed by Argo CD, including the Argo configuration itself.

## Prerequisites
In order to successfully use the contents of this repository, you need to have an OpenShift cluster deployed *with* storage available and ready to consume.  The methods of deployment of this OpenShift cluster can be:
- Red Hat ACM
- [Baremetal Installer Provisioned Infrastructure] (https://docs.openshift.com/container-platform/4.12/installing/installing_bare_metal_ipi/ipi-install-overview.html)
- [Crucible Ansible Playbooks] (https://github.com/redhat-partner-solutions/crucible)
- [Agent Based Installer] (https://docs.openshift.com/container-platform/4.12/installing/installing_with_agent_based_installer/preparing-to-install-with-agent-based-installer.html)

Storage can be provided however you deem fit.  Cloud environments typically have dynamic storage available after OpenShift cluster installation.  The requirements are (2) PersistentVolumes available for consumption by the assisted-service and postgres containers in the assisted-service pod.  A few options exist that we can recommend:
- OpenShift Data Foundation (ODF) is an option for providing dynamic storage provisioning for the resulting OpenShift cluster.
- Local Storage Operator (LSO) is also an option in resource (CPU, memory, etc) constrained environments as an alternative to ODF.

## How to run it
If this repository is private, you'll need to ensure that either your `token` or your `SSH key` is being used. You also need to create a secret for the repo in the `openshift-gitops` project, which is used to access the private GitHub repository.  It is suggested to use a team based SSH key, that way this repository could be used by multiple teams at Intel.

### For HTTPS

#### Generate token
As the repo is private and you can not use SSH, you will have to generate an access token see [github's docs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) for gudiance

```shell
git clone https://<username>:<token>@github.com/redhat-partner-solutions/vse-cars-hub.git
```

### For SSH

#### Generate SSH Key 
```shell
ssh-keygen -q -C <key_name> -t ed25519 -f </path/to/key>
```

#### Upload the public key  
Point your browser to [Intel-RedHat Deploy keys](https://github.com/redhat-partner-solutions/Intel-RedHat/settings/keys/new) to upload the contents of <key_name>. 

<font size="1">NOTE: Please refer to [github's docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys) for further information on managing deploy keys.</font>

```shell
git clone git@github.com:redhat-partner-solutions/vse-carslab-hub.git
```

#### Patch Storage Class
```shell
export KUBECONFIG=</path/to/kubeconfig>
oc patch storageclass lso-filesystemclass -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

#### Bootstrap
```shell
until oc apply -k vse-carslab-hub/bootstrap/overlays/default; do sleep 3; done

<output suppressed>
```

#### Create Secrets
```shell
oc delete secrets -n openshift-gitops vse-carslab-hub-repo
oc create -n openshift-gitops secret generic vse-carslab-hub-repo \
    --from-literal=username=<username> \
    --from-literal=password=<token> \
    --from-literal=type=git \
    --from-literal=url=https://github.com/redhat-partner-solutions/vse-intel-hub.git\
    --from-literal=insecure=true 
oc label -n openshift-gitops secret vse-carslab-hub-repo argocd.argoproj.io/secret-type=repository
```

Look at output from `oc describe applicationset cluster -n openshift-gitops` to ensure the secret being used has proper access.  Output from the OpenShift GUI also will confirm installation of necessary Operators to configure your OpenShift cluster as a Hub cluster.

# Structure
|#|Directory Name|Description|
|---|----------------|-----------------|
| 1. | `bootstrap` | This is where openshift-gitops configurations is stored. These are the items that get the cluster/automation started. <br /><br /> `base` is where are the "common" YAML would live and `overlays` are configurations specific to the cluster. |
| 2. | `components` | This is where specific components for the GitOps Controller lives (in this case Argo CD).<br /><br />`applicationsets` is where all the ApplicationSet YAMLs live.<br /><br />Other things that can live here are RBAC, Git repo, and other Argo CD specific configurations (each in their repsective directories). |
| 3. | `core` | This is where YAML for the core functionality of the cluster live. Here is where the Kubernetes administrator will put things that is necessary for the functionality of the cluster.<br /><br />Under `gitops-controller` is where you are using Argo CD to manage itself. The `kustomization.yaml` file uses `bootstrap/overlays/default` in it's `bases` configuration. This `core` directory gets deployed as an ApplicationSet which can be found under `components/applicationsets/core-components-appset.yaml`.<br /><br />To add a new "core functionality" workload, one needs to add a directory with some yaml in the `core` directory. See the `advanced-cluster-management` directory as an example.|
| 4. | `clusters` | This is where the new clusters configuration is stored. <br /><br /> To add a new Managed cluster, one needs to add a directory with some yaml in the `overlays` directory. See the `blazer` directory as an example.|
| 5. | `add-workers` | This is where the configuration to add day2 worker nodes is stored. <br /><br /> To add a day2 worker node to an OpenShift cluster, add the yamls to `add-workers\<node-name>\overlay\<cluster-name>`. See the `add-workers\du3-ldc1\overlay\volante` for an example.|

> **Note**
> This repository is using sealed secrets for secrets management. <br /> If you would like to use another secrets management solution, please change the SealedSecret manifests accordingly.






# Structure
|#|Directory Name|Description|
|---|----------------|-----------------|
| 1. | `bootstrap` | This is where openshift-gitops configurations is stored. These are the items that get the cluster/automation started. <br /><br /> `base` is where are the "common" YAML would live and `overlays` are configurations specific to the cluster. |
| 2. | `components` | This is where specific components for the GitOps Controller lives (in this case Argo CD).<br /><br />`applicationsets` is where all the ApplicationSet YAMLs live.<br /><br />Other things that can live here are RBAC, Git repo, and other Argo CD specific configurations (each in their repsective directories). |
| 3. | `core` | This is where YAML for the core functionality of the cluster live. Here is where the Kubernetes administrator will put things that is necessary for the functionality of the cluster.<br /><br />Under `gitops-controller` is where you are using Argo CD to manage itself. The `kustomization.yaml` file uses `bootstrap/overlays/default` in it's `bases` configuration. This `core` directory gets deployed as an ApplicationSet which can be found under `components/applicationsets/core-components-appset.yaml`.<br /><br />To add a new "core functionality" workload, one needs to add a directory with some yaml in the `core` directory. See the `advanced-cluster-management` directory as an example.|
