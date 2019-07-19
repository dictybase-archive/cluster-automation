ACCOUNT = $(shell gcloud config list account --format "value(core.account)")
CONFIG_PATH = $(shell pwd)
APPS = minio redis argo-certificate argo-ingress argo-workflow dictycontent-postgres 
APPS += dictybase-auth-certificate dictybase-ingress arango-createdb dictycontent-postgres 
APPS += dictybase-certificate dictybase-auth-certificate dictybase-ingress
VALUE_FILES = dev.yaml prod.yaml staging.yaml
CONFIG_TREE = $(addsuffix /config, $(addprefix $(CONFIG_PATH)/,$(APPS)))

show-admin-account:
	@echo $(ACCOUNT)
show-config-path:
	@echo $(CONFIG_PATH)
create-config-tree:
	@mkdir -p $(CONFIG_TREE)
	@$(foreach c, $(CONFIG_TREE), @touch $(addprefix $c/, $(VALUE_FILES)))
