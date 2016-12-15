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

# Build router image
make router-publish

# Provision application
make demo-create

# If you change something in application definitions (*.yml files)
# For example try change replicas: 10
make demo-apply

# Do not forget to cleanup all this stuff. It is quite pricy.
make clean
```

P.S. Check Makefile, it should be selfexplanatory
