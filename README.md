# play-azure-kubernetes

Demo deployment based on UK language services.

1. ner-uk service based on chaliy/ner-ms:uk exposed as /ner/mitie/uk
2. npl-uk service based on chaliy/api_nlp_uk exposed as /nlp/uk
3. router publically exposes nginx with routes


## Instructions

Check each command in Makefile

```
# Create resource group to play in:
make group

# Provision Kubernetes Cluster using ACS
make create

# Authenticate kubectl (you need to have one)
make auth

# Create private registry
make registry

# Authenticate Docker to private registry
make registry-auth

# Create k8s secret to share Docker credentials
make registry-secret

# Build router Docker image and publish to private registry
make router-publish

# Provision application
make demo-create

# If you change something in application definitions (*.yml files)
# For example try change replicas: 10
make demo-apply

# Do not forget to cleanup all this stuff. It is quite pricy.
make clean
```

*Sidenote:* if you want to use Makefile you probably need to override varialbes RESOURCE_GROUP, CLUSTER_NAME and REGISTRY_NAME. There are few options here. 
You can export environmnet varialbes with this names. Or you can specify them in command line:

```
make group RESOURCE_GROUP=my-own-kubernetes-cluster CLUSTER_NAME=magic REGISTRY_NAME=somethingwithoutdashes
```

P.S. Check Makefile, it should be selfexplanatory

# Resources

1. Detailed blog post [Your very own Kubernetes cluster on Azure (ACS)](https://medium.com/devoops-and-universe/your-very-own-kubernetes-cluster-on-azure-acs-9ea758dcf100)
