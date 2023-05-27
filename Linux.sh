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
    echo
    echo "${magenta}----------${reset}"
    echo
}

function InstallVpn()
{
    if [ ! -f /LocalSecrets/Vpn ]; then
        sudo mkdir /LocalSecrets
        sudo chmod 777 /LocalSecrets
        Divide
        Info Please enter your VPN username
        Divide
        read Username
        Divide
        Info Please enter your VPN password
        Divide
        read Password
        Divide
        read Server
        echo $Username > /LocalSecrets/Vpn
        echo $Password >> /LocalSecrets/Vpn
        sudo chmod 777 /LocalSecrets/Vpn
    fi
}

function InstallV2Ray()
{
    sudo snap install v2ray-core
    # go to https://github.com/Matsuridayo/nekoray/releases
    # download nekoray-*****-linux64.zip
    # Preferences => Basic settings => Security => Skip TLS => should be checked
    # Preferences => Basic settings => Subscription => Ignore TLS => should be checked
    # Preferences => Groups => New group => select subscription and enter link
    # Update subscription
    # Make sure VPN Mode is checked
    # Connect
}

function InstallChrome()
{
    if ( which google-chrome 1>/dev/null ); then
        Success "Chrome;$Check"
        return
    fi

    Info "Installing Google Chrome ..."

    sudo apt-get update

    if [ -f /media/$USER/Repository/Files/chrome ]; then
        sudo cp /media/$USER/Repository/Files/chrome /Temp
    else
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /Temp/chrome
    fi
    
    sudo dpkg -i /Temp/chrome

    rm -rf /Temp/chrome

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

    Success "Installed Git"
}

function InstallNode()
{
    if ( which node 1>/dev/null ); then
        Success "Node.js;$Check"
        return
    fi

    Info "Installing Node ..."

    curl -sL https://raw.githubusercontent.com/nodesource/distributions/master/deb/setup_18.x | sudo bash -
    sudo apt install nodejs -y

    Success "Installed Node"
}

function UpdateNode()
{
    if [[ $(node -v | sed 's/[a-z-]//g' | cut -d'.' -f1) -gt 16 ]]; then
        Success "Node update;$Check"
        return
    fi

    Info "Upgradeing Node ..."

    sudo apt-get -o Dpkg::Options::="--force-overwrite" install nodejs
    sudo apt install nodejs -y

    Success "Upgraded Node"
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

    if [ -f /media/$USER/Repository/Files/ads.deb ]; then
        sudo cp /media/$USER/Repository/Files/ads.deb /Temp
    else
        wget https://go.microsoft.com/fwlink/?linkid=2215528
        mv index.html\?linkid\=2215528 /Temp/ads.deb
    fi
    
    sudo apt install /Temp/ads.deb -y
    # If not connecting => [update OpenSSL](https://github.com/microsoft/azuredatastudio/issues/13457#issuecomment-832202549)
    rm -rf /Temp/ads.deb

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
    wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 -O /Temp/mkcert
    sudo cp mkcert /usr/local/bin/mkcert
    sudo chmod +x /usr/local/bin/mkcert
    mkcert -install

    rm -rf /Temp/mkcert

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

    wget https://www.scootersoftware.com/bcompare-4.4.4.27058_amd64.deb
    sudo apt update
    sudo apt install ./bcompare-4.4.4.27058_amd64.deb

    Success "Installed Beyond Compare"
}

function InstallSshServer()
{
    if ( which parallel-ssh 1>/dev/null ); then
        Success "ParallelSSH;$Check"
        return;
    fi

    Info "Installing Parallel SSH ..."

    sudo apt -y install pssh

    Success "Installed Parallel SSH"
}

function InstallParallelSsh()
{
    if ( which sshd 1>/dev/null ); then
        Success "OpenSSH;$Check"
        return;
    fi

    Info "Installing SSH Serer ..."

    sudo apt install openssh-server -y

    Success "Installed SSH Serer"
}

function InstallBashCompletion()
{
    grep -wq '^source /etc/profile.d/bash_completion.sh' ~/.bashrc || echo 'source /etc/profile.d/bash_completion.sh'>>~/.bashrc
    source /etc/profile.d/bash_completion.sh
    # complete -W 'Suggestion1 Suggestion2 Suggestion3' YourCommand

    if [ -f /etc/profile.d/bash_completion.sh ]; then
        Success "BashCompletion;$Check"
        BashCompletionWordListUpdate
        return;
    fi

    Info "Installing BashCompletion ..."

    sudo apt install bash-completion -y

    Success "Installed BashCompletion"

    BashCompletionWordListUpdate
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

function InstallHttpie()
{
    if ( which http 1>/dev/null ); then
        Success "HTTPie;$Check"
        return;
    fi

    Info "Installing HTTPie ..."

    sudo apt install httpie -y

    Success "Installed HTTPie"
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

function InstallParallel()
{
    if ( which parallel 1>/dev/null ); then
        Success "Parallel;$Check"
        return
    fi

    Info "Installing parallel ..."

    sudo apt install parallel -y

    Success "Installed parallel"
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

    sudo chmod 777 /PaydarCore
    sudo chmod -R 777 /PaydarCore/Setup
    sudo chmod -R 777 /PaydarCore/Commands
    sudo chmod -R 777 /PaydarCore/Scripts

    if [ ! -d /PaydarCore/Setup/.git ]; then
        Info "Cloning Setup repository..."
        git -C /PaydarCore clone git@github.com:PaydarCore/Setup
        sudo chmod -R 777 /PaydarCore/Setup
        Success "Got Setup"
    fi
    if [ ! -d /PaydarCore/Commands/.git ]; then
    Info "Cloning Commands repository..."
        git -C /PaydarCore clone git@github.com:PaydarCore/Commands
        sudo chmod -R 777 /PaydarCore/Commands
        Success "Got Commands"
    fi
    if [ ! -d /PaydarCore/Scripts/.git ]; then
    Info "Cloning Scripts repository..."
        git -C /PaydarCore clone git@github.com:PaydarCore/Scripts
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
    Error DownloadVsCodeExtensions
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

function AddPersianInputSource()
{
    if [[ $( gsettings get org.gnome.desktop.input-sources sources | grep ir ) ]]; then
        Success "Persian;$Check"
        return;
    fi

    Info "Adding Persian ..."

    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ir')]"

    Success "Added Persian"
}

function SetLocaleToEnglishUs()
{
    if [[ $( locale | grep LANG=en_US.UTF-8 ) ]] && [[ $( gsettings get org.gnome.system.locale region ) == 'en_US.UTF-8' ]]; then
        Success "US English locale;$Check"
        return;
    fi

    Info "Setting locale to US English ..."

    sudo update-locale LANG=en_US.UTF-8
    gsettings set org.gnome.system.locale region 'en_US.UTF-8'
    dbus-send --print-reply --system --dest=org.freedesktop.Accounts /org/freedesktop/Accounts/User$UID org.freedesktop.Accounts.User.SetFormatsLocale string:'en_US.UTF-8' 1>/dev/null


    Success "Set locale to US English"
}

function ConfigureKeyboard()
{
    # if ( ! which dbus-x11 1>/dev/null ); then
    if [[ $(dpkg -S dbus-x11 2>/dev/null | wc -l) -lt 1 ]]; then
        Info "Installing dbus-x11 ..."

        sudo apt install dbus-x11 -y

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

function SetChromeAsTheDefaultBrowser()
{
    Info "Setting Chrome as the default browser ..."

    sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/google-chrome 500 1>/dev/null
    sudo update-alternatives --set x-www-browser /usr/bin/google-chrome 1>/dev/null

    Success "Set Chrome as the default browser"
}

function SetAppsToOpenMaximized()
{
    if ( which devilspie2 1>/dev/null ); then
        Success "devilspie2;$Check"
    else
        sudo apt install devilspie2 -y
    fi

    Info "Configuring apps to be opened maximized ..."

    if [ ! -d ~/.config/devilspie2 ]; then
        mkdir ~/.config/devilspie2
    fi

    if [ ! -f ~/.config/devilspie2/maximize.lua ]; then
        wget https://raw.githubusercontent.com/PaydarCore/Setup/main/Maximize -O ~/.config/devilspie2/maximize.lua
    fi

    if [ ! -d ~/.config/autostart ]; then
        mkdir ~/.config/autostart
    fi

    if [ ! -f ~/.config/autostart/devilspie2.desktop ]; then
        wget https://raw.githubusercontent.com/PaydarCore/Setup/main/Autostart -O ~/.config/autostart/devilspie2.desktop
    fi

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
    if ( docker image ls | grep api 1>/dev/null ); then
        Success "paydar/api;$Check"
    else
        Info "Getting paydar/api"
        docker pull paydar/api
    fi
    if ( docker image ls | grep panel 1>/dev/null ); then
        Success "paydar/panel;$Check"
    else
        Info "Getting paydar/panel"
        docker pull paydar/panel
    fi
    if ( docker image ls | grep database 1>/dev/null ); then
        Success "paydar/database;$Check"
    else
        Info "Getting paydar/database"
        docker pull paydar/database
    fi
    if ( docker image ls | grep next 1>/dev/null ); then
        Success "paydar/site;$Check"
    else
        Info "Getting paydar/site"
        docker pull paydar/site
    fi
}

sudo echo
cd /Temp

Divide
Info "Paydar Holding Installation"
Divide

# InstallVpn
InstallChrome
InstallVsCode
InstallGit
# InstallNode
# UpdateNode
InstallDocker
InstallDockerCompose
InstallAzureDataStudio
InstallAnydesk
InstallNginx
InstallMkcert
InstallMicro
InstallTelnet
InstallBeyondCompare
InstallSshServer
InstallParallelSsh
InstallHttpie
InstallJq
InstallBaobab
InstallRename
InstallParallel
InstallBashCompletion
DownloadVsCodeExtensions
DownloadImageForStorage
CreateGitGlobalConfig
ClonePaydarCommands
RegisterPaydarCommands
GiveAccessToRoot
AddPersianInputSource
SetLocaleToEnglishUs
ConfigureKeyboard
SetFavoriteApps
SetChromeAsTheDefaultBrowser
SetAppsToOpenMaximized
CreateGitHubAccessTokenFile
ValidateGitHubAccessTokenFile

# CloneInfra
Divide
# Warning "IMPORTANT => RESTART YOUR SYSTEM"
SetDockerPermissions
