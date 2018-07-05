# init build parameters
GIT_NAME ?= master

.PHONY: all test package

all: test package

package:
	hack/package.sh $(GIT_NAME)