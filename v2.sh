#! /bin/bash
echo && echo -e " sspanel v2ray一键对接脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
————————————对接管理————————————
 ${Green_font_prefix}1${Font_color_suffix} WS模式（落地机ip或者域名;落地机端口;2;ws;;path=/jiayou|host=落地机ip或者域名）
 ${Green_font_prefix}2.${Font_color_suffix} 加速脚本安装(推荐使用BBR2或BBRPlus)
ws中转模式填写：
落地机ip或者域名;落地机端口;2;ws;;path=/jiayou|host=落地机ip或者域名|relayserver=中转机ip或者域名|outside_port=中转机端口
————————————————————————————————" && echo
read -p "请选择对接模式(1,2)：" xuan
#网站地址
domain22='sspanel_url: "https://st.ninihao.me"'
#mukey
mukey='key: "xiaoyang"'
#面板节点id
read -p "  1.面板里添加完节点后生成的自增ID:" sid
rid='node_id: '$sid
#判断系统
os_pam() {

        os=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
        if [ "$os" == '"CentOS Linux"' ]; then
                echo "您的系统是"${os}"，开始进入脚本：(10秒之后开始)"
                sleep 10
                curl -fsSL https://get.docker.com | bash
                curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                chmod a+x /usr/local/bin/docker-compose
                rm -f `which dc`
                ln -s /usr/local/bin/docker-compose /usr/bin/dc
                systemctl start docker
                service docker start
                systemctl enable docker.service
                yum -y install ntpdate
                timedatectl set-timezone Asia/Shanghai
                ntpdate ntp1.aliyun.com
                systemctl disable firewalld
                systemctl stop firewalld
                systemctl start docker
                service docker start
        elif [ "$os" == '"Ubuntu"' ]; then
                echo "您的系统是"${os}"，开始进入脚本：(10秒之后开始)"
                sleep 10
                curl -fsSL https://get.docker.com | bash
                curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                chmod a+x /usr/local/bin/docker-compose
                rm -f `which dc`
                ln -s /usr/local/bin/docker-compose /usr/bin/dc
                systemctl start docker
                service docker starts
                systemctl enable docker.service
                apt-get install -y ntp
                service ntp restart
                ufw disable
                systemctl start docker
                service docker start
        fi
}

conf() {

        mkdir v2xy
        cd v2xy
        curl -L https://raw.githubusercontent.com/xiaoyanggo/v2rayshell/master/docker/docker-compose.yml >docker-compose.yml
        sed -i "s#sspanel_url.*#${domain22}#" docker-compose.yml
        sed -i "s/key.*/${mukey}/" docker-compose.yml
        sed -i "s/node_id.*/${rid}/" docker-compose.yml
}

case $xuan in
1)
        os_pam
        conf
        dc up -d
        echo "安装完成"
        echo "查看log日志命令 docker-compose logs | less"
        ;;
2)
        wget -N --no-check-certificate "https://github.000060000.xyz/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
        ;;
esac
