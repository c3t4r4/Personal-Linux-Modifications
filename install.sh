#!/bin/bash

welcome_screen() {
cat << "EOF"

________/\\\\\\\\\_____/\\\\\\\\\\___________________________/\\\_____________________________/\\\____        
 _____/\\\////////____/\\\///////\\\________________________/\\\\\___________________________/\\\\\____       
  ___/\\\/____________\///______/\\\______/\\\_____________/\\\/\\\_________________________/\\\/\\\____      
   __/\\\_____________________/\\\//____/\\\\\\\\\\\______/\\\/\/\\\_____/\\/\\\\\\\_______/\\\/\/\\\____     
    _\/\\\____________________\////\\\__\////\\\////_____/\\\/__\/\\\____\/\\\/////\\\____/\\\/__\/\\\____    
     _\//\\\______________________\//\\\____\/\\\_______/\\\\\\\\\\\\\\\\_\/\\\___\///___/\\\\\\\\\\\\\\\\_   
      __\///\\\___________/\\\______/\\\_____\/\\\_/\\__\///////////\\\//__\/\\\_________\///////////\\\//__  
       ____\////\\\\\\\\\_\///\\\\\\\\\/______\//\\\\\_____________\/\\\____\/\\\___________________\/\\\____ 
        _______\/////////____\/////////_________\/////______________\///_____\///____________________\///_____

EOF
}

bye_screen() {
cat << "EOF"

_____/\\\\\\\\\__________________________________/\\\________________________________________/\\\____                          
 ___/\\\\\\\\\\\\\_______________________________\/\\\______________________________________/\\\\\\\__                         
  __/\\\/////////\\\______________________________\/\\\_____________________________________/\\\\\\\\\_                        
   _\/\\\_______\/\\\_____/\\\\\\\\__/\\\\\\\\\____\/\\\____________/\\\\\_____/\\\____/\\\_\//\\\\\\\__                       
    _\/\\\\\\\\\\\\\\\___/\\\//////__\////////\\\___\/\\\\\\\\\____/\\\///\\\__\/\\\___\/\\\__\//\\\\\___                      
     _\/\\\/////////\\\__/\\\___________/\\\\\\\\\\__\/\\\////\\\__/\\\__\//\\\_\/\\\___\/\\\___\//\\\____                     
      _\/\\\_______\/\\\_\//\\\_________/\\\/////\\\__\/\\\__\/\\\_\//\\\__/\\\__\/\\\___\/\\\____\///_____                    
       _\/\\\_______\/\\\__\///\\\\\\\\_\//\\\\\\\\/\\_\/\\\\\\\\\___\///\\\\\/___\//\\\\\\\\\______/\\\____                   
        _\///________\///_____\////////___\////////\//__\/////////______\/////______\/////////______\///_____                  
________/\\\\\\\\\__/\\\_______________________________________________________________/\\\________/\\\________/\\\____        
 _____/\\\////////__\/\\\_____________________________________________________________/\\\\\\\____/\\\\\\\____/\\\\\\\__       
  ___/\\\/___________\/\\\____________________________________________________________/\\\\\\\\\__/\\\\\\\\\__/\\\\\\\\\_      
   __/\\\_____________\/\\\__________/\\\\\\\\\_______/\\\\\__/\\\\\____/\\\\\\\\\____\//\\\\\\\__\//\\\\\\\__\//\\\\\\\__     
    _\/\\\_____________\/\\\\\\\\\\__\////////\\\____/\\\///\\\\\///\\\_\////////\\\____\//\\\\\____\//\\\\\____\//\\\\\___    
     _\//\\\____________\/\\\/////\\\___/\\\\\\\\\\__\/\\\_\//\\\__\/\\\___/\\\\\\\\\\____\//\\\______\//\\\______\//\\\____   
      __\///\\\__________\/\\\___\/\\\__/\\\/////\\\__\/\\\__\/\\\__\/\\\__/\\\/////\\\_____\///________\///________\///_____  
       ____\////\\\\\\\\\_\/\\\___\/\\\_\//\\\\\\\\/\\_\/\\\__\/\\\__\/\\\_\//\\\\\\\\/\\_____/\\\________/\\\________/\\\____ 
        _______\/////////__\///____\///___\////////\//__\///___\///___\///___\////////\//_____\///________\///________\///_____

EOF
}

check_operating_system() {
    # Check that this installer is running on a
    # Debian-like operating system (for dependencies)

    echo -e "\n\e[39m[+] Checking operating system\e[39m\n"
    error="\n\e[91m    [✘] Need to be run on a Ubuntu-like operating system, exiting.\e[39m\n"

    if [[ -f "/etc/os-release" ]]; then
        if [[ $(cat /etc/os-release | grep -e "ID_LIKE=\"\?ubuntu" -e "ID=ubuntu") ]]; then
            echo -e "\n\e[92m    [✔] Ubuntu-like operating system\e[39m\n"
        else
            echo -e "$error"
            exit 1
        fi
    else
        echo -e "$error"
        exit 1
    fi
}

update_upgrade() {
    echo -e "\n\e[39m[+] Update and Upgrade System\e[39m\n"

    sudo timedatectl set-timezone America/Sao_Paulo  > /dev/null 2>&1 && sudo apt update  > /dev/null 2>&1 && sudo apt upgrade -y  && sudo apt autoremove -y > /dev/null 2>&1

    echo -e "\n\e[92m    [✔] Update and Upgrade ok\e[39m\n"

    echo -e "\n\e[39m[+] Install packages\e[39m\n"

    sudo apt install git curl wget net-tools software-properties-common apt-transport-https acl zip unzip htop ncdu flatpak bcmwl-kernel-source -y > /dev/null 2>&1

    echo -e "\n\e[92m    [✔] Packages Installed\e[39m\n"
}

autoremove() {
    echo -e "\n\e[39m[+] Autoremove System\e[39m\n"

    sudo apt autoremove -y  > /dev/null 2>&1

    echo -e "\n\e[92m    [✔] Autoremove OK\e[39m\n"
}

limit_jornalctl() {
    echo -e "\n\e[39m[+] Config Jornalctl Files\e[39m\n"

    sudo journalctl --vacuum-time=2d  > /dev/null 2>&1 && sudo journalctl --vacuum-size=500M > /dev/null 2>&1

    echo -e "\n\e[92m    [✔] Config Jornalctl configured\e[39m\n"
}

install_oh_my_z() {
    sudo apt install zsh fonts-powerline dconf-cli -y  > /dev/null 2>&1 && zsh --version

    echo -e "\n\e[39m[+] Checking ohmyzsh\e[39m\n"

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo -e "\n\e[92m    [✔] ohmyzsh is already installed\e[39m\n"
    fi

    chsh -s /usr/bin/zsh

    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

    echo -e "\e[39m[+] Checking powerlevel10k\e[39m"
    
    if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" > /dev/null 2>&1
        echo -e "\n\e[92m    [✔] powerlevel10k installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] powerlevel10k is already installed\e[39m\n"
    fi

    echo -e "\n\e[39m[+] Checking zsh-autosuggestions\e[39m\n"

    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions" > /dev/null 2>&1
        echo -e "\n\e[92m    [✔] zsh-autosuggestions installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] zsh-autosuggestions is already installed\e[39m\n"
    fi

    echo -e "\n\e[39m[+] Checking zsh-syntax-highlighting\e[39m\n"

    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" > /dev/null 2>&1
        echo -e "\n\e[92m    [✔] zsh-syntax-highlighting installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] zsh-syntax-highlighting is already installed\e[39m\n"
    fi
    

    echo -e "\n\e[39m[+] Checking config on .zshrc file\e[39m\n"

    if [[ -f "$HOME/.zshrc" ]]; then
        sed -i 's:robbyrussell:powerlevel10k/powerlevel10k:g' "$HOME/.zshrc"
        sed -i 's:plugins=(git):plugins=(git zsh-autosuggestions zsh-syntax-highlighting):g' "$HOME/.zshrc"

        if ! grep -q ~/.zshrc_aliases "$HOME/.zshrc"; then
            echo -e "if [ -f ~/.zshrc_aliases ]; then" >> $HOME/.zshrc
            echo -e "  . ~/.zshrc_aliases" >> $HOME/.zshrc
            echo -e "fi" >> $HOME/.zshrc
            echo -e "\n" >> $HOME/.zshrc
        fi

        if ! grep -q ~/.p10k.zsh "$HOME/.zshrc"; then
            echo -e "\n" >> $HOME/.zshrc
            echo -e "# To customize prompt, run 'p10k configure' or edit ~/.p10k.zsh." >> $HOME/.zshrc
            echo -e "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> $HOME/.zshrc
        fi

        echo -e "\n\e[92m    [✔] .zshrc configured\e[39m\n"
    else
        echo -e "\n\e[91m    [✘] .zshrc file not found.\e[39m\n"
    fi
}

set_p10k_config(){
    echo -e "\n\e[39m[+] Checking config on .p10k.zsh and .zshrc_aliases file\e[39m\n"

    cp .zshrc_aliases $HOME/
    source $HOME/.zshrc

    echo -e "\n\e[92m    [✔] .p10k.zsh and .zshrc_aliases configured\e[39m\n"
}

remove_libreoffice() {
    echo -e "\n\e[39m[+] Checking LibreOffice\e[39m\n"

    sudo apt-get remove libreoffice-core -y  > /dev/null 2>&1

    echo -e "\n\e[92m    [✔] LibreOffice Removed\e[39m\n"
}

install_chrome(){
    echo -e "\n\e[39m[+] Checking Google Chrome\e[39m\n"

    REQUIRED_PKG="google-chrome-stable"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")

    if [ "" = "$PKG_OK" ]; then
        if [ ! -f "/tmp/google-chrome.deb" ]
        then
            wget -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > /dev/null 2>&1
        fi
        sudo apt install libu2f-udev -y  > /dev/null 2>&1 && sudo dpkg -i /tmp/google-chrome.deb
        echo -e "\n\e[92m    [✔] Google Chrome Installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] Google Chrome is already installed\e[39m\n"
    fi
}

install_edge(){
    echo -e "\n\e[39m[+] Checking Microsoft Edge\e[39m\n"

    REQUIRED_PKG="microsoft-edge-stable"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")

    if [ "" = "$PKG_OK" ]; then
        
        if ! grep -q https://packages.microsoft.com/repos/edge "/etc/apt/sources.list.d/microsoft-edge-dev.list" && ! grep -q https://packages.microsoft.com/repos/edge "/etc/apt/sources.list.d/microsoft-edge.list"; then
            curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
            sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
            sudo sh -c 'echo "deb [arch=amd64]  https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
            sudo rm microsoft.gpg && sudo apt update > /dev/null 2>&1
        fi
        sudo apt install $REQUIRED_PKG -y
        echo -e "\n\e[92m    [✔] Microsoft Edge Installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] Microsoft Edge is already installed\e[39m\n"
    fi
}

install_vscode(){
    echo -e "\n\e[39m[+] Checking Microsoft VSCode\e[39m\n"

    REQUIRED_PKG="code"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")

    if [ "" = "$PKG_OK" ]; then
        if ! grep -q https://packages.microsoft.com/repos/vscode "/etc/apt/sources.list.d/microsoft-edge-dev.list" && ! grep -q https://packages.microsoft.com/repos/vscode "/etc/apt/sources.list.d/microsoft-edge.list"; then
            curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
            sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
            sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" >> /etc/apt/sources.list.d/microsoft-edge-dev.list'
            sudo rm microsoft.gpg && sudo apt update > /dev/null 2>&1
        fi
        sudo apt install $REQUIRED_PKG -y
        echo -e "\n\e[92m    [✔] Microsoft VSCode Installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] Microsoft VSCode is already installed\e[39m\n"
    fi
}

install_sublime(){
    echo -e "\n\e[39m[+] Checking Sublime Text\e[39m\n"

    REQUIRED_PKG="sublime-text"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")

    if [ "" = "$PKG_OK" ]; then
        wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null 2>&1
        sudo sh -c 'echo "deb [arch=amd64] https://download.sublimetext.com/ apt/stable/" >> /etc/apt/sources.list.d/sublime-text.list'
        sudo apt update > /dev/null 2>&1 && sudo apt install $REQUIRED_PKG -y
        echo -e "\n\e[92m    [✔] Sublime Text Installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] Sublime Text is already installed\e[39m\n"
    fi
}

install_dbeaver(){
    echo -e "\n\e[39m[+] Checking DBeaver\e[39m\n"

    REQUIRED_PKG="dbeaver-ce"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")

    if [ "" = "$PKG_OK" ]; then
        sudo  wget -O /usr/share/keyrings/dbeaver.gpg.key https://dbeaver.io/debs/dbeaver.gpg.key
        echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
        sudo apt-get update > /dev/null 2>&1 && sudo apt-get install $REQUIRED_PKG -y
        echo -e "\n\e[92m    [✔] DBeaver Installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] DBeaver is already installed\e[39m\n"
    fi
}

install_thunderbird(){
    echo -e "\n\e[39m[+] Checking Thunderbird\e[39m\n"

    REQUIRED_PKG="thunderbird"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")

    if [ "" = "$PKG_OK" ]; then
        sudo apt install $REQUIRED_PKG -y > /dev/null 2>&1
        echo -e "\n\e[92m    [✔] Thunderbird Installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] Thunderbird is already installed\e[39m\n"
    fi
}

install_element(){
    echo -e "\n\e[39m[+] Checking ElementChat\e[39m\n"

    REQUIRED_PKG="element-desktop"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")

    if [ "" = "$PKG_OK" ]; then
        sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg > /dev/null 2>&1
        echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list
        sudo apt update > /dev/null 2>&1 && sudo apt install $REQUIRED_PKG -y > /dev/null 2>&1
        echo -e "\n\e[92m    [✔] ElementChat Installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] ElementChat is already installed\e[39m\n"
    fi
}

install_laravel_pack(){
    echo -e "\n\e[39m[+] Checking Laravel Pack\e[39m\n"

    
    echo -e "\n\e[39m[+] Checking PHP 8.2 and Composer \e[39m\n"

    REQUIRED_PKG="php8.2"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")
    if [ "" = "$PKG_OK" ]; then
        sudo add-apt-repository ppa:ondrej/php -y

        sudo apt update > /dev/null 2>&1 && sudo apt install php8.2 php8.2-fpm php8.2-gmp php8.2-curl php8.2-intl php8.2-mbstring php8.2-xmlrpc php8.2-pgsql php8.2-gd php8.2-xml php8.2-cli php8.2-zip php-pear php8.2-redis php8.2-mysql -y > /dev/null 2>&1

        # Composer
        curl -sS https://getcomposer.org/installer -o ./composer-setup.php > /dev/null 2>&1 && sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer > /dev/null 2>&1
        composer self-update  > /dev/null 2>&1
        rm -rf composer-setup.php > /dev/null 2>&1

        # Deployer
        curl -LO https://deployer.org/deployer.phar > /dev/null 2>&1 && sudo mv deployer.phar /usr/local/bin/dep > /dev/null 2>&1 && sudo chmod +x /usr/local/bin/dep && dep self-update > /dev/null 2>&1

        echo -e "\n\e[92m    [✔] PHP 8.2 and Composer Installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] PHP 8.2 and Composer is already installed\e[39m\n"
    fi

    echo -e "\n\e[39m[+] Checking NodeJS 18 \e[39m\n"

    REQUIRED_PKG="nodejs"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")
    if [ "" = "$PKG_OK" ]; then
        sudo apt install gcc g++ make > /dev/null 2>&1 && curl -sL  https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt install nodejs npm -y > /dev/null 2>&1

        echo -e "\n\e[92m    [✔] NodeJS 18 Installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] NodeJS 18 is already installed\e[39m\n"
    fi
}

install_extensions(){
    echo -e "\n\e[39m[+] Checking Gnome Extensions\e[39m\n"

    REQUIRED_PKG="gnome-shell-extensions"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep "install ok installed")

    if [ "" = "$PKG_OK" ]; then
        sudo apt install $REQUIRED_PKG chrome-gnome-shell -y  > /dev/null 2>&1
        unzip extensions.zip -d ~/.local/share/gnome-shell/extensions
        echo -e "\n\e[92m    [✔] Gnome Extensions Installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] Gnome Extensions is already installed\e[39m\n"
    fi
}



install_essentials() {
    install_chrome
    install_edge
    install_vscode
    install_sublime
    install_dbeaver
    install_thunderbird
    install_element
    install_extensions
}

confirm() {
    while true; do
        echo -e "\n"
        read -p "Do you want to $TEXT ?? (YES/NO/CANCEL) " yn
        echo -e "\n"
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            [Cc]* ) exit;;
            * ) echo "Please answer YES, NO, or CANCEL.";;
        esac
    done
}

#RUN SCRIPT
clear
welcome_screen

# BASICS
check_operating_system
limit_jornalctl
remove_libreoffice
update_upgrade
autoremove


TEXT="install ZSH"
if confirm; then
    # ZSH
    install_oh_my_z
    set_p10k_config
    zsh
fi

TEXT="install Programs"
if confirm; then
    # PROGRAMS
    install_essentials
fi

TEXT="install Laravel Dev Pack"
if confirm; then
    # Laravel Dev Pack
    install_laravel_pack
fi

# BYE
bye_screen

TEXT="reboot system"
if confirm; then
    sudo reboot now
fi
