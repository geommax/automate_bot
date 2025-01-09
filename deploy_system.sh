#!/bin/bash

# Maintainer : ROM Dynamics Co., Ltd.

configure_rom2109(){
    #udev rule
    #tmux
    #network DOMAIN ID = 0 
    #autostart
    #web_deployment
}

configure_bobo(){

}

configure_rom2109_or_bobo(){
    echo "Configuring System Environment... Please wait!"
    while true; do
        read -p "Choose robot models (rom2109 or bobo): " model
        if [ "$model" == "rom2109" ]; then
            configure_rom2109
            break
        elif [ "$model" == "bobo" ]; then
            configure_bobo
            break
        else
            echo "Invalid input. Please enter 'rom2109' or 'bobo'."
        fi
    done
}

main() {
    configure_rom2109_or_bobo
}

main
