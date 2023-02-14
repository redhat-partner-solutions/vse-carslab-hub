# vse-carslab-hub
This repository helps configure an existing OpenShift cluster as a *Hub cluster*, whereby it can deploy *Managed* OpenShift clusters with Red Hat Advanced Cluster Management (ACM) for Kubernetes and OpenShift GitOps.  Red Hat ACM is responsible for deploying additional OpenShift clusters, typically referred to as *Managed* or *spoke* clusters.
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
```shell
export KUBECONFIG=my-hub-cluster-kubeconfig
until oc apply -k https://github.com/redhat-partner-solutions/vse-carslab-hub/bootstrap/overlays/default; do sleep 3; done
```

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
