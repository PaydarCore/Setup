#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
cyan=`tput setaf 6`
magenta=`tput setaf 5`
yellow=`tput setaf 3`
reset=`tput sgr0`

Check="\xE2\x9C\x94"

function Success()
{
    echo -e "${green}$*${reset}" | column -t -s ';'
}

function Info()
{
    echo "${cyan}$*${reset}"
}

function Warning()
{
    echo "${yellow}$*${reset}"
}

function Error()
{
    echo "${red}$*${reset}"
}

function Divide()
{
    echo ""
    echo "${magenta}----------${reset}"
    echo ""
}

function InstallVpn()
{
    if ( which openconnect 1>/dev/null ); then
        Success "OpenConnect;$Check"
    else
        Info "Installing openconnect ..."

        sudo apt install openconnect -y

        Success "Installed openconnect"
    fi

    if [ ! -f /Vpn ]; then
        Divide
        Info Please enter your VPN username
        Divide
        read Username
        Divide
        Info Please enter your VPN password
        Divide
        read Password
        Divide
        Info Please give me the VPN server address
        Divide
        read Server
        echo "printf '$Username\n$Password' | sudo openconnect $Server" | sudo tee -a /Vpn > /dev/null
        sudo chmod 777 /Vpn
    fi
}

function InstallChrome()
{
    if ( which google-chrome 1>/dev/null ); then
        Success "Chrome;$Check"
        return
    fi

    Info "Installing Google Chrome ..."

    sudo apt-get update 
    #sudo apt upgrade
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome
    sudo dpkg -i chrome

    Success "Installed Google Chrome"
}

function InstallVsCode()
{
    if ( which code 1>/dev/null ); then
        Success "VS Code;$Check"
        return
    fi

    Info "Installing VS Code ..."

    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg

    sudo apt install apt-transport-https
    sudo apt update
    sudo apt install code -y

    # code --install-extension ms-dotnettools.csharp
    # code --install-extension bradlc.vscode-tailwindcss
    code --install-extension ms-vscode-remote.remote-containers

    Success "Installed VS Code"
}

function InstallGit()
{
    if ( which git 1>/dev/null ); then
        Success "Git;$Check"
        return
    fi

    Info "Installing Git ..."

    sudo apt-get install git -y
    git config --global init.defaultBranch main

    Success "Installed Git"
}

function InstallDocker()
{
    if ( which docker 1>/dev/null ); then
        Success "Docker;$Check"
        return
    fi

    Info "Installing Docker ..."

    sudo apt-get update

    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release -y

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    sudo docker run hello-world
    
    # sudo gpasswd -a $USER docker
    # newgrp docker
    # sudo groupadd docker
    # sudo usermod -aG docker ${USER}
    # sudo usermod -aG docker $USER

    Success "Installed Docker"
}

function InstallDockerCompose()
{
    if ( which docker-compose 1>/dev/null ); then
        Success "Docker compose;$Check"
        return
    fi

    Info "Installing Docker Compose ..."

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version

    Success "Installed Docker Compose"
}

function InstallAzureDataStudio()
{
    if ( which azuredatastudio 1>/dev/null ); then
        Success "Azure Data Studio;$Check"
        return
    fi

    Info "Installing Azure Data Studio ..."

    wget https://go.microsoft.com/fwlink/?linkid=2202429
    mv index.html\?linkid\=2202429 ads.deb
    sudo apt install ./ads.deb -y
    # If not connecting => [update OpenSSL](https://github.com/microsoft/azuredatastudio/issues/13457#issuecomment-832202549)

    Success "Installed Azure Data Studio"
}

function InstallAnydesk()
{
    if ( which anydesk 1>/dev/null ); then
        Success "Anydesk;$Check"
        return
    fi

    Info "Installing AnyDesk ..."

    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
    echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
    sudo apt update
    sudo apt install anydesk -y

    Success "Installed AnyDesk"

    sudo sed -i 's/#\s*WaylandEnable\s*=.*$/WaylandEnable=false/g' /etc/gdm3/custom.conf
    sudo sed -i 's/#\s*AutomaticLoginEnable\s*=.*$/AutomaticLoginEnable=true/g' /etc/gdm3/custom.conf
    sudo sed -i 's/#\s*AutomaticLogin\s*=.*$/AutomaticLogin=$USERNAME/g' /etc/gdm3/custom.conf
}

function InstallNginx()
{
    if ( which nginx 1>/dev/null ); then
        Success "Nginx;$Check"
        return
    fi

    Info "Installing Nginx ..."

    sudo apt install nginx -y
    sudo nginx -v

    Success "Installed Nginx"
}

function InstallMkcert()
{
    if ( which mkcert 1>/dev/null ); then
        Success "Mkcert;$Check"
        return
    fi

    Info "Installing Mkcert ..."

    sudo apt install libnss3-tools
    wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 -O mkcert
    sudo cp mkcert /usr/local/bin/mkcert
    sudo chmod +x /usr/local/bin/mkcert
    mkcert -install

    Success "Installed Mkcert"
}

function InstallMicro()
{
    if ( which micro 1>/dev/null ); then
        Success "Micro;$Check"
        return
    fi

    Info "Installing Micro ..."

    sudo chmod -R 777 /usr/local/bin
    cd /usr/local/bin
    sudo curl https://getmic.ro | bash

    Success "Installed Micro"
}

function InstallTelnet()
{
    if ( which telnet 1>/dev/null ); then
        Success "Telnet;$Check"
        return
    fi

    Info "Installing Telnet ..."

    sudo apt-get install telnet -y

    Success "Installed Telnet"
}

function InstallBeyondCompare()
{
    if ( which bcompare 1>/dev/null ); then
        Success "Beyond Compare;$Check"
        return
    fi

    Info "Installing Beyond Compare ..."

    wget https://www.scootersoftware.com/bcompare-4.4.2.26348_amd64.deb -O beyondCompare
    sudo apt-get update
    sudo apt-get install gdebi-core -y
    sudo gdebi -n beyondCompare

    Success "Installed Beyond Compare"
}

function InstallWireshark()
{
    if ( which wireshark 1>/dev/null ); then
        Success "Wireshark;$Check"
        return;
    fi

    Info "Installing Wireshark ..."

    sudo apt-get install wireshark -y
    sudo dpkg-reconfigure wireshark-common
    sudo usermod -aG wireshark $USER

    Success "Installed Wireshark"
}

function InstallJq()
{
    if ( which jq 1>/dev/null ); then
        Success "JQ;$Check"
        return
    fi

    Info "Installing jq ..."

    sudo apt-get update
    sudo apt-get install jq -y

    Success "Installed jq"
}

function InstallRename()
{
    if ( which rename 1>/dev/null ); then
        Success "Rename;$Check"
        return
    fi

    Info "Installing rename ..."

    sudo apt install rename

    Success "Installed rename"
}

function InstallBaobab()
{
    if ( which baobab 1>/dev/null ); then
        Success "Baobab;$Check"
        return
    fi

    Info "Installing baobab ..."

    sudo apt-get install -y baobab

    Success "Installed baobab"
}

function ClonePaydarCommands()
{
    sudo mkdir -p /PaydarCore/Setup
    sudo mkdir -p /PaydarCore/Commands
    sudo mkdir -p /PaydarCore/Scripts

    sudo chmod -R 777 /PaydarCore/Setup
    sudo chmod -R 777 /PaydarCore/Commands
    sudo chmod -R 777 /PaydarCore/Scripts

    if [ ! -d /PaydarCore/Setup/.git ]; then
        Info "Cloning Setup repository..."
        git -C /PaydarCore clone https://github.com/PaydarCore/Setup
        sudo chmod -R 777 /PaydarCore/Setup
        Success "Got Setup"
    fi
    if [ ! -d /PaydarCore/Commands/.git ]; then
    Info "Cloning Commands repository..."
        git -C /PaydarCore clone https://github.com/PaydarCore/Commands
        sudo chmod -R 777 /PaydarCore/Commands
        Success "Got Commands"
    fi
    if [ ! -d /PaydarCore/Scripts/.git ]; then
    Info "Cloning Scripts repository..."
        git -C /PaydarCore clone https://github.com/PaydarCore/Scripts
        sudo chmod -R 777 /PaydarCore/Scripts
        Success "Got Scripts"
    fi
}

function RegisterPaydarCommands()
{
    if ( grep -nr PaydarCore /etc/bash.bashrc 1>/dev/null ); then
        Success "Paydar commands;$Check"
        return;
    fi
    
    cd /Temp

    Info "Registering Paydar Commands ..."

    sudo chmod 777 /etc/bash.bashrc
    sudo echo 'PATH="${PATH}:/PaydarCore/Commands"' >> /etc/bash.bashrc

    Success "Registered Paydar Commands"
}

function SetDockerPermissions()
{
    Info "Setting docker permissions ... "
    
    sudo gpasswd -a $USER docker
    newgrp docker
    sudo groupadd docker
    sudo usermod -aG docker ${USER}
    sudo usermod -aG docker $USER
    
    Success "Set docker permissions"
}

function DownloadVsCodeExtensions()
{
    if [ -f /PaydarCore/Extensions/CSharp.vsix ]; then
        Success "CSharp extension;$Check"
    else

        Info "Downloading C# VS Code extension ... "

        sudo mkdir -p /PaydarCore/Extensions

        wget http://dev.paydarsamane.com/CSharp.vsix -O CSharp.vsix
        sudo mv CSharp.vsix /PaydarCore/Extensions/CSharp.vsix

        Success "Downloaded C# VS Code extension "

    fi

    # if [ -f /PaydarCore/Extensions/Python.vsix ]; then
    #     Success "Python extension;$Check"
    # else

    #     Info "Downloading Python VS Code extension ... "

    #     sudo mkdir -p /PaydarCore/Extensions

    #     wget https://holism.blob.core.windows.net/downloads/python.vsix -O Python.vsix
    #     sudo mv Python.vsix /PaydarCore/Extensions/Python.vsix

    #     Success "Downloaded Python VS Code extension "

    # fi
}

function DownloadImageForStorage()
{
    if [ -f /PaydarCore/Images/NoImage ] && [ -s /PaydarCore/Images/NoImage ]; then
        Success "NoImage;$Check"
    else
        Width=800 # $(shuf -i 100-900 -n 1)
        Height=640 # $(shuf -i 100-900 -n 1)
        sudo mkdir -p /PaydarCore/Images
        sudo wget https://picsum.photos/$Width/$Height -O /PaydarCore/Images/NoImage
    fi
}

function GiveAccessToRoot()
{
    sudo mkdir -p /root/.ssh
    sudo ln -f -s ~/.ssh/id_ed25519 /root/.ssh/id_ed25519
    sudo ln -f -s ~/.ssh/id_ed25519.pub /root/.ssh/id_ed25519.pub
    sudo ln -f -s ~/.ssh/known_hosts /root/.ssh/known_hosts
}

function ConfigureKeyboard()
{
    # if ( ! which dbus-x11 1>/dev/null ); then
    if [[ $(dpkg -S dbus-x11 2>/dev/null | wc -l) -lt 1 ]]; then
        Info "Installing dbus-x11 ..."

        sudo apt install dbus-x11

        Success "Installed dbus-x11"
        Info "Configring keyboard ..."
        Success "Configured the keyboard"
    fi

    gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 40
    gsettings set org.gnome.desktop.peripherals.keyboard delay 250

    Success "Keyboard configs;$Check"
}

function SetFavoriteApps()
{
    gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'google-chrome.desktop', 'code.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.gedit.desktop']"
}

function SetAppsToOpenMaximized()
{
    if ( which devilspie2 1>/dev/null ); then
        Success "devilspie2;$Check"
        return
    fi

    Info "Configuring apps to be opened maximized ..."

    sudo apt install devilspie2 -y

    if [ ! -d ~/.config/devilspie2 ]; then
        mkdir ~/.config/devilspie2
    fi

    wget https://raw.githubusercontent.com/PaydarCore/Setup/main/Maximize -O ~/.config/devilspie2/maximize.lua

    if [ ! -d ~/.config/autostart ]; then
        mkdir ~/.config/autostart
    fi

    wget https://raw.githubusercontent.com/PaydarCore/Setup/main/Autostart -O ~/.config/autostart/devilspie2.desktop

    Success "Configured apps to be opened maximized"
}

function CreateGitHubAccessTokenFile()
{
    if [ -f /LocalSecrets/GitHubAccessToken ]; then
        Success "GitHubAccesstoken;$Check"
    else
        if [ ! -d /LocalSecrets ]; then
            sudo mkdir -p /LocalSecrets
            sudo chmod 777 /LocalSecrets
        fi
        sudo touch /LocalSecrets/GitHubAccessToken
        sudo chmod 777 /LocalSecrets/GitHubAccessToken
    fi
}

function ValidateGitHubAccessTokenFile()
{
    if [[ $(cat /LocalSecrets/GitHubAccessToken | wc -c) < 40 ]]; then
        Error "Invalid content in GitHubAccessToken, make sure save your GitHub Personal Access Token to /LocalSecrets/GitHubAccessToken"
        exit;
    fi
}

function CreateGitGlobalConfig()
{
    if [ ! -f ~/.gitconfig ]; then
        sudo touch ~/.gitconfig
    fi
    sudo chmod 777 ~/.gitconfig
    git config --global core.filemode false
    git config --global init.defaultBranch main
}

function CloneInfra()
{
    if [ ! -d /PaydarCore ]; then
        Clone PaydarCore
    fi
    if [ ! -d /PaydarNode ]; then
        Clone PaydarNode
    fi
}

function PullImages()
{
    if ( docker image ls | grep dotnet 1>/dev/null ); then
        Success "paydar/dotnet;$Check"
    else
        Info "Getting paydar/dotnet"
        docker pull paydar/dotnet
    fi
    if ( docker image ls | grep react 1>/dev/null ); then
        Success "paydar/react;$Check"
    else
        Info "Getting paydar/react"
        docker pull paydar/react
    fi
    if ( docker image ls | grep sql 1>/dev/null ); then
        Success "paydar/sql;$Check"
    else
        Info "Getting paydar/sql"
        docker pull paydar/sql
    fi
    if ( docker image ls | grep next 1>/dev/null ); then
        Success "paydar/next;$Check"
    else
        Info "Getting paydar/next"
        docker pull paydar/next
    fi
}

sudo echo ""
cd /Temp

Divide
Info "Paydar Holding Installation"
Divide

InstallVpn
InstallChrome
InstallVsCode
InstallGit
InstallDocker
InstallDockerCompose
InstallAzureDataStudio
InstallAnydesk
InstallNginx
InstallMkcert
InstallMicro
InstallTelnet
InstallBeyondCompare
InstallJq
InstallBaobab
InstallRename
InstallWireshark
DownloadVsCodeExtensions
DownloadImageForStorage
ClonePaydarCommands
RegisterPaydarCommands
GiveAccessToRoot
ConfigureKeyboard
SetFavoriteApps
SetAppsToOpenMaximized
CreateGitHubAccessTokenFile
ValidateGitHubAccessTokenFile
CreateGitGlobalConfig
# CloneInfra
PullImages

Divide
# Warning "IMPORTANT => RESTART YOUR SYSTEM"
# SetDockerPermissions
Divide
