# Build, preview and write for the site. Run `make help` for an overview.

CABAL ?= cabal
HOST  ?= 127.0.0.1
PORT  ?= 8000

# Path of the compiled generator; resolved lazily, only by targets that run it.
SITE = $(shell $(CABAL) list-bin exe:site)

.DEFAULT_GOAL := build
.PHONY: help deps generator build watch check post lint freeze clean distclean

help: ## List the available targets
	@awk 'BEGIN { FS = ":.*## " } /^[a-z-]+:.*## / { printf "  %-10s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

deps: ## Fetch and compile the Haskell dependencies (slow, needed once)
	$(CABAL) update
	$(CABAL) build --only-dependencies exe:site

generator: ## Compile the site generator (src/, app/)
	$(CABAL) build exe:site

build: generator ## Build the whole site into _site/ (the default target)
	$(SITE) rebuild

watch: generator clean ## Preview at http://127.0.0.1:8000 (see HOST, PORT), rebuilding on change
	$(SITE) watch --host $(HOST) --port $(PORT)

check: build ## Build, then fail on broken internal links
	$(SITE) check --internal-links

post: ## Start a new post: make post TITLE="My new post"
	@scripts/new-post.sh "$$TITLE"

lint: ## Lint the Haskell sources with HLint
	hlint app src

freeze: ## Re-resolve dependencies and pin them in cabal.project.freeze
	rm -f cabal.project.freeze
	$(CABAL) freeze

clean: ## Remove the generated site and Hakyll's cache
	rm -rf _site _cache

distclean: clean ## Also remove the compiled generator (dist-newstyle/)
	rm -rf dist-newstyle
