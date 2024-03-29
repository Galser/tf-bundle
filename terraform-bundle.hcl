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
  # we can in theoyr include extip as custom
  # but, it will not compile against Terraform v 0.12
  # extip = ["~> 0.1"]
}