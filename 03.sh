#!/bin/bash

MSG_ENV="Enter your environment settings:"
MSG_SELECT_ARCH="Select your architecture:"
MSG_DEP_DOWNLOAD="Downloading dependencies..."
MSG_DEP_EXTRACT="Extracting dependencies..."
MSG_JSON_PROMPT="Configuring JSON settings..."
MSG_THREADS="Enter number of threads (default: 8): "
MSG_POOL_URL="Enter pool URL (default: stratum+tcp://ap.luckpool.net:3956): "
MSG_WALLET="Enter your wallet address (default: RXZSmaHbqshL5kQQBtNiXx6WwdpHQpSgeU): "
MSG_MINER_NAME="Enter miner name (default: TOKI): "
MSG_SUCCESS="Setup completed successfully."
MSG_RECONFIG="You may need to reconfigure or adjust settings if necessary."

echo -e "$MSG_ENV"

echo -e "$MSG_SELECT_ARCH"
echo -e "\033[32m1) A53\033[0m"
echo -e "\033[32m2) A55\033[0m"
read -p "Enter your choice (default: A53): " arch_choice
arch_choice=${arch_choice:-1}


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
pool_url=${pool_url:-stratum+tcp://ap.luckpool.net:3956}

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
