#!/usr/bin/env bash

yamlcheck() {
  file="$1"
  ruby -e "require 'yaml'; require 'json'; puts JSON.generate(YAML.load_file('$file'))"
}


