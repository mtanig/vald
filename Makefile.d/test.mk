#
# Copyright (C) 2019-2023 vdaas.org vald team <vald@vdaas.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

.PHONY: test

.PHONY: tparse/install
## install tparse
tparse/install: \
        $(GOPATH)bin/tparse

$(GOPATH)bin/tparse:
	$(call go-install, github.com/mfridman/tparse)

.PHONY: gotestfmt/install
## install gotestfmt
gotestfmt/install: \
        $(GOPATH)bin/gotestfmt

$(GOPATH)bin/gotestfmt:
	$(call go-install, github.com/gotesttools/gotestfmt/v2/cmd/gotestfmt)

.PHONY: gotests/install
## install gotests
gotests/install: \
        $(GOPATH)bin/gotests

$(GOPATH)bin/gotests:
	$(call go-install, github.com/cweill/gotests/gotests)

## run tests for cmd, internal, pkg
test:
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -cover -timeout=$(GOTEST_TIMEOUT) $(ROOTDIR)/cmd/... $(ROOTDIR)/internal/... $(ROOTDIR)/pkg/...

.PHONY: test/tparse
## run tests for cmd, internal, pkg and show table
test/tparse: \
        tparse/install
	set -euo pipefail
	rm -rf "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json"
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -json -cover -timeout=$(GOTEST_TIMEOUT) $(ROOTDIR)/cmd/... $(ROOTDIR)/internal/... $(ROOTDIR)/pkg/... \
	| tee "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json" \
	| tparse -pass -notests

.PHONY: test/cmd/tparse
## run tests for cmd and show table
test/cmd/tparse: \
        tparse/install
	set -euo pipefail
	rm -rf "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json"
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -json -cover -timeout=$(GOTEST_TIMEOUT) $(ROOTDIR)/cmd/... \
	| tee "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json" \
	| tparse -pass -notests

.PHONY: test/internal/tparse
## run tests for internal and show table
test/internal/tparse: \
        tparse/install
	set -euo pipefail
	rm -rf "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json"
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -json -cover -timeout=$(GOTEST_TIMEOUT) $(ROOTDIR)/internal/... \
	| tee "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json" \
	| tparse -pass -notests

.PHONY: test/pkg/tparse
## run tests for pkg and who table
test/pkg/tparse: \
        tparse/install
	set -euo pipefail
	rm -rf "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json"
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -json -cover -timeout=$(GOTEST_TIMEOUT) $(ROOTDIR)/pkg/... \
	| tee "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json" \
	| tparse -pass -notests

.PHONY: test/hack/tparse
## run tests for hack and show table
test/hack/tparse: \
        tparse/install
	set -euo pipefail
	rm -rf "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json"
	GOPRIVATE=$(GOPRIVATE) \
	go mod vendor -o $(ROOTDIR)/vendor
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=vendor -json -cover \
		$(ROOTDIR)/hack/gorules/... \
		$(ROOTDIR)/hack/helm/... \
		$(ROOTDIR)/hack/license/... \
		$(ROOTDIR)/hack/tools/... \
	| tee "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json" \
	| tparse -pass -notests
	rm -rf $(ROOTDIR)/vendor

.PHONY: test/all/tparse
## run tests for all Go codes and show table
test/all/tparse: \
        tparse/install
	set -euo pipefail
	rm -rf "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json"
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -json -cover -timeout=$(GOTEST_TIMEOUT) $(ROOTDIR)/... \
	| tee "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json" \
	| tparse -pass -notests

.PHONY: test/gotestfmt
## run tests for cmd, internal, pkg and show table
test/gotestfmt: \
        gotestfmt/install
	set -euo pipefail
	rm -rf "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json"
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -json -cover -timeout=$(GOTEST_TIMEOUT) $(ROOTDIR)/cmd/... $(ROOTDIR)/internal/... $(ROOTDIR)/pkg/... \
	| tee "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json" \
	| gotestfmt -showteststatus

.PHONY: test/cmd/gotestfmt
## run tests for cmd and show table
test/cmd/gotestfmt: \
        gotestfmt/install
	set -euo pipefail
	rm -rf "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json"
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -json -cover -timeout=$(GOTEST_TIMEOUT) $(ROOTDIR)/cmd/... \
	| tee "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json" \
	| gotestfmt -showteststatus

.PHONY: test/internal/gotestfmt
## run tests for internal and show table
test/internal/gotestfmt: \
        gotestfmt/install
	set -euo pipefail
	rm -rf "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json"
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -json -cover -timeout=$(GOTEST_TIMEOUT) $(ROOTDIR)/internal/... \
	| tee "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json" \
	| gotestfmt -showteststatus

.PHONY: test/pkg/gotestfmt
## run tests for pkg and who table
test/pkg/gotestfmt: \
        gotestfmt/install
	set -euo pipefail
	rm -rf "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json"
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -json -cover -timeout=$(GOTEST_TIMEOUT) $(ROOTDIR)/pkg/... \
	| tee "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json" \
	| gotestfmt -showteststatus

.PHONY: test/hack/gotestfmt
## run tests for hack and show table
test/hack/gotestfmt: \
        gotestfmt/install
	set -euo pipefail
	rm -rf "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json"
	GOPRIVATE=$(GOPRIVATE) \
	go mod vendor -o $(ROOTDIR)/vendor
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=vendor -json -cover \
		$(ROOTDIR)/hack/gorules/... \
		$(ROOTDIR)/hack/helm/... \
		$(ROOTDIR)/hack/license/... \
		$(ROOTDIR)/hack/tools/... \
	| tee "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json" \
	| gotestfmt -showteststatus
	rm -rf $(ROOTDIR)/vendor

.PHONY: test/all/gotestfmt
## run tests for all Go codes and show table
test/all/gotestfmt: \
        gotestfmt/install
	set -euo pipefail
	rm -rf "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json"
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -json -cover -timeout=$(GOTEST_TIMEOUT) $(ROOTDIR)/... \
	| tee "$(TEST_RESULT_DIR)/`echo $@ | sed -e 's%/%-%g'`-result.json" \
	| gotestfmt -showteststatus

.PHONY: test/create-empty
## create empty test file if not exists
test/create-empty:
	@$(call green, "create empty test file if not exists...")
	for f in $(GO_ALL_TEST_SOURCES) ; do \
		if [ ! -f "$$f" ]; then \
			package="$$(dirname $$f)" ; \
			package="$$(basename $$package)" ; \
			echo "package $$package" >> "$$f"; \
		fi; \
	done

.PHONY: test/remove-empty
## remove empty test files
test/remove-empty:
	@$(call green, "remove empty test files...")
	for f in $(GO_ALL_TEST_SOURCES) ; do \
		if ! grep -q "func Test" "$$f"; then \
			rm "$$f"; \
		fi; \
	done

.PHONY: test/pkg
## run tests for pkg
test/pkg:
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -cover $(ROOTDIR)/pkg/...

.PHONY: test/internal
## run tests for internal
test/internal:
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -cover $(ROOTDIR)/internal/...

.PHONY: test/cmd
## run tests for cmd
test/cmd:
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -cover $(ROOTDIR)/cmd/...

.PHONY: test/hack
## run tests for hack
test/hack:
	GOPRIVATE=$(GOPRIVATE) \
	go mod vendor -o $(ROOTDIR)/vendor
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=vendor -cover \
		$(ROOTDIR)/hack/gorules... \
		$(ROOTDIR)/hack/helm/... \
		$(ROOTDIR)/hack/license/...\
		$(ROOTDIR)/hack/tools/...
	rm -rf $(ROOTDIR)/vendor

.PHONY: test/all
## run tests for all Go codes
test/all:
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -cover $(ROOTDIR)/...

.PHONY: coverage
## calculate coverages
coverage:
	GOPRIVATE=$(GOPRIVATE) \
	go test -short -shuffle=on -race -mod=readonly -v -race -covermode=atomic -timeout=$(GOTEST_TIMEOUT) -coverprofile=coverage.out $(ROOTDIR)/...
	GOPRIVATE=$(GOPRIVATE) \
	go tool cover -html=coverage.out -o coverage.html

.PHONY: gotests/gen
## generate missing go test files
gotests/gen: \
	test/create-empty \
	gotests/patch-placeholder \
	gotests/gen-test \
	test/remove-empty \
	gotests/patch \
	format/go/test

.PHONY: gotests/gen-test
## generate test implementation
gotests/gen-test:
	@$(call green, "generate go test files...")
	$(call gen-go-test-sources)
	$(call gen-go-option-test-sources)

.PHONY: gotests/patch
## apply patches to generated go test files
gotests/patch:
	@$(call green, "apply patches to go test files...")
	find $(ROOTDIR)/internal/k8s/* -name '*_test.go' | xargs sed -i -E "s%k8s.io/apimachinery/pkg/api/errors%github.com/vdaas/vald/internal/errors%g"
	find $(ROOTDIR)/* -name '*_test.go' | xargs sed -i -E "s%cockroachdb/errors%vdaas/vald/internal/errors%g"
	find $(ROOTDIR)/* -name '*_test.go' | xargs sed -i -E "s%golang.org/x/sync/errgroup%github.com/vdaas/vald/internal/errgroup%g"
	find $(ROOTDIR)/* -name '*_test.go' | xargs sed -i -E "s%pkg/errors%vdaas/vald/internal/errors%g"
	find $(ROOTDIR)/* -name '*_test.go' | xargs sed -i -E "s%go-errors/errors%vdaas/vald/internal/errors%g"
	find $(ROOTDIR)/* -name '*_test.go' | xargs sed -i -E "s%go.uber.org/goleak%github.com/vdaas/vald/internal/test/goleak%g"
	find $(ROOTDIR)/internal/errors -name '*_test.go' | xargs sed -i -E "s%\"github.com/vdaas/vald/internal/errors\"%%g"
	find $(ROOTDIR)/internal/errors -name '*_test.go' -not -name '*_benchmark_test.go' | xargs sed -i -E "s/errors\.//g"
	find $(ROOTDIR)/internal/test/goleak -name '*_test.go' | xargs sed -i -E "s%\"github.com/vdaas/vald/internal/test/goleak\"%%g"
	find $(ROOTDIR)/internal/test/goleak -name '*_test.go' | xargs sed -i -E "s/goleak\.//g"

.PHONY: gotests/patch-placeholder
## apply patches to the placeholder of the generated go test files
gotests/patch-placeholder:
	@$(call green, "apply placeholder patches to go test files...")
	for f in $(GO_ALL_TEST_SOURCES) ; do \
		if [ ! -f "$$f" ] ; then continue; fi; \
		sed -i -e '/\/\/ $(TEST_NOT_IMPL_PLACEHOLDER)/,$$d' $$f; \
		if [ "$$(tail -1 $$f)" != "" ]; then echo "" >> "$$f"; fi; \
		echo "// $(TEST_NOT_IMPL_PLACEHOLDER)" >>"$$f"; \
	done
