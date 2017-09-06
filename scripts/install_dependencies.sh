#!/bin/bash

# Install Cassandra

apt-get update

apt-get install -y software-properties-common wget curl

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections 
add-apt-repository -y ppa:webupd8team/java
apt-get install -y oracle-java8-installer
CASSANDRA_VERSION='3.11.0'
CASSANDRA_PATH="cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz"
CASSANDRA_DOWNLOAD='http://www.apache.org/dyn/closer.cgi?path=/${CASSANDRA_PATH}&as_json=1'
CASSANDRA_MIRROR=`curl -s ${CASSANDRA_DOWNLOAD} | grep -oP "(?<=\"preferred\": \")[^\"]+"`
wget $CASSANDRA_MIRROR$CASSANDRA_PATH
tar -zxf apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz
mv apache-cassandra-${CASSANDRA_VERSION} /usr/local/cassandra
mkdir /var/lib/cassandra && mkdir /var/log/cassandra
Private_IP=`wget -qO- http://169.254.169.254/latest/meta-data/local-ipv4`
sudo sed -i 's|rpc_address: localhost|rpc_address: 0.0.0.0|g' /usr/local/cassandra/conf/cassandra.yaml
sudo sed -i "s|# broadcast_rpc_address: 1.2.3.4|broadcast_rpc_address: "$Private_IP"|g" /usr/local/cassandra/conf/cassandra.yaml

# Install Kong
apt-get install -y openssl libpcre3 procps perl wget
KONG_VERSION='0.10.3'
wget https://github.com/Mashape/kong/releases/download/${KONG_VERSION}/kong-${KONG_VERSION}.trusty_all.deb
apt-get update
dpkg -i kong-${KONG_VERSION}.*.deb
apt-get install -fy
cp /etc/kong/kong.conf.default /etc/kong/kong.conf
echo "database=cassandra" >> /etc/kong/kong.conf

# Install Dashboard
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
apt-get install -y nodejs
npm install -g kong-dashboard@v2

# Install DotNet Core
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-trusty-prod trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-get update
apt-get install -y netcat
sudo apt-get install -y git curl python-pip unzip zip dotnet-sdk-2.0.0 supervisor

sudo cat << EOF > /etc/supervisor/conf.d/dotnetweb.conf
[program:dotnetweb]
command=/usr/bin/dotnet /home/ubuntu/web/bin/Debug/netcoreapp2.0/publish/DSLibrary.dll
directory=/home/ubuntu/web/bin/Debug/netcoreapp2.0/publish/
autostart=true
autorestart=true
stderr_logfile=/var/log/dotnetweb.err.log
stdout_logfile=/var/log/dotnetweb.out.log
environment=ASPNETCORE_ENVIRONMENT=Production
user=www-data
stopsignal=INT
EOF

sudo service supervisor stop

