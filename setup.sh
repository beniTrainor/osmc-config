#!/bin/bash
# setup.sh

echo "[*] installing packages..."
while IFS=", " read -r packman packname packdesc; do
    if [[ -z $(which "$packname" 2>/dev/null) ]]; then
      $packman install "$packname"
    fi
done < <( cat packages.csv | sed 1d )

# Note: directories start with an alphabetic character
dirs=$(find . -maxdepth 1 -type d | grep "^\./[a-z]*" -x)

echo "[stow] deleting any previously symlinked config directories..."
for dir in $dirs; do
    stow -D "${dir:2}"
done

echo "[stow] symlinking config directories..."
for dir in $dirs; do
    stow "${dir:2}" -t ~
done

# vi:nospell
