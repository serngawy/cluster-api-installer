OCP_REGISTRY ?= registry.redhat.io
WKDIR = ../out
TMPDIR = tmp

# CAPA env variable
CAPADIR = cluster-api-provider-aws
CAPAOUTDIR = $(WKDIR)/$(CAPADIR)/out
CAPACONFIGDIR = $(WKDIR)/$(CAPADIR)/config

.PHONY: build-cluster-api-chart
build-cluster-api-chart:

.PHONY: build-cluster-api-aws-chart
build-cluster-api-aws-chart:
	$ rm -rf $(WKDIR)
	$ mkdir -p $(WKDIR)
	$ git clone https://github.com/openshift/$(CAPADIR) $(WKDIR)/$(CAPADIR)
	$ cp ../src/$(CAPADIR)/kustomization.yaml $(CAPACONFIGDIR)
	$ kustomize build $(CAPACONFIGDIR) -o $(CAPADIR)/templates
	$ rm $(CAPADIR)/templates/cert*

.PHONY: build-cluster-api-provider-azure-chart
build-cluster-api-azure-chart:

.PHONY: release-chart
release-chart: