<details>
  <summary>OS</summary>
  

- Ubuntu
  - Only 22.04 LTS
  - Only from ubunto.com
  - Bootable image
    - If you're on Windows, X
    - If you're on Linux, only using [balenaEtcher](https://ubuntu.com/tutorials/install-ubuntu-desktop#3-create-a-bootable-usb-stick)
  - Boot
  - Choose **Install Ubuntu**
    - Select English (US)
  - Keyboard layout
    - Enlish (US)
  - DO NOT Connect to WiFi
    - Reason: faster installation and async update after installation
  - Minimal installation
    - Make sure no box is selected
  - Erase disk and install Ubuntu
    - Always be ready to lose your machine
    - Advanced features
      - None
  - Press **Install Now**
    - Press **Continue**
  - Where are you?
    - Choose Tehran
    - Press **Continue**
  - Computer name
    - PaydarYourNamePc or PaydarYourNameLaptop
    - Set password to 100 (you will be asked for it frequently)
    - **DO NOT** choose *Log in automatically*
    - **CHOOSE** *Require my password to login*
  - Wait for installation
  - **DO NOT** help Ubuntu
    - Select **No, don't send system info**
  - Privacy off
  - Click **Done** (don't worry about progress)
  - Remove everything from the left bar except the recycle bin and files
  - Change culture
    - Settings
    - Region & Language
    - Format
    - United States
  - Connect to WiFi
  - Install Persian language
    - **DO NOT** install any languages other than English & Persian
        - **DO NOT** change defaults
  - Confiture the keyboard
    - Settings
      - Accessibility
      - Typing
      - Repeat keys
      - Delay = almost 10%
      - Speed = almost 60%
  
</details>

---

- Install VPN and connect to it (in case of doubt, ASK)
- Update Ubuntu (using VPN)
  - Settings
  - Software Update

- Install software using script
  - `sudo mkdir /Temp`
  - `sudo chmod 777 /Temp`
  - `cd /Temp`
  - `wget https://raw.githubusercontent.com/PaydarCore/Setup/main/Linux.sh`
  - `sudo chmod 777 Linux.sh`
  - `sudo ./Linux.sh`

- Git 
  - Generate keys and add your public key to GitHub 
    - Open terminal 
    - ssh-keygen -t ed25519 -C "your-github-email" 
    - Enter 3 times 
      - Accept default filename 
      - Empty password 
      - Empty password, again 
    - GitHub 
      - Profile menu
      - Settings 
      - SSH and GPG keys 
      - New SSH Key 
      - Copy/paste your public key there 
        - Using Files 
        - Go to the home folder 
        - Show hidden files 
        - .ssh folder 
        - id_ed25519.pub 
        - Right-click, open with the Text Editor, then copy 
  - Introduce yourself to git 
    - `git config --global user.email "your-email-of-github-here"` 
    - `git config --global user.name "your name here"`

- VS Code
  - Turn on Settings Sync...
    - Use GitHub account for synching
  - **DO NOT** install any other extension on VS Code
    - In case you need something, talk to the team
  - Word wrap
    - Files => Preferences => Settings
    - Search for “word wrap”
    - Select “on” from the dropdown

- Configuration
  - Add these to favorites, in order
    - Files
    - Chrome
    - VS Code
    - Terminal
    - Editor

- Chrome
  - Make default
    - On the first run, it asks for it
  - Do not send crash reports
  - Sign in
  - Extensions
    - JSONViewer
    - React Developer Tools

- Root
  - `sudo mkdir -p /root/.ssh`
  - `sudo ln -f -s ~/.ssh/id_ed25519 /root/.ssh/id_ed25519`
  - `sudo ln -f -s ~/.ssh/id_ed25519.pub /root/.ssh/id_ed25519.pub`
  - `sudo ln -f -s ~/.ssh/known_hosts /root/.ssh/known_hosts`

* Development
  - Clone PaydarCore
  - Clone PaydarNode
  - Enjoy!
