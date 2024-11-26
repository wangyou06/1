#!/bin/bash

# 多語言提示

    MSG_WELCOME="\033[33m欢迎使用 TOKI-ccminerARM！\033[0m\n\033[36m这是专门为 Android 手机或单板电脑（如树莓派）制作的 VerusCoin 挖矿软件。\033[0m\n\n\033[34mGitHub: https://github.com/TokiZeng/TOKI-ccminerARM\033[0m\n\033[34mYouTube: 熔炉 FORGE THE MAKER\033[0m\n"
    MSG_ENV="\033[36m默认环境为 UserLAnd 的 Ubuntu，如果在其他地方使用需要手动修改。\033[0m"
    MSG_FUNCTION_SELECT="\033[33m请选择一个功能:\033[0m"
    MSG_FUNCTION_INSTALL="\033[32m1) 全新安装\033[0m"
    MSG_FUNCTION_UPDATE="\033[32m2) 更新二进制文件\033[0m"
    MSG_SELECT_ARCH="\033[33m请选择您的架构:\033[0m"
    MSG_DEP_DOWNLOAD="\033[36m正在下载所有依赖文件...\033[0m"
    MSG_DEP_EXTRACT="\033[36m正在解压依赖文件...\033[0m"
    MSG_BINARY_UPDATE="\033[36m正在更新二进制文件...\033[0m"
    MSG_JSON_PROMPT="\033[33m请输入配置文件的相关选项，直接按 Enter 使用默认值:\033[0m"
    MSG_THREADS="\033[33m请输入使用的核心数（默认: 8）：\033[0m"
    MSG_POOL_URL="\033[33m请输入矿池地址（默认: stratum+tcp://us.vipor.net:5040）：\033[0m"
    MSG_WALLET="\033[33m请输入钱包地址（默认: RXZSmaHbqshL5kQQBtNiXx6WwdpHQpSgeU）：\033[0m"
    MSG_MINER_NAME="\033[33m请输入矿工名称（默认: 101）：\033[0m"
    MSG_SUCCESS="\033[32m安装成功！运行方式为：./start.sh\033[0m"
    MSG_RECONFIG="\033[36m如需重新设置，请重新运行此脚本或直接修改 ~/config.json\033[0m"
    MSG_UPDATE_COMPLETE="\033[32m二进制文件更新完成！可以直接运行 ./start.sh 开始挖矿。\033[0m"


# 歡迎信息
echo -e "$MSG_WELCOME"

# 功能選擇
echo -e "\033[33m=============================================================\033[0m"
echo -e "$MSG_FUNCTION_SELECT"
echo -e "$MSG_FUNCTION_INSTALL"
echo -e "$MSG_FUNCTION_UPDATE"
echo -e "\033[33m=============================================================\033[0m"
read -p "Enter your choice (default: Full Installation): " action_choice
action_choice=${action_choice:-1}

# 功能選擇處理

    echo -e "\033[32m1) A53\033[0m"


     miner_url="https://github.com/TokiZeng/TOKI-ccminerARM/releases/download/latest/ccminerA53.tar.gz"

    echo -e "$MSG_BINARY_UPDATE"
    wget -q "$miner_url" -O /tmp/miner.tar.gz
    tar -xzf /tmp/miner.tar.gz -C ~
    echo -e "$MSG_UPDATE_COMPLETE"
    exit 0



# 全新安裝邏輯
echo -e "$MSG_ENV"

echo -e "$MSG_SELECT_ARCH"
echo -e "\033[32m1) A53\033[0m"

    miner_url="https://github.com/TokiZeng/TOKI-ccminerARM/releases/download/latest/ccminerA53.tar.gz"

echo -e "$MSG_DEP_DOWNLOAD"
wget -q "$miner_url" -O /tmp/miner.tar.gz
wget -q "https://github.com/TokiZeng/TOKI-ccminerARM/releases/download/latest/Dependency.tar.gz" -O /tmp/dependency.tar.gz

echo -e "$MSG_DEP_EXTRACT"
tar -xzf /tmp/miner.tar.gz -C ~
tar -xzf /tmp/dependency.tar.gz -C ~

export LD_LIBRARY_PATH=~/Dependency:$LD_LIBRARY_PATH
echo 'export LD_LIBRARY_PATH=~/Dependency:$LD_LIBRARY_PATH' >> ~/.bashrc

echo -e "$MSG_JSON_PROMPT"

read -p "$(echo -e $MSG_THREADS)" threads
threads=${threads:-8}

read -p "$(echo -e $MSG_POOL_URL)" pool_url
pool_url=${pool_url:-stratum+tcp://us.vipor.net:5040}

read -p "$(echo -e $MSG_WALLET)" wallet
wallet=${wallet:-RXZSmaHbqshL5kQQBtNiXx6WwdpHQpSgeU}

read -p "$(echo -e $MSG_MINER_NAME)" miner_name
miner_name=${miner_name:-TOKI}

cat > ~/config.json <<EOL
{
    "algo": "verus",
    "threads": $threads,
    "cpu-priority": 3,
    "max-log-rate": 60,
    "quiet": false,
    "debug": false,
    "protocol": false,
    "url": "$pool_url",
    "user": "$wallet.$miner_name",
    "pass": "x"
}
EOL

cat > ~/start.sh <<EOL
#!/bin/bash

export LD_LIBRARY_PATH=~/Dependency:$LD_LIBRARY_PATH

./ccminer -c config.json
EOL

chmod +x ~/start.sh

echo -e "$MSG_SUCCESS"
echo -e "$MSG_RECONFIG"

