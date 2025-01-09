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

setup_rom2109() {
    echo "Setting up ROM2109..."
    if [ -e "$ROM2109_DRIVER_PATH" ]; then
    	ln -sf "$ROM2109_DRIVER_PATH" "$DEVEL_WS_SRC/" # Driver Link
    	ln -sf "$GIT_REPO_PATH/developer_packages/rom2109" "$DEVEL_WS_SRC/" #developer packages Link
    	ln -sf "$GIT_REPO_PATH/maintain_codes" "$MAINTAIN_WS_SRC/" #maintain codes 
    	ls -l $DEVEL_WS_SRC/ $MAINTAIN_WS_SRC/ # check links
    	echo "export ROM_ROBOT_MODEL=rom2109" >> $HOME/.bashrc # လိုလားမလိုလား ပြန်စစ်ရန်။
        echo "Successfully Initialized build environment for ROM2109 driver, developer_packages, maintain_codes."
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
    	echo "export ROM_ROBOT_MODEL=bobo" >> $HOME/.bashrc # လိုလားမလိုလား ပြန်စစ်ရန်။
        echo "Successfully Initialized build environment For BO BO driver, developer_packages, maintain_codes."
    else
        echo "Error: BOBO driver path does not exist: $BOBO_DRIVER_PATH"
        exit 1
    fi
}

request_rom2109_or_bobo(){
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
    sync -v; sleep 2
    clear
}

build_install(){
	echo "export=$HOME/devel_ws/install/setup.bash" >> $HOME/.bashrc
	echo "export=$HOME/maintain_ws/install/setup.bash" >> $HOME/.bashrc
	
	## Development Purpose
	echo "export USE_JOYSTICK=true" >> $HOME/.bashrc
	echo "export LINEAR_SPEED='0.1'">> $HOME/.bashrc
	echo "export ANGULAR_SPEED='0.08'" >> $HOME/.bashrc
	##

	echo "alias bb='colcon build && source install/setup.bash'">> $HOME/.bashrc
	echo "alias delete_workspace='rm -rf build install log'">> $HOME/.bashrc
	echo "alias bb_save='colcon build --executor sequential --parallel-workers 4'">> $HOME/.bashrc
	
	echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp">> $HOME/.bashrc
	echo "export ROS_DOMAIN_ID=0">> $HOME/.bashrc

	cd $DEVEL_WS_SRC/../ ; colcon build ; ## မအောင်မြင်ရင်စာလာပြ။
	echo "developer_packages are built successfully now."
	cd $MAINTAIN_WS_SRC/../ ; colcon build --executor sequential --parallel-workers 4 ;
	echo "maintain_ws is built successfully now."
}

clean_source_code(){
	rm -rf $DEVEL_WS_SRC
	rm -rf $MAINTAIN_WS_SRC
	rm -rf $GIT_REPO_PATH
}

main() {
    if check_user; then
        echo "Success: Username is matched!"
        acquire_data_from_usb_stick
        setup_rom2109_or_bobo
        build_install
        clean_source_code
    else
        echo "Error: Username does not match. Bye !"
        exit 1
    fi
}

main
