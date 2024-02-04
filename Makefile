CURRENT_DIR = $(shell pwd)
GROUP_VARS_SRC ?= $(wildcard ./group_vars/*.cue)
HOST_VARS_SRC ?= $(wildcard ./host_vars/*.cue)
SSH_KEYS_SRC ?= $(wildcard ./assets/ssh_keys/*.encrypted)
ROLES_SCHEMAS ?= $(wildcard ./roles/*/*.cue)
VARS_SCHEMAS ?= $(wildcard ./schemas/*.cue)
COMMON_VARS ?= \
	$(wildcard ./cue_vars/*/*.cue) \
	$(wildcard ./cue_types/*.cue) \
	$(wildcard ./private_ca_*/ca_vars.cue)

CUE ?= cue
POETRY ?= poetry

LOGS_DIR ?= logs
TIMESTAMP ?= $(shell date +%s)

GROUP_VARS_OUT := $(subst .cue,.yml,$(GROUP_VARS_SRC))
HOST_VARS_OUT := $(subst .cue,.yml,$(HOST_VARS_SRC))
SSH_KEYS_OUT := $(subst .encrypted,.nopass,$(SSH_KEYS_SRC))
STAMPS := \
	.stamp.poetry-installed \
	.stamp.ansible-collections-installed

.SUFFIXES: .cue .yml .encrypted .nopass

.PHONY: all
all: build

.PHONY: build
build: build-public $(SSH_KEYS_OUT)

.PHONY: build-public
build-public: $(STAMPS) $(GROUP_VARS_OUT) $(HOST_VARS_OUT)

.PHONY: clean
clean:
	rm -f $(GROUP_VARS_OUT) $(HOST_VARS_OUT) $(SSH_KEYS_OUT)

.PHONY: up
up: build
	$(POETRY) run vagrant up

.PHONY: reload
reload: build
	$(POETRY) run vagrant reload

.PHONY: provision-base
provision-base: build
	$(POETRY) run ansible-playbook \
		--diff -vv \
		--vault-password-file ./assets/vagrant_vault_password \
		--inventory ./inventory_vagrant.yml \
		./playbook-base.yml \
		| tee $(LOGS_DIR)/provision-base.$(TIMESTAMP).log

.PHONY: provision-all
provision-all: build
	$(POETRY) run ansible-playbook \
		--diff -vv \
		--vault-password-file ./assets/vagrant_vault_password \
		--inventory ./inventory_vagrant.yml \
		./playbook-all.yml \
		| tee $(LOGS_DIR)/provision-all.$(TIMESTAMP).log

.PHONY: provision-services
provision-services: build
	$(POETRY) run ansible-playbook \
		--diff -vv \
		--vault-password-file ./assets/vagrant_vault_password \
		--inventory ./inventory_vagrant.yml \
		./playbook-services.yml \
		| tee $(LOGS_DIR)/provision-services.$(TIMESTAMP).log

.PHONY: provision-public-nginx-sites
provision-public-nginx-sites: build
	$(POETRY) run ansible-playbook \
		--diff -vv \
		--vault-password-file ./assets/vagrant_vault_password \
		--inventory ./inventory_vagrant.yml \
		./playbook-public-nginx-sites.yml \
		| tee $(LOGS_DIR)/provision-public-nginx-sites.$(TIMESTAMP).log

.stamp.poetry-installed: pyproject.toml poetry.lock
	$(POETRY) install --no-root
	touch $@

.stamp.ansible-collections-installed: .stamp.poetry-installed collections/requirements.yml
	$(POETRY) run ansible-galaxy collection install -r collections/requirements.yml
	touch $@

private_ca_%/ca_vars.cue: private_ca_%/gen-vars $(wildcard private_ca_%/*/*)
	$<

%.yml: %.cue $(ROLES_SCHEMAS) $(VARS_SCHEMAS) $(COMMON_VARS)
	$(POETRY) run python3 -m cue_compiler $< $@

%.nopass: %.encrypted
	cp $< $@
	chmod 600 $@
	ssh-keygen -f $@ -p -N ''
