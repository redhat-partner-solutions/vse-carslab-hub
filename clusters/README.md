# Clusters

This folder is where the new clusters configuration is stored.

To add a new Managed cluster, one needs to add a directory with the managed cluster YAML manifests in the `overlays` directory. See the [overlay](https://github.com/redhat-partner-solutions/vse-ocp-bases/tree/main/overlay) directory in the `bases` repo for examples.

To add a new ZTP Managed cluster, one needs to add a directory with some yaml in the `ztp-siteconfig` directory. See the `goldwing` directory as an example.
 
ZTP policies should be added to the `ztp-policies` directory.

This `clusters` directory gets deployed from an ApplicationSet which can be found under [`components/applicationsets/clusters-appset.yaml`](/components/applicationsets/clusters-appset.yaml).

ZTP clusters and policies gets deployed from 2 ApplicationSets which can be found under [`components/applicationsets/ztp-clusters-appset.yaml`](/components/applicationsets/ztp-clusters-appset.yaml) and [`components/applicationsets/ztp-policies-appset.yaml`](/components/applicationsets/ztp-policies-appset.yaml).

The clusters overlays are using Kustomize bases from the [vse-ocp-bases](https://github.com/redhat-partner-solutions/vse-ocp-bases) repository.