# Core

This folder is where YAML for the core functionality of the cluster live. Here is where the Kubernetes administrator will put things that is necessary for the functionality of the cluster.

Under [`gitops-controller`](/core/gitops-controller/) is where you are using Argo CD to manage itself. The `kustomization.yaml` file uses `bootstrap/overlays/default` in it's `bases` configuration. <br/> This `core` directory gets deployed from an ApplicationSet which can be found under [`components/applicationsets/core-components-appset.yaml`](/components/applicationsets/core-components-appset.yaml).

To add a new "core functionality" workload, one needs to add a directory with some yaml in the `core` directory. See the [`advanced-cluster-management`](/core/advanced-cluster-management/) directory as an example.