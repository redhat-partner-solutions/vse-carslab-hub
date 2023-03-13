# Clusters

This folder is where the new clusters configuration is stored.

To add a new Managed cluster, one needs to add a directory with some yaml in the `overlays` directory. See the [overlay](https://github.com/redhat-partner-solutions/vse-ocp-bases/tree/main/overlay) directory in the `bases` repo for examples.

This `clusters` directory gets deployed from an ApplicationSet which can be found under [`components/applicationsets/clusters-appset.yaml`](/components/applicationsets/clusters-appset.yaml).