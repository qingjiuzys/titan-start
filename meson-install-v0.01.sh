# 处理命令行参数
meson_gaga_code = ""
install_meson_cdn = ""

show_help() {
    cat << EOF

################################### 帮助信息 ###################################

Usage: ${0##*/} [OPTIONS]

OPTIONS:
    --meson_gaga_code CODE   Meson GAGA 绑定码，不填写则不安装。
    --meson_cdn_code CODE    Meson CDN 绑定码，不填写则不安装。
    -h / --help              显示此帮助信息并退出。

注意:
    - NFS需要存储空间限制为2T（目前不知道官方支持最大的多少）。
    - NFS提前挂载目录为：/mnt/titan。

资源链接:
    - 微信：checkHeart666
    - 代码库（欢迎点赞）： https://github.com/qingjiuzys/titan-start
    - titan注册链接：https://test1.titannet.io/intiveRegister?code=wLFnFN
    - meson注册链接：https://dashboard.gaganode.com/register?referral_code=qpkofealpfaomjb
    - titan官网：https://titannet.io/
    - titan存储服务：https://storage.titannet.io/
    - titan测试节点控制台：https://test1.titannet.io/
    - titan中文文档：https://titannet.gitbook.io/titan-network-cn

################################################################################
EOF
}


while [ "$#" -gt 0 ]; do
    case "$1" in
        --meson_gaga_code=*) meson_gaga_code="${1#*=}" ;;
        --meson_cdn_code=*) meson_cdn_code="${1#*=}" ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "未知参数: $1" ; show_help; exit 1 ;;
    esac
    shift
done


#!/bin/bash

# Meson GAGA 环境变量定义
MESON_GAGA_BIN_URL="https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz"

# Meson CDN 环境变量定义
MESON_CDN_BIN_URL="https://staticassets.meson.network/public/meson_cdn/v3.1.20/meson_cdn-linux-amd64.tar.gz"

# 安装 Meson GAGA
install_meson_gaga() {
    if [ -n "$meson_gaga_code" ]; then
        echo "******************正在安装 Meson GAGA******************"
        wget -O apphub-linux-amd64.tar.gz $MESON_GAGA_BIN_URL
        tar -zxf apphub-linux-amd64.tar.gz
        rm -f apphub-linux-amd64.tar.gz
        sudo ./apphub-linux-amd64/apphub service remove
        sudo ./apphub-linux-amd64/apphub service install
        sleep 20
        sudo ./apphub-linux-amd64/apphub service start
        sleep 30 
        ./apphub-linux-amd64/apphub status
        sleep 20
        sudo ./apphub-linux-amd64/apps/gaganode/gaganode config set --token=$meson_gaga_code
        ./apphub-linux-amd64/apphub restart
        echo "******************Meson GAGA 安装结束******************"
    else
        echo "******************未提供 Meson GAGA 代码，跳过安装******************"
    fi
}

# 安装 Meson CDN
install_meson_cdn() {
    if [ -n "$meson_cdn_code" ]; then
        echo "******************正在安装 Meson CDN******************"
        wget $MESON_CDN_BIN_URL -O meson_cdn-linux-amd64.tar.gz
        tar -zxf meson_cdn-linux-amd64.tar.gz
        rm -f meson_cdn-linux-amd64.tar.gz
        cd ./meson_cdn-linux-amd64
        sudo ./service install meson_cdn
        sleep 20
        sudo ./meson_cdn config set --token=$meson_cdn_code --https_port=443 --cache.size=30
        sleep 20
        sudo ./service start meson_cdn
        echo "******************Meson CDN 安装结束******************"
    else
        echo "******************未提供 Meson CDN 代码，跳过安装******************"
    fi
}

install_meson_gaga
install_meson_cdn

