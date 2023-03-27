## Deploying From The Repo
If this repository is private, you'll need to ensure that your SSH key or token being used is active for your user in GitHub (See steps below).  You also need to create a secret to store the repo detiails  in the `openshift-gitops` project, which is used to access the private GitHub repository.  It is suggested to use a team based SSH key, that way this repository could be used by multiple teams.

#### Generating A Token
As the repo is private and you can not use SSH, you will have to generate an access token see [github's docs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) for gudiance

```shell
git clone https://<username>:<token>@github.com/redhat-partner-solutions/vse-cars-hub.git
```

---
[Previous](2_how_to_run_it.md) | [Main](../README.md) | [Next](4_deploy_keys.md)
