# docker build -t ybrdx/sshd-authkeys .
# docker run -dt --name ssh-gtw -e "AUTHORIZED_KEYS=`cat ~/.ssh/id_rsa.pub`" -p 22 --net my_network ybrdx/sshd-authkeys
# ssh -ND 0.0.0.0:8157 -p EXPOSED_PORT -i ~/.ssh/id_rsa root@127.0.0.1 -v
# jconsole -J-DsocksProxyHost=localhost -J-DsocksProxyPort=8157 service:jmx:rmi:///jndi/rmi://my_service:1099/jmxrmi

FROM danielguerra/alpine-sshd:3.4

MAINTAINER ybrdx <yohann.bredoux@gmail.com>

COPY start.sh /

CMD /start.sh