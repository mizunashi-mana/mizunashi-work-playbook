GROUP_VARS_SRC ?= $(wildcard ./group_vars/*.cue)
ROLES_SCHEMAS ?= $(wildcard ./roles/*/schema.cue)
VARS_SCHEMAS ?= $(wildcard ./cue_vars/*/vars.cue) $(wildcard ./*/vars.cue)

CUE ?= cue
POETRY ?= poetry

GROUP_VARS_OUT := $(subst .cue,.yml,$(GROUP_VARS_SRC))
STAMPS := \
	.stamp.poetry-installed \
	.stamp.ansible-collections-installed

.SUFFIXES: .cue .yml

.PHONY: all
all: $(STAMPS) $(GROUP_VARS_OUT)

.stamp.poetry-installed: pyproject.toml poetry.lock
	$(POETRY) install
	touch $@

.stamp.ansible-collections-installed: .stamp.poetry-installed collections/requirements.yml
	$(POETRY) run ansible-galaxy collection install -r collections/requirements.yml
	touch $@

vagrant_private_ca/vars.cue: vagrant_private_ca/gen-vars $(wildcard vagrant_private_ca/*/*)
	./vagrant_private_ca/gen-vars

%.yml: %.cue $(ROLES_SCHEMAS) $(VARS_SCHEMAS)
	$(POETRY) run python3 -m cue_compiler $< $@

.PHONY: vagrant-up
vagrant-up: all
	$(POETRY) run vagrant up --provision

.PHONY: vagrant-provision
vagrant-provision: all
	$(POETRY) run vagrant provision
