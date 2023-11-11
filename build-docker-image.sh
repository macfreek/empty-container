#!/usr/bin/env sh
cp ~/.ssh/id_rsa.pub allowedcontainerkey.pub
docker build -t debian-bare-ansible .

# Pick one based on what works for you:
# docker run -d --privileged -p 2022:22 debian-bare-ansible
# docker run -d -p 2022:22 -v /sys/fs/cgroup/dockerd.scope:/sys/fs/cgroup:rw debian-bare-ansible
