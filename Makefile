#Author: Polonio Davide <poloniodavide@gmail.com>
#License: GPLv3

OUTPUT_NAME= WirelessNetworkNotes
LIST_NAME= listOfSections.tex
PATH_OF_CONTENTS= res/sections
MAIN_FILE= main
CC= latexmk
JOB_NAME=-jobname='$(OUTPUT_NAME)'
CCFLAGS= -pdflatex='pdflatex -interaction=nonstopmode' -pdf
SHELL := /bin/bash #Need bash not shell

export EXTRA_CCFLAGS;

all: compile

compile:
	@if [[ -a "res/$(LIST_NAME)" ]]; then echo "Removing res/$(LIST_NAME)"; \
		rm res/$(LIST_NAME); fi; \
	for i in $(sort $(wildcard $(PATH_OF_CONTENTS)/*.tex)); do \
		echo "Adding $$i into $(LIST_NAME)"; \
		echo "\input{$$i}" >> res/$(LIST_NAME); \
	done; \
	$(CC) -C $(JOB_NAME); \
	$(CC) $(CCFLAGS) $(EXTRA_CCFLAGS) $(JOB_NAME); \

spellcheck:
	@./tools/spellcheck.sh

ci: spellcheck compile

watch:
	@while true; do \
		make --silent; \
		inotifywait -qre close_write res/sections; \
	done

clean:
	@git clean -Xfd
	@$(CC) -C -quiet $(JOB_NAME)
	@if [[ -a "$(OUTPUT_NAME)" ]]; then rm -rv $(OUTPUT_NAME)/; fi;

.PHONY: compile
