#!/bin/bash

# Maintainer : ROM Dynamics Co., Ltd.

DESKTOP_GIT=$HOME/Desktop/Git
GIT_REPO_PATH="$HOME/Desktop/Git/rom_dynamics_robots"
DEVEL_WS_SRC="$HOME/devel_ws/src"
MAINTAIN_WS_SRC="$HOME/maintain_ws/src"
ROM2109_DRIVER_PATH="$GIT_REPO_PATH/drivers/stm32f103_driver"
BOBO_DRIVER_PATH="$GIT_REPO_PATH/drivers/stm32f407_driver"

check_user() {
    local username=$(whoami)
    if [ "$username" == "mr_robot" ]; then
        return 0  
    else
        return 1  
    fi
}

ros2_humble_installation(){

}

ros2_humble_dependencies_installation(){
	
}


setup_rom2109() {
    echo "Setting up ROM2109..."
    if [ -e "$ROM2109_DRIVER_PATH" ]; then
    	ln -sf "$ROM2109_DRIVER_PATH" "$DEVEL_WS_SRC/" # Driver Link
    	ln -sf "$GIT_REPO_PATH/developer_packages/rom2109" "$DEVEL_WS_SRC/" #developer packages Link
    	ln -sf "$GIT_REPO_PATH/maintain_codes" "$MAINTAIN_WS_SRC/" #maintain codes 
    	ls -l $DEVEL_WS_SRC/ $MAINTAIN_WS_SRC/ # check links
        echo "Successfully Initialized build environment for ROM2109 driver, developer_packages, maintain_codes."
        sleep 1
    else
        echo "Error: ROM2109 driver path does not exist: $ROM2109_DRIVER_PATH"
        exit 1
    fi
}


setup_bobo() {
    echo "Setting up BOBO..."
    if [ -e "$BOBO_DRIVER_PATH" ]; then
        ln -sf "$BOBO_DRIVER_PATH" "$DEVEL_WS_SRC/" # Driver Link
    	ln -sf "$GIT_REPO_PATH/developer_packages/bobo" "$DEVEL_WS_SRC/" #developer packages Link
    	ln -sf "$GIT_REPO_PATH/maintain_codes" "$MAINTAIN_WS_SRC/" #maintain codes 
    	ls -l $DEVEL_WS_SRC/ $MAINTAIN_WS_SRC/	# check links
        echo "Symbolic links are created for BOBO driver."

        echo "Successfully Initialized build environment For BO BO Robot."
    else
        echo "Error: BOBO driver path does not exist: $BOBO_DRIVER_PATH"
        exit 1
    fi
}



acquire_data_from_usb_stick() {
    echo "Copying source from USB to Robot."
    mkdir -pv $DESKTOP_GIT
    #unzip လုပ်ဖို့လိုမလို ထပ်မံစစ်ရန်။
    #unzip rom_dynamics_robots-unstable-v-0.0.zip -d $HOME/Git/
    #unzip မလုပ်ပဲ copy ပဲကူးမယ်ဆိုရင်stick မှာရှိတဲ့ dir name ကို ပြင်ရန်။
    cp -rv ../../rom_dynamics_robots-unstable-v-0.0 $GIT_REPO_PATH || {
        echo "Error copying files. Ensure the USB stick contains the correct directory."
        exit 1
    }
    sleep 2
    clear

    echo "Creating build environment... Please wait!"
    mkdir -pv $DEVEL_WS_SRC

 
    while true; do
        read -p "Choose robot models (rom2109 or bobo): " model
        if [ "$model" == "rom2109" ]; then
            setup_rom2109
            break
        elif [ "$model" == "bobo" ]; then
            setup_bobo
            break
        else
            echo "Invalid input. Please enter 'rom2109' or 'bobo'."
        fi
    done
}

main() {
    if check_user; then
        echo "Success: Username is matched!"
        acquire_data_from_usb_stick
    else
        echo "Error: Username does not match. Bye !"
        exit 1
    fi
}

main
