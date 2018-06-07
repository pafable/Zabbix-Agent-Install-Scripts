#!/bin/bash

echo
echo -n "Which AWS Bastion is this host being hosted on? (nv, ire, fra, cali, mum) :  "
read bastion
echo

#rpm -ivh http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm      
yum -y install zabbix-agent
mv /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf_bak

### Applies SELinux boolean values for Zabbix
setsebool -P zabbix_can_network on && setsebool -P httpd_can_connect_zabbix on

### Zabbix Agent Configuration Files for each Bastion
nv() {
cat > /etc/zabbix/zabbix_agentd.conf << EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
EnableRemoteCommands=1
Server=#Enter IP of Zabbix master server 
ServerActive=#Enter IP of region's proxy server
ListenPort=10050
HostMetadata=#Enter metadata for autoregistration
Include=/etc/zabbix/zabbix_agentd.d/*.conf
EOF
}

eu_ire() {
cat > /etc/zabbix/zabbix_agentd.conf << EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
EnableRemoteCommands=1
Server=#Enter IP of Zabbix master server
ServerActive=#Enter IP of region's proxy server
ListenPort=10050
HostMetadata=#Enter metadata for autoregistration
Include=/etc/zabbix/zabbix_agentd.d/*.conf
EOF
}

eu_fra() {
cat > /etc/zabbix/zabbix_agentd.conf << EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
EnableRemoteCommands=1
Server=#Enter IP of Zabbix master server
ServerActive=#Enter IP of region's proxy server
ListenPort=10050
HostMetadata=#Enter metadata for autoregistration
Include=/etc/zabbix/zabbix_agentd.d/*.conf
EOF
}

cali() {
cat > /etc/zabbix/zabbix_agentd.conf << EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
EnableRemoteCommands=1
Server=#Enter IP of Zabbix master server
ServerActive=#Enter IP of region's proxy server
ListenPort=10050
HostMetadata=#Enter metadata for autoregistration
Include=/etc/zabbix/zabbix_agentd.d/*.conf
EOF
}

### Applies correct configuration onto zabbix config files
if [[ $bastion = "nv" ]]; then
        echo
        echo "Configuring Zabbix agent for North Virginia proxies. "
        echo
        nv
        elif [[ $bastion = "ire" ]]; then
                echo
                echo "Configuring Zabbix agent for Ireland proxies. "
                echo
                eu_ire
        elif [[ $bastion = "fra" ]]; then
                echo
                echo "Configuring Zabbix agent for Frankfurt proxies. "
                echo
                eu_fra
        elif [[ $bastion = "cali" ]]; then
                echo
                echo "Configuring Zabbix agent for North California proxies. "
                echo
                cali
        elif [[ $bastion = "mum" ]]; then
                echo
                echo "Configuring Zabbix agent for Mumbai proxies. "
                echo
                mum
fi

### Starts Zabbix Agent
systemctl start zabbix-agent.service
systemctl enable zabbix-agent.service
echo
echo "Starting Zabbix Agent. "
echo
