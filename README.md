Bare Debian container, with one (ansible) user.

This container is ideal as a test container for testing Ansible playbooks and
configurations and new services.

To build the image:
===================
> cp ~/.ssh/id_rsa.pub allowedcontainerkey.pub
> docker build -t debian-bare-ansible .

Note: allowedcontainerkey.pub is copied here, because docker does not allow
references to files outside of the working directory.

To deploy the image to a container:
===================================
> docker run --rm -p 2022:22 debian-bare-ansible

or to run in the background:
> docker run -d -p 2022:22 debian-bare-ansible

To build and deploy from Ansible:
=================================
You can also build and deploy the container using ansible.

> cd ansible/
> ansible-playbook -l local-container deploy-container.yml
