.PHONY: all

RESOURCE_GROUP=play-azure-kubernetes
CLUSTER_NAME=chaliy-play-azure-kubernetes

# Create Azure Resource Group to play in
group:
	az group create -n $(RESOURCE_GROUP) -l "West Europe"

# Create Kubernetes cluster using ACS
create:
	az acs create -n $(CLUSTER_NAME) \
		-g $(RESOURCE_GROUP) \
		--admin-username ops \
		--dns-prefix $(CLUSTER_NAME) \
		--orchestrator-type kubernetes

# If something going wrang, clean up resource group
clean:
	az group deployment create --mode complete \
		--template-file purge.json \
		--resource-group $(RESOURCE_GROUP) \
		--name Purge

# Authenticate kubectl with credentials generated by ACS
auth:
	az acs kubernetes get-credentials -n $(CLUSTER_NAME) \
		-g $(RESOURCE_GROUP)

 # Deploy example service
hello:
	kubectl create -f ./hello.yml
	# kubectl logs hello
	# kubectl port-forward hello 8080
	# kubectl expose deployment hello --type="LoadBalancer" --port=80 --target-port=8080
	# kubectl get services/hello

# Print some helpf information about cluster
info:
	kubectl cluster-info
	kubectl get pods

# Creates proxy to the Kubernetes cluster
# You can then view dasboard locally http://localhost:8000/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard/
proxy:
	kubectl proxy --port=8000

# Scale to 5 agents. Not working for the time being
scale5:
	# Does not work, scale is not implemented at all
	az acs scale -n $(CLUSTER_NAME) \
		-g $(RESOURCE_GROUP) \
		--new-agent-count 5 \
		--debug


# Create router docker image.
# TODO: Somehow this image should be private, no reason to pollute public hub
router-build:
	docker build --rm=false -t chaliy/play-azure-kubernetes-router:latest ./router

router-push:
	docker push chaliy/play-azure-kubernetes-router:latest

router-publish: router-build router-push

# Deploy demo UK language services
# Depends on chaliy/play-azure-kubernetes-router:latest, so it should built and pushed in advance
# After deployment completed, you can retrieve external IP address
#			kubectl get services/router
# and then test with
# 		curl http://EXTERNAL-IP/ner/mitie/uk
demo-create:
	kubectl create -f ./ner-uk.yml,./nlp-uk.yml,./router.yml

demo-apply:
	kubectl apply -f ./ner-uk.yml,./nlp-uk.yml,./router.yml
