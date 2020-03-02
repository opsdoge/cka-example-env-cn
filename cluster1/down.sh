#!/usr/bin/env bash
vagrant destroy --force
rm -rf .vagrant
rm -rf tmp/*
rm -rf scripts/resources/weave.yaml
touch tmp/.gitignore
