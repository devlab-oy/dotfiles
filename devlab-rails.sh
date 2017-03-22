#!/usr/bin/bash

echo
echo -n "Installing required configs for bundle, gem and rbenv... "

if [ ! -d ~/.bundle ]; then
  mkdir ~/.bundle
fi

curl --silent -o ~/.gemrc          https://raw.githubusercontent.com/devlab-oy/dotfiles/master/.gemrc
curl --silent -o ~/.bundle/config  https://raw.githubusercontent.com/devlab-oy/dotfiles/master/.bundle/config

cat > ~/.bash_profile << EOF
# Add rbenv to path
export PATH="$HOME/.rbenv/bin:$PATH"

# Load rbenv
if command -v rbenv &> /dev/null; then eval "\$(rbenv init -)"; fi
EOF

echo "OK!"
echo
