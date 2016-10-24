# Abstract

This docker image is built after [alpine-sshd](https://hub.docker.com/r/danielguerra/alpine-sshd/).

It adds a simple mean to create an authorized_keys file inside a container.

# Usage

## Your public key only in the authorization_keys

```docker run -dt -e "AUTHORIZED_KEYS=`cat ~/.ssh/id_rsa.pub`" -P ybrdx/sshd-authkeys```

## Use a sample authorized_keys in the container

```docker run -dt -e "AUTHORIZED_KEYS=`cat ~/.ssh/authorized_keys`" -P ybrdx/sshd-authkeys```

## Inside a docker compose network

```docker run -dt --name ssh-gtw -e "AUTHORIZED_KEYS=`cat ~/.ssh/id_rsa.pub`" -p 22 --net my_network ybrdx/sshd-authkeys```

# Motivation

I want a way to connect jconsole (a tool to monitor JVM memory profile and many other things)
but I do not want to keep the JMX port inside the network.

A way to achieve this is to have an ssh dynamic tunnel to provided by a container in the network exposing port 22.
This way you can plug jconsole to any container in the network seamlessly via its net alias or docker DNS.

## Example

Once you have the ssh gateway container running.

Retrieve its mapped port:
```docker port ssh-gtw```

Create a dynamic tunnel:
```ssh -ND 0.0.0.0:8157 -p MAPPED_PORT -i ~/.ssh/id_rsa root@127.0.0.1```

Launch jconsole:
```jconsole -J-DsocksProxyHost=localhost -J-DsocksProxyPort=8157 service:jmx:rmi:///jndi/rmi://my_service:1099/jmxrmi```

# Next step

Try it with a swarm.
