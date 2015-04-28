#!/bin/bash

function export_env(){
    source build/envsetup.sh
    lunch $TARGET_PRODUCT-eng
}

#Choose Chip
if [ "$1" == "802" ] || [ "$1" == "k200" ] || [ "$1" == "s802" ];
then 
    export TARGET_PRODUCT=k200
    export BOARD_REVISION=b_2G
    export PROJECT_ID=k200b_2G
elif [ "$1" == "812" ] || [ "$1" == "s812" ] || [ "$1" == "n200" ];
then 
    export TARGET_PRODUCT=n200
elif [ "$1" == "m802" ] || [ "$1" == "k100" ];
then 
    export TARGET_PRODUCT=k100
    export K100_DDR_SIZE=k100_2G_ddr
else
    export TARGET_PRODUCT=m201
fi

#You can do "source make.sh" in amlogic root dir.
echo $0
if [ "$0" == "-bash" ] || [ "$0" == "bash" ] || [ "$0" == "sh" ];
then
    export_env
    return 0
fi


#You can run this script in any path.
SCRIPT_FILE=$0
while [ -L $SCRIPT_FILE ]
do
    SCRIPT_FILE=`readlink $SCRIPT_FILE`
done
cd `dirname $SCRIPT_FILE`

#Functions

function make_all(){
    export_env
    img_clean
    make_uboot
    make_img
    gen_usb
    gen_ota
}

function make_uboot(){
    export_env
    cd uboot
    rm -rf ./build/*
    if [ "$TARGET_PRODUCT" == "k200" ];then
        make m8_k200_v1_config
    elif [ "$TARGET_PRODUCT" == "n200" ];then
        make m8m2_n200_v1_config
    elif [ "$TARGET_PRODUCT" == "m201" ];then
        make m8b_m201_1G_config
    elif [ "$TARGET_PRODUCT" == "k100" ];then
        make m8_k100_2G_config
    fi
    make -j4
    cp -rf ./build/u-boot.bin ../device/amlogic/$TARGET_PRODUCT/
    cp -rf ./build/ddr_init.bin ../device/amlogic/$TARGET_PRODUCT/
    cp -rf ./build/u-boot-comp.bin ../device/amlogic/$TARGET_PRODUCT/
    cp -rf ./build/u-boot.bin.aml ../device/amlogic/$TARGET_PRODUCT/
    cp -rf ./build/u-boot-usb.bin.aml ../device/amlogic/$TARGET_PRODUCT/

    cd ..
}

function make_bootimg(){
    export_env
    ./device/amlogic/$TARGET_PRODUCT/quick_build_kernel.sh bootimage
}

function make_img(){
    export_env
    make -j4 
    if [ ! -d "/home/ftp/amlogic_release" ];then
        mkdir -p /home/ftp/amlogic_release
    fi
    cp out/target/product/$TARGET_PRODUCT/aml_upgrade_package.img /home/ftp/amlogic_release/aml-$TARGET_PRODUCT-`date "+%F_%H.%M.%S"`.img
}

function gen_usb(){
    export_env
    echo $PWD
    cd bootable/recovery/mkrecovery
    if [ "$?" == "0" ] && [ "$(pwd|awk -F / '{printf $NF}')" == "mkrecovery" ];then
        ./mkrecovery-usb.sh $TARGET_PRODUCT
        cd -
        if [ ! -d "/home/ftp/amlogic_release" ];then
            mkdir -p /home/ftp/amlogic_release
        fi
        cp out/target/product/$TARGET_PRODUCT/package-out/ota/update-usb.zip /home/ftp/amlogic_release/update-usb-$TARGET_PRODUCT-`date "+%F_%H.%M.%S"`.zip
        cp out/target/product/$TARGET_PRODUCT/package-out/ota/update-usb.zip /home/ftp/amlogic_release/update-usb.zip
    else
        echo "cd bootable/recovery/mkrecovery error"
    fi
}

function gen_ota(){
    export_env
    echo $PWD
    cd bootable/recovery/mkrecovery
    if [ "$?" == "0" ] && [ "$(pwd|awk -F / '{printf $NF}')" == "mkrecovery" ];then
        ./mkrecovery-ota.sh $TARGET_PRODUCT
        cd -
        if [ ! -d "/home/ftp/amlogic_release" ];then
            mkdir -p /home/ftp/amlogic_release
        fi
        cp out/target/product/$TARGET_PRODUCT/package-out/ota/update-ota.zip /home/ftp/amlogic_release/update-ota-$TARGET_PRODUCT-`date "+%F_%H.%M.%S"`.zip
        cp out/target/product/$TARGET_PRODUCT/package-out/ota/update-ota.zip /home/ftp/amlogic_release/update-ota.zip
    else
        echo "cd bootable/recovery/mkrecovery error"
    fi
}

function rebuild_all(){
    rm -rf ./out
    make_all
}

function daily_build(){
    svn up
    rm -rf ./out
    make_all
    if [ "$TARGET_PRODUCT" == k200 ];
    then
        export TARGET_PRODUCT=m201
    else
        export TARGET_PRODUCT=k200
        export BOARD_REVISION=b_2G
    fi
    make_all
}

function update_api(){
    export_env
    make update-api
}

function copy_jars(){
    cp  out/target/common/obj/JAVA_LIBRARIES/framework_intermediates/classes.jar /srv/ftp/framework.jar
    cp  out/target/common/obj/JAVA_LIBRARIES/framework2_intermediates/classes.jar /srv/ftp/framework2.jar
}

function img_clean(){
    rm -f  hardware/arm/gpu/mali/__malidrv_build_info.c
    rm -f  uboot/arch/arm/cpu/aml_meson/m8/firmware/smp.dat
    rm -f  uboot/arch/arm/cpu/aml_meson/m8b/firmware/smp.dat
    rm -rf uboot/build
    cd out/target/product/$TARGET_PRODUCT
    if [ "$?" == "0" ] && [ "$(pwd|awk -F / '{printf $NF}')" == "$TARGET_PRODUCT" ];then
        rm -rf `ls|grep -v "obj"`
        cd -
    fi
}

function install_amlogic_tools(){

    if [ "$(id -u)" != "0" ]; then
        echo "install_amlogic_tools:Only Root Can Do This"
        exit 1
    fi

    URL_HEAD="http://172.16.55.226"
	wget $URL_HEAD/deploy/CodeSourcery.tar.gz -P /tmp
	tar -zxvf /tmp/CodeSourcery.tar.gz -C /opt
	wget $URL_HEAD/deploy/gnutools.tar.gz -P /tmp
	tar -zxvf /tmp/gnutools.tar.gz -C /opt
	wget $URL_HEAD/deploy/gcc-linaro-arm-linux-gnueabihf.tar.gz -P /tmp
	tar -zxvf /tmp/gcc-linaro-arm-linux-gnueabihf.tar.gz -C /opt
	wget $URL_HEAD/deploy/arc-4.8-amlogic-20130904-r2.tar.gz  -P /tmp
	tar -zxvf /tmp/arc-4.8-amlogic-20130904-r2.tar.gz -C /opt/gnutools

	wget $URL_HEAD/deploy/arc_gnutools.sh -P /etc/profile.d
	wget $URL_HEAD/deploy/arm_path.sh -P /etc/profile.d
	wget $URL_HEAD/deploy/arm_new_gcc.sh -P /etc/profile.d
	wget $URL_HEAD/deploy/arc_new_tools.sh -P /etc/profile.d
}

FUNCTION_ARRAY=("help" "make_all" "make_uboot" "make_bootimg" "make_img" "gen_usb" "gen_ota" "rebuild_all" "daily_build" "update_api" "copy_jars" "img_clean" "install_amlogic_tools")

####DO NOT EDIT CODE UNDER THIS LINE####
FUNCTION_NUM=`expr ${#FUNCTION_ARRAY[@]} - 1`

echo "***************************************************"
echo -e "                    \033[31m$TARGET_PRODUCT\033[0m"
echo "***************************************************"
echo "Please Choose Function"
for I in `seq $FUNCTION_NUM`
do
    echo "$I: ${FUNCTION_ARRAY[$I]}"
done


if [ "$2" == "" ];
then
    echo "Please Enter Number:"
    read FUNCTION
else
    FUNCTION=$2
fi
echo ""

for I in `seq $FUNCTION_NUM`
do
    if [ "$FUNCTION" == "$I" -o "$FUNCTION" == "${FUNCTION_ARRAY[$I]}" ];
    then
        echo "Choose ${FUNCTION_ARRAY[$I]}"
        ${FUNCTION_ARRAY[$I]}
        exit $?
    fi
done
echo "SCRIPT ERROR: FUNCTION \"$FUNCTION\" NOT EXIST!"

