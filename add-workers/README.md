# Add workers

This folder is where the configuration to add day2 worker nodes is stored.

To add a day2 worker node, one needs to add a directory with the worker YAML manifests in the `add-workers` directory. See the [overlay](https://github.com/redhat-partner-solutions/vse-ocp-bases/tree/main/overlay) directory in the `bases` repo for examples.

This `add-workers` directory gets deployed from an ApplicationSet which can be found under [`components/applicationsets/worker-nodes-appset.yaml`](/components/applicationsets/worker-nodes-appset.yaml).