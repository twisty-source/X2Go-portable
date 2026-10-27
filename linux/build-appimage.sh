#!/bin/bash
set -e

echo "=== X2Go Client AppImage Builder ==="

ARCH=$(uname -m)
if [ "$ARCH" != "x86_64" ] && [ "$ARCH" != "aarch64" ]; then
    echo "Warning: Architecture $ARCH may not be fully supported by prebuilt linuxdeploy binaries."
fi

# Ensure dependencies
echo "1. Checking required tools..."
sudo apt-get update -qq
sudo apt-get install -y -qq \
    software-properties-common \
    wget \
    file \
    patchelf \
    desktop-file-utils

# Add X2Go official PPA if on Ubuntu
if command -v add-apt-repository >/dev/null 2>&1; then
    echo "Adding ppa:x2go/stable..."
    sudo add-apt-repository -y ppa:x2go/stable
    sudo apt-get update -qq
fi

# Install x2goclient and nxproxy
echo "2. Installing x2goclient and nxproxy..."
sudo apt-get install -y -qq \
    x2goclient \
    nxproxy \
    libxcomp3 \
    qt5-qmake \
    qtbase5-dev \
    libqt5svg5

WORKDIR=$(mktemp -d /tmp/x2go-appimage.XXXXXX)
cd "$WORKDIR"

echo "3. Downloading linuxdeploy and qt plugin..."
wget -q "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-${ARCH}.AppImage" -O linuxdeploy
wget -q "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-${ARCH}.AppImage" -O linuxdeploy-plugin-qt
chmod +x linuxdeploy linuxdeploy-plugin-qt

echo "4. Assembling AppDir..."
mkdir -p AppDir/usr/bin AppDir/usr/share/applications AppDir/usr/share/icons/hicolor/128x128/apps

cp $(which x2goclient) AppDir/usr/bin/
cp $(which nxproxy) AppDir/usr/bin/

if [ -f /usr/share/applications/x2goclient.desktop ]; then
    cp /usr/share/applications/x2goclient.desktop AppDir/usr/share/applications/
fi
if [ -f /usr/share/icons/hicolor/128x128/apps/x2goclient.png ]; then
    cp /usr/share/icons/hicolor/128x128/apps/x2goclient.png AppDir/usr/share/icons/hicolor/128x128/apps/
fi

echo "5. Building AppImage..."
export QMAKE=$(which qmake)
./linuxdeploy --appdir AppDir \
    -e $(which x2goclient) \
    -e $(which nxproxy) \
    -d /usr/share/applications/x2goclient.desktop \
    -i /usr/share/icons/hicolor/128x128/apps/x2goclient.png \
    --plugin qt \
    --output appimage

OUTPUT_FILE=$(ls X2Go_Client*.AppImage | head -n 1)
FINAL_NAME="x2goclient-${ARCH}.AppImage"
mv "$OUTPUT_FILE" "$FINAL_NAME"

echo "=== Successfully built $FINAL_NAME ==="
mv "$FINAL_NAME" "$OLDPWD/"
rm -rf "$WORKDIR"
echo "Saved to: $(pwd)/$FINAL_NAME"
