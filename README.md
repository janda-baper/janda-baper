# jandaa
apt-get update && apt-get upgrade -y && update-grub && rm -f setup.sh && sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl && wget https://raw.githubusercontent.com/janda-baper/janda-baper/main/setup.sh && chmod +x setup.sh && bash setup.sh && rm -f setup.sh

apt-get update && apt-get upgrade -y && update-grub && rm -f setup-kadal.sh && sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl && wget https://raw.githubusercontent.com/janda-baper/janda-baper/main/setup-kadal.sh && chmod +x setup-kadal.sh && bash setup-kadal.sh && rm -f setup-kadal.sh
