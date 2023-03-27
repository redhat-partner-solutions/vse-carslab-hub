# vse-carslab-hub
This repository helps configure an existing OpenShift cluster as a *Hub cluster*, whereby it can deploy *Managed* OpenShift clusters with Red Hat Advanced Cluster Management (ACM) for Kubernetes and OpenShift GitOps.  Red Hat ACM is responsible for deploying additional OpenShift clusters, typically referred to as *Managed* or *spoke* clusters.
All cluster lifecycle is managed by Argo CD, including the Argo configuration itself.

# Table Of Contents
1. [Prerequisites](docs/prerequisites.md)
2. [How To Run It](docs/how_to_run_it.md)
3. [Deploying From The Repo](docs/3_deploying_from_the_repo.md)
4. [Deploy Keys](docs/4_deploy_keys.md)
5. [Structure](docs/5_structure.md)
