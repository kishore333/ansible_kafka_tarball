# Kafka Setup 

This is a simple Kafka setup. In this setup we are running `kafka` over a dedicated `zookeeper` service. 
(NOT the standalone zookeeper which comes with `kafka`)

Before we start read more information about Zookeeper/Kafka in the below link.
So that we get an idea of how the setup is done. 

1. Setup [Zookeeper](roles/zookeeper_install_tarball/README.md). 
2. Setup [Kafka](roles/kafka_install_tarball/README.md). Server running on ports 9091/9092 ports on each server.

## Before we start.

Please download [`kafka_2.9.2-0.8.2.1.tgz`](http://mirror.metrocast.net/apache/kafka/0.8.2.1/kafka_2.9.2-0.8.2.1.tgz) and store it in `file_archives` directory.**
Please download [`zookeeper-3.4.5-cdh5.1.2.tar.gz`](http://archive.cloudera.com/cdh5/cdh/5/zookeeper-3.4.5-cdh5.1.2.tar.gz) and store it in `file_archives` directory.**


## Step 1: Update Hosts File.

Update the host file to reflect your server IPs.
Currently `hosts` file looks as below.

    [zookeepers]
    10.10.18.10 zookeeper_id=1
    10.10.18.12 zookeeper_id=2
    10.10.18.13 zookeeper_id=3
    
    [kafka-nodes]
    10.10.18.10 kafka_broker_id1=11 kafka_port1=9091 kafka_broker_id2=12 kafka_port2=9092
    10.10.18.12 kafka_broker_id1=13 kafka_port1=9091 kafka_broker_id2=14 kafka_port2=9092
    10.10.18.13 kafka_broker_id1=15 kafka_port1=9091 kafka_broker_id2=16 kafka_port2=9092
    
## Step 2: Update `group_vars` information as required.

Update users/password and Directory information in `group_vars/all` file.
Currently we have the below information.
    
    # --------------------------------------
    # USERs
    # --------------------------------------
    
    zookeeper_user: zkadmin
    zookeeper_group: zkadmin
    zookeeper_password: $6$rounds=40000$1qjG/hovLZOkcerH$CK4Or3w8rR3KabccowciZZUeD.nIwR/VINUa2uPsmGK/2xnmOt80TjDwbof9rNvnYY6icCkdAR2qrFquirBtT1
    
    kafka_user: kafkaadmin
    kafka_group: kafkaadmin
    kafka_password: $6$rounds=40000$1qjG/hovLZOkcerH$CK4Or3w8rR3KabccowciZZUeD.nIwR/VINUa2uPsmGK/2xnmOt80TjDwbof9rNvnYY6icCkdAR2qrFquirBtT1
    
    
    # --------------------------------------
    # COMMON FOR INSTALL PATH
    # --------------------------------------
    
    # Common Location information.
    common:
      install_base_path: /usr/local
      soft_link_base_path: /opt

## Step 3: Update `default` information in `roles/<install_role>/default/main.yml`.

Update the `default` values if required.


## Step 4: Executing.

Below is the command. 
    
    ahmed@ahmed-server ansible_kafka_tarball]$ ansible-playbook ansible_kafka.yml -i hosts --ask-pass