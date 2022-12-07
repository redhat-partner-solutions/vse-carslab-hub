# Multi-cluster setup

## Create a managed cluster set

In order to manage the various kubernetes clusters, we create a `ManagedClusterSet` called **all-openshift-clusters** in Red Hat Advanced Cluster Management for Kubernetes (RHACM). To add clusters in this clusterSet, we need to add the following label `cluster.open-cluster-management.io/clusterset=all-openshift-clusters` to the `ManagedClusters` to import.

This clusterSet is then bound to a specific namespace, using a `ManagedClusterSetBinding`. This allows RHACM to take action in these clusters through that namespace. In our case, we will bound the clusterSet to `openshift-gitops` namespace, as this is where we will deploy ArgoCD ApplicationSet.

Apply the following
```
oc apply -f managed-cluster-set.yaml
oc label managedcluster blazer-cars-lab cluster.open-cluster-management.io/clusterset=oall-openshift-clusters
```

[Find more information about ManagedClusterSet](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.4/html/clusters/managing-your-clusters#creating-a-managedclusterset)

## Import the managed clusters into ArgoCD
Now that we created the grouping of clusters to work with, let's import them in ArgoCD. Do to so, we need to create a `GitOpsCluster` that will define where is the ArgoCD to integrate with, along with the `Placement` rule to use. In our case, we will use the label `local-argo: True` to denote clusters that should be imported.

Apply the following
```
oc apply -f gitopscluster.yaml
oc label managedcluster blazer-cars-lab local-argo=True
```

[Find more information about the integration of ACM with ArgoCD](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.4/html/applications/managing-applications#gitops-config)

## Troubleshooting
- Make sure you have the correct labels for the cluster.
- Check that all the pods in the `open-cluster-management` namespace on the Managed cluster are running:
    ```
    oc get pods -A | grep open-cluster-management
    ```
    - If the `klusterlet-addon` pods are down, follow [this](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.4/html/clusters/managing-your-clusters#importing-the-klusterlet) to make sure your `KlusterletAddonConfig` is valid
    - Follow [this](https://github.com/stolostron/deploy/blob/master/hack/cleanup-managed-cluster.sh) to clean up klusterlet on your Managed cluster
