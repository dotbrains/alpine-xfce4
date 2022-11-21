#!/bin/bash

# Generate ssh host keys
ssh-keygen -A

# Run sshd
/usr/sbin/sshd -D -e -f /etc/ssh/sshd_config_jetbrains &

# Start the VNCServer
/usr/bin/vncserver :99 &

# Start pulseaudio
/usr/bin/pulseaudio &

# Start audify (audio redirection) for pulseaudio and noVNC
/usr/bin/node /opt/noVNC/audify.js &

# Start the noVNC server using the proxy
/opt/noVNC/utils/novnc_proxy --vnc 127.0.0.1:5999