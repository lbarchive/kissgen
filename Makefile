BASE_DIR = $(shell dirname $(shell readlink -f $(lastword $(MAKEFILE_LIST))))
BIN_DIR  = $(BASE_DIR)/bin

GEN = $(BIN_DIR)/gen
IDX = $(BIN_DIR)/idx

DOC_SRC    = $(BASE_DIR)
GH_PAGES   = $(BASE_DIR)/.gh-pages
GEN_T2H_SH = $(BASE_DIR)/.gen-t2h.sh
IDX_T2H_SH = $(BASE_DIR)/.idx-t2h.sh


nothing:
.PHONY: nothing


doc: gh-pages
.PHONY: doc


gh-pages:
	$(GEN) -t $(GEN_T2H_SH) $(DOC_SRC) $(GH_PAGES)
	$(IDX) -t $(IDX_T2H_SH) $(GH_PAGES)
.PHONY: gh-pages


test:
	bats test
.PHONY: test
