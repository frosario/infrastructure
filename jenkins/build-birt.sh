#!/bin/bash
#This is a jenkins script

git checkout master
git submodule foreach git pull origin master
docker build -t birt docker/images/birt

