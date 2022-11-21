#!/bin/bash

# Run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Install necessary packages
apk add --no-cache \
    wget \
    openjdk11 \
    make \
    cmake \
    gdb \
    gcc \
    g++ \
    clang \
    valgrind \
    git

# Install CLion
if [ ! -d "/opt/clion" ]; then
    wget -qO- https://download-cf.jetbrains.com/cpp/CLion-2020.2.3.tar.gz | tar -xz -C /opt
    mv /opt/clion-* /opt/clion
fi

# Symlink the java binary to /opt/clion/jbr/bin/java
ln -sf /usr/bin/java /opt/clion/jbr/bin/java

# Create an alias for clion
echo "alias clion='sh /opt/clion/bin/clion.sh'" >> ~/.bashrc

# Create a desktop entry
cat <<EOF > /usr/share/applications/clion.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=CLion
Icon=/opt/clion/bin/clion.png
Exec=sh /opt/clion/bin/clion.sh
Comment=The Drive to Develop
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-clion
EOF

# Make the desktop entry executable
chmod +x /usr/share/applications/clion.desktop

# Make the desktop entry visible in the application menu
update-desktop-database