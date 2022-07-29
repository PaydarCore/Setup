#!/bin/bash

function Write()
{
    sudo echo ""
    sudo echo "----------"
    sudo echo ""
    sudo echo $1
    sudo echo ""
    sudo echo "----------"
    sudo echo ""
}

function InstallChrome()
{
    Write "Installing Google Chrome ..."

    sudo apt-get update 
    #sudo apt upgrade
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb

    Write "Installed Google Chrome"
}

function InstallVsCode()
{
    Write "Installing VS Code ..."

    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg

    sudo apt install apt-transport-https
    sudo apt update
    sudo apt install code -y

    code --install-extension ms-dotnettools.csharp
    code --install-extension bradlc.vscode-tailwindcss

    Write "Installed VS Code"
}

function InstallGit()
{
    Write "Installing Git ..."

    sudo apt-get install git -y

    Write "Installed Git"
}

function InstallDocker()
{
    Write "Installing Docker ..."

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

    Write "Installed Docker"
}

function InstallDockerCompose()
{
    Write "Installing Docker Compose ..."

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version

    Write "Installed Docker Compose"
}

function InstallDotNet()
{
    Write "Installing .NET ..."

    wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb

    sudo apt-get update 
    sudo apt-get install -y dotnet-sdk-6.0

    Write "Installed .NET"
}

function InstallNode()
{
    Write "Installing Node ..."

    curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
    sudo apt install nodejs -y

    Write "Installed Node"
}

function InstallSqlServer()
{
    Write "Installing SQL Server ..."

    # 22.04 is not supported yet. use Docker

    Write "Installed SQL Server"
}

function InstallAzureDataStudio()
{
    Write "Installing Azure Data Studio ..."

    wget https://go.microsoft.com/fwlink/?linkid=2202429
    mv index.html\?linkid\=2202429 ads.deb
    sudo apt install ./ads.deb -y
    # If not connecting => [update OpenSSL](https://github.com/microsoft/azuredatastudio/issues/13457#issuecomment-832202549)

    Write "Installed Azure Data Studio"
}

function InstallAnydesk()
{
    Write "Installing AnyDesk ..."

    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
    echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
    sudo apt update
    sudo apt install anydesk -y

    Write "Installed AnyDesk"
}

function InstallNginx()
{
    Write "Installing Nginx ..."

    sudo apt install nginx -y
    sudo nginx -v

    Write "Installed Nginx"
}

function InstallMkcert()
{
    Write "Installing Mkcert ..."

    sudo apt install libnss3-tools
    wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
    sudo cp mkcert-v1.4.3-linux-amd64 /usr/local/bin/mkcert
    sudo chmod +x /usr/local/bin/mkcert
    mkcert -install

    Write "Installed Mkcert"
}

function InstallMicro()
{
    Write "Installing Micro ..."

    sudo chmod -R 777 /usr/local/bin
    cd /usr/local/bin
    sudo curl https://getmic.ro | bash

    # or
    # wget https://github.com/zyedidia/micro/releases/download/v2.0.10/micro-2.0.10-amd64.deb
    # sudo apt install ./micro-2.0.10-amd64.deb

    Write "Installed Micro"
}

function InstallTelnet()
{
    Write "Installing Telnet ..."

    sudo apt-get install telnet -y

    Write "Installed Telnet"
}

function InstallBeyondCompare()
{
    Write "Installing Beyond Compare ..."

    wget https://www.scootersoftware.com/bcompare-4.4.2.26348_amd64.deb
    sudo apt-get update
    sudo apt-get install gdebi-core -y
    sudo gdebi -n bcompare-4.4.2.26348_amd64.deb

    Write "Installed Beyond Compare"
}

function InstallJq()
{
    Write "Installing jq ..."

    sudo apt-get update
    sudo apt-get install jq -y

    Write "Installed jq"
}

function RegisterPaydarCommands()
{
    Write "Registering Paydar Commands ..."

    sudo chmod 777 /etc/bash.bashrc
    sudo echo 'PATH="${PATH}:/PaydarCore/Infra/Commands"' >> /etc/bash.bashrc

    Write "Registered Paydar Commands"
}

function InstallVpn()
{
    Write "Creating VPN ..."
    # sudo apt install openconnect
    # micro /Vpn
    # printf 'username\npassword' | sudo openconnect vpn-server-address
}

function SetDockerPermissions()
{
    Write "Setting docker permissions ... "
    
    sudo gpasswd -a $USER docker
    newgrp docker
    sudo groupadd docker
    sudo usermod -aG docker ${USER}
    sudo usermod -aG docker $USER
    
    Write "Set docker permissions"
}

Write "Paydar Holding Installation"

InstallChrome
InstallVsCode
InstallGit
InstallDocker
InstallDockerCompose
InstallDotNet
InstallNode
InstallSqlServer
InstallAzureDataStudio
InstallAnydesk
InstallNginx
InstallMkcert
InstallMicro
InstallTelnet
InstallBeyondCompare
InstallJq
DownloadVsCodeExtensions
RegisterPaydarCommands

sudo apt install rename
sudo apt-get install -y baobab

Write "IMPORTANT => RESTART YOUR SYSTEM"
SetDockerPermissions