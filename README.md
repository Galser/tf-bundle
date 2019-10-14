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
```

```

# Todo

 
- [ ] build terraform-bundle
- [ ] creatre demo code
- [ ] create bundle
- [ ] create Vagrant environment
- [ ] test bundle in Vagrant
- [ ] update readme

# Done
- [x] setup TF build env

# Run logs
