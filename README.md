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

## Create demo code * package

- Defining config for bundle , file `` :
    ```terraform
    terraform {
    # Version of Terraform to include in the bundle. An exact version number
    # is required.
    version = "0.12.9"
    }

    # Define which provider plugins are to be included
    providers {
    # Include the newest "aws" provider version in the 1.0 series.
    aws = ["~> 2.31"]

    # Include both the newest 1.0 and 2.0 versions of the "google" provider.
    # Each item in these lists allows a distinct version to be added. If the
    # two expressions match different versions then _both_ are included in
    # the bundle archive.
    google = [ "~> 2.0", "2.17"]

    # Include a custom plugin to the bundle. Will search for the plugin in the
    # plugins directory, and package it with the bundle archive. Plugin must have
    # a name of the form: terraform-provider-*, and must be build with the operating
    # system and architecture that terraform enterprise is running, e.g. linux and amd64
    terraform-provider-extip = ["0.1"]
    }
    ```
- Adding custom plugin :
    ```
    mkdir ./plugins
    ```
    > Note - To include custom plugins in the bundle file, create a local directory "./plugins" and put all the plugins you want to include there. Optionally, you can use the -plugin-dir flag to specify a location where to find the plugins. To be recognized as a valid plugin, the file must have a name of the form terraform-provider-<NAME>_v<VERSION>. In addition, ensure that the plugin is built using the same operating system and architecture used for Terraform Enterprise. Typically this will be linux and amd64.
    - For example for putting our `extip` plugin :
        ```
        ls -l plugins                                                            
        total 55936
        -rwxr-xr-x  1 andrii  staff  28638964 Oct 11 17:31 terraform-provider-extip_v0.1
        ```
        > Note - this will NOT WORK with Terraform v 0.12 - as extip plugin is for v. 0. 11
- Package a bundle : 
    ```
    terraform-bundle package -os=linux -arch=amd64 terraform-bundle.hcl
    ```
    Output : 
    ```
    Fetching Terraform 0.12.9 core package...
    Fetching 3rd party plugins in directory: ./plugins
    plugin: extip (0.1)
    - Resolving "aws" provider (~> 2.31)...
    - Checking for provider plugin on https://releases.hashicorp.com...
    - Downloading plugin for provider "aws" (hashicorp/aws) 2.32.0...
    - Resolving "google" provider (~> 2.0)...
    - Checking for provider plugin on https://releases.hashicorp.com...
    - Downloading plugin for provider "google" (hashicorp/google) 2.17.0...
    - Resolving "google" provider (2.17)...
    - Checking for provider plugin on https://releases.hashicorp.com...
    - Downloading plugin for provider "google" (hashicorp/google) 2.17.0...
    Creating terraform_0.12.9-bundle2019101413_linux_amd64.zip ...
    All done!    
    ```
- Bundle :
    ```
    ls terraform_*
    terraform_0.12.9-bundle2019101413_linux_amd64.zip    
    ```
## Test 
- ~There is pre-configure [Vagrantfile](Vagrantfile) in current repository. Run : 
    ```vagrant up```
- Observe output : 
    ```
    Bringing machine 'default' up with 'virtualbox' provider...
    ==> default: Importing base box 'galser/ubuntu-1804-vbox'...
    ==> default: Matching MAC address for NAT networking...
    ==> default: Checking if box 'galser/ubuntu-1804-vbox' version '0.0.1' is up to date...
    ==> default: Setting the name of the VM: tf-bundle_default_1571060493056_12036
    ==> default: Clearing any previously set network interfaces...
    ==> default: Preparing network interfaces based on configuration...
        default: Adapter 1: nat
    ==> default: Forwarding ports...
        default: 22 (guest) => 2222 (host) (adapter 1)
    ==> default: Booting VM...
    ==> default: Waiting for machine to boot. This may take a few minutes...
        default: SSH address: 127.0.0.1:2222
        default: SSH username: vagrant
        default: SSH auth method: private key
        default: 
        default: Vagrant insecure key detected. Vagrant will automatically replace
        default: this with a newly generated keypair for better security.
        default: 
        default: Inserting generated public key within guest...
        default: Removing insecure key from the guest if it's present...
        default: Key inserted! Disconnecting and reconnecting using new SSH key...
    ==> default: Machine booted and ready!
    ==> default: Checking for guest additions in VM...
    ==> default: Setting hostname...
    ==> default: Mounting shared folders...
        default: /vagrant => /Users/andrii/labs/skills/tf-bundle
    ==> default: Running provisioner: file...
        default: scripts => $HOME/scripts
    ==> default: Running provisioner: file...
        default: infra => $HOME/infra
    ==> default: Running provisioner: shell...
        default: Running: /var/folders/nw/hlt5_kpd5lzb78xrft48ynqm0000gp/T/vagrant-shell20191014-12933-7u02tt.sh
        default: dpkg-preconfigure: unable to re-open stdin: No such file or directory
        default: Selecting previously unselected package unzip.
        default: (Reading database ... 
        default: (Reading database ... 5%
        ...
        default: Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
        default: Installed unzip
        default: Installing Terraform from bundle
        default: Terraform v0.12.9
        default: Your version of Terraform is out of date! The latest version
        default: is 0.12.10. You can update by downloading from www.terraform.io/downloads.html
        default: Initializing the backend...
        default: Initializing provider plugins...
        default: Terraform has been successfully initialized!
        default: 
        default: You may now begin working with Terraform. Try running "terraform plan" to see
        default: any changes that are required for your infrastructure. All Terraform commands
        default: should now work.
        default: If you ever set or change modules or backend configuration for Terraform,
        default: rerun this command to reinitialize your working directory. If you forget, other
        default: commands will detect it and remind you to do so if necessary.
        default: 
        default: Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
        default: 
        default: .
        default: ├── provider.aws ~> 2.0
        default: └── provider.google 2.17    
    ```
    Observing last line  - we indeed have Terraform of the very specific version with our providers without any "full" install. just by unpacking the zip into specified folder on instance. 

# Todo

- [ ] update readme

# Done
- [x] setup TF build env
- [x] build terraform-bundle
- [x] creatre demo code
- [x] create bundle
- [x] create Vagrant environment
- [x] test bundle in Vagrant

# Run logs
