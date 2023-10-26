#CWD := $(shell pwd)
PROJECT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
VERSION  ?= 0.0.1
SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec
ENVPATH := $(shell echo $$PATH)
#export GOBIN = $(CWD)/bin
#export PATH = $(GOBIN):$(ENVPATH)
#export PATH = $(PROJECT_DIR)/bin:$(ENVPATH)

all: package
##@ General
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Deployment
.PHONY: install
install: generate staticcheck ## install locally.
	$(FYNE) install --icon assets/Icon.png

##@ Build
.PHONY: package
package: package_darwin package_windows ## package for Darwin and Windows.

.PHONY: package_darwin
package_darwin: generate ## package for Darwin.
	$(FYNE) package --icon assets/Icon.png

.PHONY: package_windows
package_windows: generate ## package for Windows.
	CC=x86_64-w64-mingw32-gcc $(FYNE) package --icon assets/Icon.png -os windows

##@ Development
# todo go vet
.PHONY: vet
vet:
	go vet ./...

.PHONY: staticcheck
staticcheck: ## run static check.
	$(STATICCHECK) ./...
	$(ERRCHECK) ./...

# generate 打包字体文件
# todo 打包icon
.PHONY: generate
generate: go-tools ## generate codes using `go generate ./...`.
	GOBIN=$(PROJECT_DIR)/bin go generate ./...
	#$(SQLC) generate -f sqlc/sqlc.yaml

.PHONY: go-tools
go-tools: stringer fyne go-staticcheck errcheck sqlc ## install go tools locally if necessary.

STRINGER = $(shell pwd)/bin/stringer
stringer: ## Download stringer locally if necessary.
	GOBIN=$(PROJECT_DIR)/bin go install golang.org/x/tools/cmd/stringer@latest

FYNE = $(shell pwd)/bin/fyne
fyne: ## Download fyne locally if necessary.
	GOBIN=$(PROJECT_DIR)/bin go install fyne.io/fyne/v2/cmd/fyne@v2.1.4

STATICCHECK = $(shell pwd)/bin/staticcheck
go-staticcheck: ## Download staticcheck locally if necessary.
	GOBIN=$(PROJECT_DIR)/bin go install honnef.co/go/tools/cmd/staticcheck@v0.3.2

ERRCHECK = $(shell pwd)/bin/errcheck
errcheck: ## Download errcheck locally if necessary.
	GOBIN=$(PROJECT_DIR)/bin go install github.com/kisielk/errcheck@v1.6.1

SQLC = $(shell pwd)/bin/sqlc
sqlc: ## Download sqlc locally if necessary.
	GOBIN=$(PROJECT_DIR)/bin go install github.com/kyleconroy/sqlc/cmd/sqlc@v1.13.0

.PHONY: clean
clean: ## clean the app packages.
	rm -rf d2excel.app d2excel.exe

.PHONY: clean-tools
clean-tools: ## clean the go tools in ./bin.
	@rm -rvf bin/



KUSTOMIZE = $(shell pwd)/bin/kustomize
kustomize: ## Download kustomize locally if necessary.
	GOBIN=$(PROJECT_DIR)/bin go install sigs.k8s.io/controller-tools/cmd/controller-gen@v0.6.1
