Bare Debian container, with one (ansible) user.

This container is ideal as a test container for testing Ansible configurations and new services.

To build the image:
===================
> cp ~/.ssh/id_rsa.pub allowedcontainerkey.pub
> docker build -t debian-bare-ansible .

Note: allowedcontainerkey.pub is copied here, because docker does not allow references
to files outside of the working directory.

To deploy the image to a container:
===================================
> docker run --rm -p 2022:22 debian-bare-ansible

or to run in the background:
> docker run -d -p 2022:22 debian-bare-ansible
