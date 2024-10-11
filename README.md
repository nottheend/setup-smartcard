# Smart Card Setup Script for Linux

This script configures a Linux system to use a smart card (e.g., Nitrokey) with GnuPG and SSH.

## Usage

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/smartcard-setup.git
   cd smartcard-setup

2. **Make the script executable**:

  ```bash
    chmod +x setup-smartcard.sh
    ./setup-smartcard.sh
    gpg --card-status
    ssh-add -L
