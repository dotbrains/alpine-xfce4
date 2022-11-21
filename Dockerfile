FROM alpine:latest

ARG username=${username:-"user"}
ARG password=${password:-"p@ssw0rd123"}

USER root

# Change root password.
RUN echo "root:${password}" | chpasswd

ADD . /code
WORKDIR /code

# Add necessary permissions to /code
RUN chmod -R 777 /code

RUN apk add --no-cache \
     build-base \
     openssh-server \
     openssh \
     tigervnc \
     sudo \
     make \
     cmake \
     bash \
     python3 \
     py3-pip \
     git \
     xfce4 \
     xfce4-terminal \
     xfce4-pulseaudio-plugin \
     pavucontrol \
     pulseaudio \
     alsa-plugins-pulse \
     alsa-lib-dev \
     faenza-icon-theme \
     firefox \
     wget \
     curl \
     nano \
     vim \
     npm \
     nodejs

# Add non-root user.
RUN adduser -h /home/$username -s /bin/bash -S -D $username
RUN echo "$username:${password}" | chpasswd
RUN echo "$username ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$username && \
    chmod 0440 /etc/sudoers.d/$username

# Configure ssh.
RUN mkdir -p /var/run/sshd

# Allow root login via ssh.
RUN sed -i 's/#\?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Allow ssh password authentication.
RUN sed -i 's/#\?PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN ( \
    echo 'PermitRootLogin yes'; \
    echo 'PasswordAuthentication yes'; \
    echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
  ) > /etc/ssh/sshd_config_jetbrains

ADD noVNC /opt/noVNC
ADD websockify /opt/noVNC/utils/websockify

ADD utilities/script.js /opt/noVNC/script.js
ADD utilities/audify.js /opt/noVNC/audify.js
ADD utilities/vnc.html /opt/noVNC/vnc.html
ADD utilities/pcm-player.js /opt/noVNC/pcm-player.js

RUN npm install -g pnpm

RUN pnpm install --prefix /opt/noVNC ws audify

# Add entrypoint script.
ADD entrypoint.sh /entrypoint.sh

# Add permissions to entrypoint script.
RUN chmod 777 /entrypoint.sh

# Use docker-bash-rc file to set up bash and make it pretty.
ADD utilities/docker-etc-profile.sh /etc/docker-etc-profile.sh
RUN chmod 777 /etc/docker-etc-profile.sh
RUN echo "source /etc/docker-etc-profile.sh" >> /root/.bashrc

# Install CLion.
RUN utilities/install_clion.sh

USER $username
WORKDIR /home/$username

RUN echo "source /etc/docker-etc-profile.sh" >> /home/$username/.bashrc

# Configure vnc.
RUN mkdir -p /home/$username/.vnc \
    && echo -e "-Securitytypes=none" > /home/$username/.vnc/config \
    && echo -e "#!/bin/bash\nstartxfce4 &" > /home/$username/.vnc/xstartup

# Configure vnc password.
RUN printf "${password}\n${password}\n\n" | vncpasswd

# Expose ssh, vnc and noVNC ports.
EXPOSE 22 5999 6080

# Start ssh, vnc and noVNC.
CMD [ "/bin/bash", "/entrypoint.sh" ]
