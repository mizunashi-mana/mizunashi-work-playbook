GROUP_VARS_SRC ?= $(wildcard ./group_vars/*.cue)

CUE ?= cue

GROUP_VARS_OUT := $(subst .cue,.yml,$(GROUP_VARS_SRC))

.SUFFIXES: .cue .yml

.PHONY: all
all: $(GROUP_VARS_OUT)

.cue.yml:
	$(CUE) export --force --outfile $@ $<
