#!/usr/bin/env sh
cp ~/.ssh/id_rsa.pub allowedcontainerkey.pub
docker build -t debian-bare-ansible .