# Smart Card Setup Script for Linux

This script configures a Linux system to use a smart card (e.g., Nitrokey) with GnuPG and SSH.

## Usage

1. **Clone the repository**:
   ```bash
   git clone https://github.com/nottheend/setup-smartcard.git
   cd setup-smartcard

2. **Run the script**:
   ```bash
    chmod +x setup-smartcard.sh
    ./setup-smartcard.sh

3. **Test the setup**:
    ```bash
    gpg --card-status
    ssh-add -L
