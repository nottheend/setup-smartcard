#!/bin/bash

# Function to print colored text
print_info() {
    echo -e "\033[1;32m$1\033[0m"
}

# Step 1: Create the GnuPG directory if it doesn't exist
if [ ! -d "$HOME/.gnupg" ]; then
    print_info "Creating GnuPG directory..."
    mkdir -p "$HOME/.gnupg"
fi

# Step 2: Set secure permissions for GnuPG directory
print_info "Setting permissions for GnuPG directory..."
chmod 700 "$HOME/.gnupg"

# Step 3: Configure GPG agent for SSH support
GPG_AGENT_CONF="$HOME/.gnupg/gpg-agent.conf"
if ! grep -q "enable-ssh-support" "$GPG_AGENT_CONF" 2>/dev/null; then
    print_info "Configuring GPG agent for SSH support..."
    echo "enable-ssh-support" >> "$GPG_AGENT_CONF"
else
    print_info "GPG agent already configured for SSH support."
fi

# Step 4: Ensure GPG uses agent for key management
GPG_CONF="$HOME/.gnupg/gpg.conf"
if ! grep -q "use-agent" "$GPG_CONF" 2>/dev/null; then
    print_info "Configuring GPG to use agent..."
    echo "use-agent" >> "$GPG_CONF"
else
    print_info "GPG already configured to use agent."
fi

# Step 5: Restart the GPG agent
print_info "Restarting GPG agent..."
gpgconf --kill gpg-agent
gpg-agent --daemon --enable-ssh-support

# Step 6: Add GPG to the bash environment if not already added
BASHRC="$HOME/.bashrc"
if ! grep -q "GPG_TTY" "$BASHRC"; then
    print_info "Adding GPG_TTY to bash environment..."
    echo "export GPG_TTY=\$(tty)" >> "$BASHRC"
    source "$BASHRC"
else
    print_info "GPG_TTY is already set in bash environment."
fi

# Step 7: Check if smart card is detected
print_info "Checking smart card status..."
gpg --card-status

# Step 8: Check for SSH keys in the agent
print_info "Checking for SSH identities..."
ssh-add -L

print_info "Smart card setup completed!"
