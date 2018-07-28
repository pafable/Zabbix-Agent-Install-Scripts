#!/bin/bash 

rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.11-1.el7.x86_64.rpm
yum install zabbix-agent

mv /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf_bak
BAKFILE=/etc/zabbix/zabbix_agentd.conf_bak

ZBXAGNT() {
cat > /etc/zabbix/zabbix_agentd.conf << EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
EnableRemoteCommands=1
Server=<Enter IP of Zabbix master server >
ServerActive=<Enter IP of proxy or server or both>
ListenPort=10050
Include=/etc/zabbix/zabbix_agentd.d/*.conf
EOF
}

if [[ -f $BAKFILE ]]; 
then
	ZBXAGNT
fi

setsebool -P zabbix_can_network on && setsebool -P httpd_can_connect_zabbix on
systemctl start zabbix-agent.service
systemctl enable zabbix-agent.service
