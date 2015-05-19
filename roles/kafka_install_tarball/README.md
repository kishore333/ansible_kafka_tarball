# Kafka Role.

Below are the steps to get started.

## Before we start.

Please download [kafka_2.9.2-0.8.2.1.tgz](http://mirror.metrocast.net/apache/kafka/0.8.2.1/kafka_2.9.2-0.8.2.1.tgz) and store it in `file_archives` directory.**


## Step 1. Update below variables as per requirement.

Variabled are in `default/mail.yml`

    kafka_version: kafka_2.9.2-0.8.2.1
    
    
    # Data Storage path on Destination kafka Nodes.
    kafka_data_store: /data/ansible/kafka
    kafka_topics: [ A, B, C, D ]
    
    # -----------------------
    # root Logger Options. 
    # -----------------------
    #    TRACE
    #    DEBUG
    #    INFO
    #    WARN
    #    ERROR
    #    FATAL
    #    ALL
    # -----------------------
    kafka_log4j_rootlogger: ERROR
    
## Step 2. User information com from global vars.

Username can be changed in the Global Vars, `kafka_user`.
Currently the password is `hdadmin@123`

Password can be generated using the below python snippet.

    # Password Generated using python command below.
    python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.encrypt(getpass.getpass())"

Here is the execution. After entering the password you will get the encrypted password which can be used in the user creation.

    ahmed@ahmed-server ~]$ python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.encrypt(getpass.getpass())"
    Enter Password: *******
    $6$rounds=40000$1qjG/hovLZOkcerH$CK4Or3w8rR3KabccowciZZUeD.nIwR/VINUa2uPsmGK/2xnmOt80TjDwbof9rNvnYY6icCkdAR2qrFquirBtT1
    ahmed@ahmed-server ~]$

## Step 3. Using this role. 

Create a File called `kafka.yml` with `hosts` file in root of the directory structure.
Below is the sample directory structure.


    zookeeper.yml
    hosts
    global_vars
      --> all
    file_archives
      --> kafka_2.9.2-0.8.2.1.tgz
      --> ...
    roles
      --> kafka_install_tarball
      --> ...
      
Below are the contents for `kafka.yml`

    #
    #-----------------------------
    # ZOOKEEPER CLUSTER SETUP
    #-----------------------------
    #
    
    - hosts: kafkanodes
      remote_user: root
      roles:
        - kafka_install_tarball

Steps used in `kafka_install_tarball` role.

    # Create user for `kafka`
    - include: user.yml
    
    # Install `kafka` - we are using tar.gz file to install `kafka`
    - include: install.yml
    
    # Configuration update server.properties, log4j, creating kafka starter script.
    - include: configure.yml
    
    # Starting Kafka server in port 9091, 9092.
    - include: start_server.yml
    
    # Creating Topics for the first Time.
    - include: create_topics.yml
        
Here are the contents of `hosts` file.
In `hosts` file `kafka_broker_id1` will be used to create an `id` for each broker.
`kafka_port1/2` will create 2 instance on each server running on ports 9091/9092. 

    #
    # kafka cluster
    #
    
    [kafkanodes]
    10.10.18.33 kafka_broker_id1=11 kafka_port1=9091 kafka_broker_id2=12 kafka_port2=9092
    10.10.18.97 kafka_broker_id1=13 kafka_port1=9091 kafka_broker_id2=14 kafka_port2=9092
    
        

## Step 4. Executing yml.

Execute below command. 

    ansible-playbook kafka.yml -i hosts --ask-pass
    
 