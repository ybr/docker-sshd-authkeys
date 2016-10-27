# Abstract

This docker image is built after [alpine-sshd](https://hub.docker.com/r/danielguerra/alpine-sshd/).

It adds a simple mean to create an authorized_keys file inside a container.

# Usage

## Your public key only in the authorization_keys

```docker run -dtP -e "AUTHORIZED_KEYS=`cat ~/.ssh/id_rsa.pub`" ybrdx/sshd-authkeys```

## Use a sample authorized_keys in the container

```docker run -dtO -e "AUTHORIZED_KEYS=`cat ~/.ssh/authorized_keys`" ybrdx/sshd-authkeys```

## Inside a docker compose network

```docker run -dtP --name ssh-gtw -e "AUTHORIZED_KEYS=`cat ~/.ssh/id_rsa.pub`" --net my_network ybrdx/sshd-authkeys```

# Motivation

I want a way to connect jconsole (a tool to monitor JVM memory profile and many other things)
but I do want to keep the JMX port inside the network.

A way to achieve this is to have a ssh dynamic tunnel provided by a container in the network exposing port 22.
This way you can plug jconsole to any container in the network seamlessly via its net alias or docker DNS.

## Prerequisite

The JVM must be told to expose JMX, set the environment variable:
```JAVA_OPTS=-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false```

* [Docker CLI -e](https://docs.docker.com/engine/reference/run/#/env-environment-variables)
* [Docker file ENV](https://docs.docker.com/engine/reference/builder/#/env)
* [Docker compose file environment](https://docs.docker.com/compose/compose-file/#/environment)

## Example

Once you have the ssh gateway container running.

Retrieve its mapped port:
```docker port ssh-gtw```

Create a dynamic tunnel:
```ssh -ND 127.0.0.1:8157 -p MAPPED_PORT -i ~/.ssh/id_rsa root@127.0.0.1```

Launch jconsole:
```jconsole -J-DsocksProxyHost=localhost -J-DsocksProxyPort=8157 service:jmx:rmi:///jndi/rmi://my_service:1099/jmxrmi```

# Next step

Try it with a swarm.
