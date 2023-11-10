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
    docker run -p 2022:22 debian-bare-ansible

or to run in the background:
    docker run -d -p 2022:22 debian-bare-ansible

Note that this runs the container in privileged mode.

It should also be possible to run in non-privileged most, but that does not work for me yet.

To build and deploy from Ansible:
=================================
You can also build and deploy the container using ansible.

    cd ansible/
    ansible-playbook -l local-container deploy-container.yml

Related work:
=============
* https://github.com/AkihiroSuda/containerized-systemd
* https://stackoverflow.com/questions/73714080/entrypoint-of-systemd-container-for-gitlab-ci/74959847#74959847
* https://forum.gitlab.com/t/docker-executor-with-systemd/91393
* https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container
