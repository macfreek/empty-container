Bare Debian container, with one (ansible) user.

This container is ideal as a test container for testing Ansible playbooks and
configurations and new services.

To build the image:
===================
    cp ~/.ssh/id_rsa.pub allowedcontainerkey.pub
    docker build -t debian-bare-ansible .

Note: allowedcontainerkey.pub is copied here, because docker does not allow
references to files outside of the working directory.

To deploy the image to a container:
===================================

to run in interactive mode (usueful for debugging):

    docker run -it --privileged -p 2022:22 debian-bare-ansible

or to run in the background:

    docker run -d --privileged -p 2022:22 debian-bare-ansible

Note that these commands runs the container in privileged mode.

To deploy the imager in non-privileged container:
=================================================
It is also possible to run in non-privileged most, but this is non-trivial.

First of all, systemd needs write access to these directories:
/tmp, /run, /run/lock, and /var/lib/journal
This has been configured in the Dockerfile.

In addition, it expects /sys/fs/cgroup to be mounted (maybe be read-only),
and /sys/fs/cgroup/systemd to be writable.

cgroup exposes information ("control groups") from the host to the container.

If this is not configured correctly, you may get one these errors:

    Failed to mount cgroup at /sys/fs/cgroup/systemd: Operation not permitted

or

    Failed to create /init.scope control group: Read-only file system
    Failed to allocate manager object: Read-only file system

A NON-SOLUTION is to make /sys/fs/cgroup writable for the container: 
`-v /sys/fs/cgroup:/sys/fs/cgroup:rw`. It works, but is not better than
simply using `--privileged`

The easiest solution (untested) is to use the docker-replacement podman with
the `--systemd=true` option (which is set by default).

    podman run -d -p 2022:22 debian-bare-ansible

There are more suggestions online how to fix this. See the links at the bottom
of this readme.

Here are some arguments you may use on the command line:

    -v /sys/fs/cgroup:/sys/fs/cgroup:ro

    -v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /sys/fs/cgroup/dockerd

    -v /sys/fs/cgroup/dockerd.scope:/sys/fs/cgroup:rw

    --cgroupns private

If any of this fails, my suggestion is to to set the control group (cgroup)
to version 2, as described in the docker manual:
https://docs.docker.com/config/containers/runmetrics/#control-groups

If that is too much work, stick to `--privileged`.

What worked for me (on MacOS host system, docker engine 24.0.6)

    docker run -p 2022:22 -v /sys/fs/cgroup/dockerd.scope:/sys/fs/cgroup:rw debian-bare-ansible

(Actually, any path in the local filesystem within /sys/fs/cgroup/ works,
so I am a bit cautious that this may just be the same as
`-v /sys/fs/cgroup:/sys/fs/cgroup:rw`.
If you have any insight here, please leave an issue on Github.)

To build and deploy from Ansible:
=================================
You can also build and deploy the container using ansible.

    cd ansible/
    ansible-playbook -l local-container deploy-container.yml

To log in to the container:
===========================

    ssh 127.0.0.1 -l ansible  -p 2022

The container contains your id_rsa.pub public key in ~ansibls/.ssh/authorized_keys,
so you should be able to log in without password.


Related work:
=============
* https://github.com/AkihiroSuda/containerized-systemd
* https://stackoverflow.com/questions/73714080/entrypoint-of-systemd-container-for-gitlab-ci/74959847#74959847
* https://forum.gitlab.com/t/docker-executor-with-systemd/91393

On running a container in non-privileged mode:

* https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container
* https://developers.redhat.com/blog/2019/04/24/how-to-run-systemd-in-a-container
* https://serverfault.com/questions/1053187/systemd-fails-to-run-in-a-docker-container-when-using-cgroupv2-cgroupns-priva
* https://github.com/freeipa/freeipa-container
* https://docs.docker.com/config/containers/runmetrics/#control-groups
