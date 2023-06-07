# OpenShift Pipelines and Credentials 


## ServiceAccount for PipelineRuns 

Create a ServiceAccount called `pipeline-credentials-sa` with the desired
permissions and/or roles assigned to it. The Service Account
`pipeline-credentials-sa` will include
credentials configured as Secrets, and the credentials in the Secret object will
be used to authenticate when needed private resources (e.g., a private repo or a private registry) demanded by the execution of a PipelineRun.

## Secrets and SealedSecret for PipelineRuns

The Secrets associated to the created Service Account are introduced in the Hub Cluster using Sealed Secrets. Currently two SealedSecret objects are associated to the Service Account `pipeline-credentials-sa`:

  * Secret github-cred: Generated from `github-sealed.yaml`: Includes github shared credentials of VSE team to access private repos in
      `github.com/redhat-partner-solutions`
  * Secret quay-cred: Generated from `quay-sealed.yaml`: Quay shared credentials of VSE team for getting access to
      `quay.io/redhat-partner-solutions`


1) Create a SealedSecret for Secret github-cred:

```console
oc create secret generic github-cred --type=kubernetes.io/ssh-auth --dry-run=client \
		--from-file=ssh-privatekey="YOUR_FILENAME_WITH_GITHUB_SSH_KEY" -o yaml | \
    /usr/local/bin/kubeseal \
      --controller-name=sealed-secrets-controller \
      --controller-namespace=sealed-secrets \
      --format yaml > github-sealed.yaml
```

2) Create a SealedSecret for Secret quay-cred:

```console
	oc create secret generic quay-cred --type="kubernetes.io/basic-auth" --dry-run=client \
		--from-literal=username="YOUR_USERNAME" \
		--from-literal=password="YOUR_PASSWORD" -o yaml | \
    /usr/local/bin/kubeseal \
      --controller-name=sealed-secrets-controller \
      --controller-namespace=sealed-secrets \
      --format yaml > quay-sealed.yaml
```

3) Note that to get Openshift Pipelines to use these secrets we add an annotation that will specify the web address the Secret is used to get access. 
      * for Secret github-cred add annotation: `tekton.dev/git-0: github.com` 
      * for Secret quay-cred add annotation: `tekton.dev/docker-0: quay.io`

4) Create Argo CD ConfigMap and SealedSecret for using Argo sync tekton task:

```console
ARGO_URL=$(oc get route openshift-gitops-server -n openshift-gitops -o jsonpath='{.spec.host}{"\n"}')
oc create cm argocd-env-configmap -n vse-cicd-catalog --dry-run=client --from-literal=ARGOCD_SERVER=$ARGO_URL -o yaml > argocd-cm.yaml

ARGO_ADMIN_PASSWORD=$(oc get secret/openshift-gitops-cluster -n openshift-gitops -o jsonpath='{.data.admin\.password}' | base64 -d)
oc create secret generic argocd-env-secret -n vse-cicd-catalog --dry-run=client --from-literal=ARGOCD_USERNAME="admin" --from-literal=ARGOCD_PASSWORD=$ARGO_ADMIN_PASSWORD -o yaml | kubeseal --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets --format yaml > argocd-cred-sealed.yaml
```

## Usage

To provision the Service Account `pipeline-credentials-sa` with the associated Sealed Secrets and enable PipelineRuns access to github and quay repos:

```console
oc apply -k environments/overlays/cicd
```
