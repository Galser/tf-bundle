# tf-bundle
Follow as you learn - how to use terraform-bundle

# Disclaimer

This is not a full repo, just a small demo on how to use : [terrafom-bundle](https://github.com/hashicorp/terraform/tree/master/tools/terraform-bundle) . It assumes previous solid knowledge of Terraform and surrounding tools.  Some knowledge of Go would be a plss.

# Purpose

Learn how to use `terraform-bundle` and test it. 



# Instructions/Follow

## setup TF dev env
- using Git clone original repo : `git@github.com:hashicorp/terraform.git` into $GOPATH/src/github.com/hashicorp/terraform
- For local development of Terraform core, first make sure Go is properly installed and that a GOPATH has been set. **You will also need to add $GOPATH/bin to your $PATH.**
- cd to it
- `make tools`
    ```
    make tools
    GO111MODULE=off go get -u golang.org/x/tools/cmd/stringer
    GO111MODULE=off go get -u golang.org/x/tools/cmd/cover
    GO111MODULE=off go get -u github.com/golang/mock/mockgen
    ```
- `make`
    first one had failed : 
    ```
    ==> Checking that code complies with gofmt requirements...
    gofmt needs running on the following files:
    ./command/internal_plugin_list.go
    You can use the command: `make fmt` to reformat code.
    make: *** [fmtcheck] Error 1
    ```
- `make fmt`
    ```
    gofmt -w $(find . -not -path "./vendor/*" -type f -name '*.go')
    ```    
- next `make` : 
Output start
    ```
    ==> Checking that code complies with gofmt requirements...
    GO111MODULE=off go get -u golang.org/x/tools/cmd/stringer
    GO111MODULE=off go get -u golang.org/x/tools/cmd/cover
    GO111MODULE=off go get -u github.com/golang/mock/mockgen
    GOFLAGS=-mod=vendor go generate ./...
    2019/10/14 14:35:15 Generated command/internal_plugin_list.go
    go: downloading github.com/golang/mock v1.3.1
    go: extracting github.com/golang/mock v1.3.1
    go: finding github.com/golang/mock v1.3.1
    # go fmt doesn't support -mod=vendor but it still wants to populate the
    # module cache with everything in go.mod even though formatting requires
    # no dependencies, and so we're disabling modules mode for this right
    # now until the "go fmt" behavior is rationalized to either support the
    # -mod= argument or _not_ try to install things.
    GO111MODULE=off go fmt command/internal_plugin_list.go > /dev/null
    go list -mod=vendor ./... | xargs -t -n4 go test  -mod=vendor -timeout=2m -parallel=4
    go test -mod=vendor -timeout=2m -parallel=4 github.com/hashicorp/terraform github.com/hashicorp/terraform/addrs github.com/hashicorp/terraform/backend github.com/hashicorp/terraform/backend/atlas
    ```
    started at 13:36 ... and it took almost 5 minutes , last lines of output : 
    ```
    go test -mod=vendor -timeout=2m -parallel=4 github.com/hashicorp/terraform/tfdiags github.com/hashicorp/terraform/tools/loggraphdiff github.com/hashicorp/terraform/tools/terraform-bundle github.com/hashicorp/terraform/tools/terraform-bundle/e2etest
    ok  	github.com/hashicorp/terraform/tfdiags	1.255s
    ?   	github.com/hashicorp/terraform/tools/loggraphdiff	[no test files]
    ?   	github.com/hashicorp/terraform/tools/terraform-bundle	[no test files]
    ok  	github.com/hashicorp/terraform/tools/terraform-bundle/e2etest	2.443s
    go test -mod=vendor -timeout=2m -parallel=4 github.com/hashicorp/terraform/version
    ?   	github.com/hashicorp/terraform/version	[no test files]
    ```
## Build terraform-bundle 
- Compiling DEV version of Terraform : 
    ```
    make dev
    ==> Checking that code complies with gofmt requirements...
    GO111MODULE=off go get -u golang.org/x/tools/cmd/stringer
    GO111MODULE=off go get -u golang.org/x/tools/cmd/cover
    GO111MODULE=off go get -u github.com/golang/mock/mockgen
    GOFLAGS=-mod=vendor go generate ./...
    2019/10/14 14:44:02 Generated command/internal_plugin_list.go
    # go fmt doesn't support -mod=vendor but it still wants to populate the
    # module cache with everything in go.mod even though formatting requires
    # no dependencies, and so we're disabling modules mode for this right
    # now until the "go fmt" behavior is rationalized to either support the
    # -mod= argument or _not_ try to install things.
    GO111MODULE=off go fmt command/internal_plugin_list.go > /dev/null
    go install -mod=vendor .
    ```
- Now, making ```terraform-bundle`` and installing it : 
    ```
    go install ./tools/terraform-bundle
    go: downloading github.com/hashicorp/go-getter v1.4.0
    go: downloading github.com/hashicorp/hcl v0.0.0-20170504190234-a4b07c25de5f
    go: downloading github.com/mitchellh/cli v1.0.0
    go: downloading github.com/hashicorp/go-multierror v1.0.0
    ...
    go: finding google.golang.org/api v0.9.0
    go: finding github.com/jmespath/go-jmespath v0.0.0-20180206201540-c2b33e8439af
    go: finding go.opencensus.io v0.22.0
    go: finding github.com/hashicorp/golang-lru v0.5.1
    ```
    The above installeed terraform-bundle in $GOPATH/bin, which is assumed by the rest of this README to be in PATH.

    terraform-bundle is a repackaging of the module installation functionality from Terraform itself, so for best results you should build from the tag relating to the version of Terraform you plan to use. There is some slack in this requirement due to the fact that the module installation behavior changes rarely, but please note that in particular bundles for versions of Terraform before v0.12 must be built from a terraform-bundle built against a Terraform v0.11 tag at the latest, since Terraform v0.12 installs plugins in a different way that is not compatible.

- Check : 
    ```
    ls -la $GOPATH/bin/terra*
    -rwxr-xr-x  1 andrii  staff  62934756 Oct 14 14:44 /Users/andrii/go/bin/terraform
    -rwxr-xr-x  1 andrii  staff  25525932 Oct 14 14:45 /Users/andrii/go/bin/terraform-bundle
    ```
- Test empty run :
    ```
    $GOPATH/bin/terraform-bundle --version
    0.12.11
    ```
    Good enough.


# Todo


- [ ] creatre demo code
- [ ] create bundle
- [ ] create Vagrant environment
- [ ] test bundle in Vagrant
- [ ] update readme

# Done
- [x] setup TF build env
- [x] build terraform-bundle

# Run logs
