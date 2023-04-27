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

    sudo timedatectl set-timezone America/Sao_Paulo && sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

    echo -e "\n\e[92m    [✔] Config Jornalctl configured\e[39m\n"

    echo -e "\n\e[39m[+] Install packages\e[39m\n"

    sudo apt install git curl wget net-tools software-properties-common acl unzip htop ncdu -y

    echo -e "\n\e[92m    [✔] Packages Installed\e[39m\n"
}

limit_jornalctl() {
    echo -e "\n\e[39m[+] Config Jornalctl Files\e[39m\n"

    sudo journalctl --vacuum-time=2d && sudo journalctl --vacuum-size=500M

    echo -e "\n\e[92m    [✔] Config Jornalctl configured\e[39m\n"
}

install_oh_my_z() {
    sudo apt install zsh fonts-powerline dconf-cli -y && zsh --version

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
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
        echo -e "\n\e[92m    [✔] powerlevel10k installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] powerlevel10k is already installed\e[39m\n"
    fi

    echo -e "\n\e[39m[+] Checking zsh-autosuggestions\e[39m\n"

    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        echo -e "\n\e[92m    [✔] zsh-autosuggestions installed\e[39m\n"
    else
        echo -e "\n\e[92m    [✔] zsh-autosuggestions is already installed\e[39m\n"
    fi

    echo -e "\n\e[39m[+] Checking zsh-syntax-highlighting\e[39m\n"

    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
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

    # cp .p10k.zsh $HOME/
    cp .zshrc_aliases $HOME/
    source $HOME/.zshrc

    echo -e "\n\e[92m    [✔] .p10k.zsh and .zshrc_aliases configured\e[39m\n"
}


remove_libreoffice() {
    echo -e "\n\e[39m[+] Checking LibreOffice\e[39m\n"

    sudo apt-get remove libreoffice-core -y

    echo -e "\n\e[92m    [✔] LibreOffice Removed\e[39m\n"
}

#RUN SCRIPT

welcome_screen
check_operating_system
limit_jornalctl
remove_libreoffice
update_upgrade
install_oh_my_z
set_p10k_config