# To build a Docker image, run e.g.
# docker build -t debian-generic-1 .

# Dockerfile with user
FROM debian:stable

# Environment and Arg variables
ARG USERNAME=ansible
# expose port 22 to the host machine, for SSH access
EXPOSE 22

# Add required packages
RUN apt-get update
RUN apt-get install -y openssh-server sudo
# Remove not needed packages
RUN apt-get autoremove -y
RUN apt-get autoclean -y
RUN apt-get clean -y

# Add non-root user
RUN useradd -ms /bin/bash $USERNAME

# Create the ssh directory and authorized_keys file
USER $USERNAME
RUN mkdir /home/$USERNAME/.ssh
COPY allowedcontainerkey.pub /home/$USERNAME/.ssh/authorized_keys

USER root
RUN chown $USERNAME /home/$USERNAME/.ssh/authorized_keys && \
    chmod 600 /home/$USERNAME/.ssh/authorized_keys
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Copy and run the entrypoint
COPY entrypoint.sh entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
