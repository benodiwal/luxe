# Variables
DUNE = dune
YARN = yarn

# Default target
all: build run

# Build targets
build: build-ocaml build-ts

build-ocaml:
	$(DUNE) build

build-ts:
	$(YARN) build

# Run target
run:
	@echo "Starting OCaml Client and Express Server..."
	@($(DUNE) exec luxe &)
	@sleep 1
	@$(YARN) start

# Clean target
clean:
	$(DUNE) clean
	rm -rf dist

# Development target
dev:
	@echo "Starting development environment..."
	@($(DUNE) build --watch &)
	@($(YARN) dev)

.PHONY: all build build-ocaml build-ts run clean dev
