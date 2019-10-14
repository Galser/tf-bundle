#!/usr/bin/env bash
# Vagrantbox Provison script for Terraform
# FROM bundle
# Warning : non-priviliged provision! for "vagrant" user


# 1.  check & install tools 
# unzip is not installed by default in most Linux distributions
which unzip || (
  sudo apt-get -qq install -y unzip
  echo Installed unzip
) 

# 2. Terraform install from bundle

[ -f $HOME/infra/terraform ] || (
  echo Installing Terraform from bundle
  sudo unzip -q $HOME/infra/terraform_0.12.9-bundle2019101413_linux_amd64.zip -d $HOME/infra/
)
$HOME/infra/terraform -version

