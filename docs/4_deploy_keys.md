### Deploy Keys

#### HTTPS

##### Generate token
As the repo is private and you can not use SSH, you will have to generate an access token see [github's docs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) for gudiance

```shell
git clone https://<username>:<token>@github.com/redhat-partner-solutions/vse-cars-hub.git
```

#### SSH

##### Generate SSH Key 
```shell
ssh-keygen -q -C <key_name> -t ed25519 -f </path/to/key>
```

##### Upload the public key  
Point your browser to your https://github.com/<USERNAME>/<REPO>/settings/keys/new to upload the contents of <key_name>. 

<font size="1">NOTE: Please refer to [github's docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys) for further information on managing deploy keys.</font>

```shell
git clone git@github.com:redhat-partner-solutions/vse-carslab-hub.git
```


---
[Previous](3_deploying_from_the_repo.md) | [Main](../README.md) | [Next](5_structure.md)
