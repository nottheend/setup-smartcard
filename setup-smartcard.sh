#!/bin/bash

# Step 1: Ensure GPG agent is configured for SSH support
echo "Configuring GPG agent for SSH support..."
GPG_AGENT_CONF="$HOME/.gnupg/gpg-agent.conf"
if ! grep -q "enable-ssh-support" "$GPG_AGENT_CONF"; then
    echo "enable-ssh-support" >> "$GPG_AGENT_CONF"
    echo "Added 'enable-ssh-support' to $GPG_AGENT_CONF"
else
    echo "'enable-ssh-support' already present in $GPG_AGENT_CONF"
fi

# Step 2: Reload the GPG agent to apply changes
echo "Reloading GPG agent..."
gpg-connect-agent reloadagent /bye

# Step 3: Ensure SSH environment variables are set in .bashrc (or .zshrc)
SHELL_RC="$HOME/.bashrc"
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
fi

echo "Updating shell configuration ($SHELL_RC) for GPG and SSH agent..."
if ! grep -q "GPG_TTY" "$SHELL_RC"; then
    echo 'export GPG_TTY=$(tty)' >> "$SHELL_RC"
    echo 'export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)' >> "$SHELL_RC"
    echo "Added GPG and SSH variables to $SHELL_RC"
else
    echo "GPG and SSH environment variables already set in $SHELL_RC"
fi

# Step 4: Source the shell configuration file to apply the changes
echo "Applying changes to current shell session..."
source "$SHELL_RC"

# Step 5: Check if the SSH key is available
echo "Checking if the SSH key is available..."
ssh-add -L
if [ $? -ne 0 ]; then
    echo "The agent has no identities, trying to export SSH key from GPG..."
    
    # Export the SSH key from GPG and load it into the SSH agent
    gpg --export-ssh-key | ssh-add -
    
    # Recheck if the SSH key is now available
    ssh-add -L
fi

echo "Setup complete. You should now be able to use your smartcard for SSH authentication."
