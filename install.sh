#!/bin/bash

echo -e "Fetching latest version info..\n"
response=$(curl -s https://lmstudio.ai/blog)

version=$(echo "$response" | grep -oP 'lmstudio-v\K[^"]+' | head -n 1)

if [ -n "$version" ]; then
  echo -e "Downloading version $version\n"

  wget -c "https://installers.lmstudio.ai/linux/x64/$version-5/LM-Studio-$version-5-x64.AppImage"
else
  echo -e "\nUnable to get latest version info\n"
  exit 1
fi

if ls LM-Studio-* 1> /dev/null 2>&1; then
  echo -e "\nExtracting contents..\n"
  chmod +x LM-Studio-* && ./LM-Studio-* --appimage-extract
else
  echo -e "\nCould not download file\n"
  exit 1
fi

if [ -d "squashfs-root" ]; then
  echo -e "\nInstalling LM Studio $version\n"

  sudo rm -rf /usr/local/lm-studio
  sudo mv squashfs-root /usr/local/lm-studio && sudo chown root:root /usr/local/lm-studio/chrome-sandbox && sudo chmod 4755 /usr/local/lm-studio/chrome-sandbox

  echo -e "\nInstalled successfully!\n"

    # Cleanup
  rm -rf LM-Studio-*
  exit 1
else
  echo -e "\nCould not extract contents\n"
  exit 1
fi
