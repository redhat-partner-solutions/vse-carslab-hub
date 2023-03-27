## Prerequisites
In order to successfully use the contents of this repository, you need to have an OpenShift cluster deployed *with* storage available and ready to consume.  The methods of deployment of this OpenShift cluster can be:
- Red Hat ACM
- [Baremetal Installer Provisioned Infrastructure](https://docs.openshift.com/container-platform/4.12/installing/installing_bare_metal_ipi/ipi-install-overview.html)
- [Crucible Ansible Playbooks](https://github.com/redhat-partner-solutions/crucible)
- [Agent Based Installer](https://docs.openshift.com/container-platform/4.12/installing/installing_with_agent_based_installer/preparing-to-install-with-agent-based-installer.html)

Storage can be provided however you deem fit.  Cloud environments typically have dynamic storage available after OpenShift cluster installation.  The requirements are (2) PersistentVolumes available for consumption by the assisted-service and postgres containers in the assisted-service pod.  A few options exist that we can recommend:
- OpenShift Data Foundation (ODF) is an option for providing dynamic storage provisioning for the resulting OpenShift cluster.
- Local Storage Operator (LSO) is also an option in resource (CPU, memory, etc) constrained environments as an alternative to ODF.

---
Previous | [Main](../README.md) | [Next](2_how_to_run_it.md)