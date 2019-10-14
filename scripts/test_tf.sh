#!/usr/bin/env bash
# Vagrantbox Terraform test

# Init Terraform
cd $HOME/infra

./terraform apply -auto-approve
./terraform show
./terraform providers

