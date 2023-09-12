#!/bin/bash
#
# This script is used to convert a general linux operating system to NestOS.
#

# Copyright (c) 2023 KylinSoft Co., Ltd.
# X2NestOS is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#             http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
#
set -eu -o pipefail

# 关键变量初始化

# 安装目标设备
# 不推荐vda这种写法，但可以自动转换为/dev/vda
# Example: install_dev='/dev/vda'
install_dev=''

# 安装配置信息
# 必须使用远端ign地址，本地ign无法拷贝到live环境中，无法识别
# error: Invalid value "config.ign" for '--ignition-url <URL>': relative URL without a base
# Example: install_ignition='http://10.44.55.32/config.ign'
install_ignition=''

# 安装镜像位置
# 请提供NestOS安装镜像的本地位置
# Example: install_source='nestos-22.03-LTS-SP2.20230704.0-live.x86_64.iso'
install_source=''

print_help() {
    echo "Usage:"
    echo "  $0 [-d DEVICE] [-i IGNITION_URL]"
    echo "  -d, --dev DEVICE          Specify the installation target device (e.g., /dev/vda)"
    echo "  -i, --ignition-url        IGNITION_URL Specify the URL for the Ignition config"
    echo "  -s, --install-source      The path where the NestOS installation ISO is located, may require you to download it locally in advance"
    echo "  --debug                   Output every commands during the execution process"
    echo "  -h, --help                Display this help message"
}

open_debug() {
    set -x
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Error: This script must be run with root privileges."
        exit 1
    fi
}

parse_args() {
    if [ $# -eq 0 ]; then
        print_help
        exit 0
    fi

    local is_debug=0
    while [[ $# -gt 0 ]]; do
        key="$1"

        case $key in
        --debug)
            is_debug=1
            shift 1
            ;;
        -d | --dev)
            install_dev="$2"
            shift 2
            ;;
        -i | --ignition-url)
            if [[ "$2" =~ ^http[s]?:\/\/[^\s/$.?#].[^\s]*$ ]]; then
                install_ignition="$2"
                shift 2
            else
                echo "Error: Invalid Ignition URL provided for -i option."
                echo "Warning: An incorrect ignition will cause the system to fail to start"
                exit 1
            fi
            ;;
        -s | --install-source)
            install_source="$2"
            shift 2
            ;;
        -h | --help)
            print_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            print_help
            exit 1
            ;;
        esac
    done

    if [ "$is_debug" -eq 1 ]; then
        echo -e "\033[;31;1mOpen Debug Mode\033[0m"
        open_debug
    fi

    # 关键参数校验start
    if [[ -z "$install_dev" ]]; then
        echo "Error: Installation device (-d) is required."
        print_help
        exit 1
    fi

    if [[ -z "$install_ignition" ]]; then
        echo "Error: Ignition URL (-i) is required."
        print_help
        exit 1
    fi

    if [[ -z "$install_source" ]]; then
        echo "Error: Installation image path (-s) is required."
        print_help
        exit 1
    fi
    # 关键参数校验end
}

install_package() {
    local packages=("$@")
    local package_manager=""

    # 检查系统软件包管理器类型
    if command -v yum &>/dev/null; then
        package_manager="yum"
    elif command -v apt-get &>/dev/null; then
        package_manager="apt"
    else
        echo "Error: Unsupported package manager."
        exit 1
    fi

    for package in "${packages[@]}"; do
        local package_status=""

        # 根据不同的软件包管理器进行是否安装检查
        if [ "$package_manager" == "yum" ]; then
            package_status=$(rpm -qa | grep "$package")
        elif [ "$package_manager" == "apt" ]; then
            package_status=$(dpkg -l | grep "ii $package")
        fi

        if [ -z "$package_status" ]; then
            if [ "$package_manager" == "yum" ]; then
                yum install -y "$package"
            elif [ "$package_manager" == "apt" ]; then
                apt-get install -y "$package"
            fi
        fi
    done
}

# 解析传入参数
parse_args "$@"

# 检查是否为 root 权限
check_root

# 获取、挂载、校验安装镜像
if [ ! -f "$install_source" ]; then
    echo "Error: The specified install image $install_source does not exist."
    exit 1
fi

if [ ! -d '/cdrom' ]; then
    mkdir /cdrom
fi

if [ ! -d '/cdrom/images' ]; then
    mount -o loop "$install_source" /cdrom
fi

# 安装依赖软件包
install_package kexec-tools

# 提取安装文件
kernel='/cdrom/images/pxeboot/vmlinuz'
initramfs='/cdrom/images/pxeboot/initrd.img'
rootfs='/cdrom/images/pxeboot/rootfs.img'
if [ ! -f './combined.img' ]; then
    cat $initramfs $rootfs >combined.img
fi

# 执行转换为NestOS操作

while true; do
    read -rp $'\033[;31;1m警告：\033[0m''即将开始执行转换为NestOS操作，此操作会丢失目标安装磁盘全部数据，并存在无法引导的风险，是否继续？ (y/n): ' choice
    case $choice in
    [Yy] | [Yy][Ee][Ss])
        echo "Continuing..."
        break
        ;;
    [Nn] | [Nn][Oo])
        echo "Canceled."
        exit 0
        ;;
    *)
        echo "Please enter 'y' or 'n'."
        ;;
    esac
done

kexec -l $kernel --initrd=./combined.img --command-line="nestos.inst.install_dev=${install_dev} nestos.inst.ignition_url=${install_ignition} console=ttyS0"
systemctl kexec
