# Zookeeper Role.

Below are the steps to get started.

## Before we start.

Please download [`zookeeper-3.4.5-cdh5.1.2.tar.gz`](http://archive.cloudera.com/cdh5/cdh/5/zookeeper-3.4.5-cdh5.1.2.tar.gz) and store it in `file_archives` directory.**

## Step 1. Update below variables as per requirement.

Variables are located in `roles/zookeeper_install_tarball/default/main.yml`.

    # Zookeeper Version.
    zookeeper_version: zookeeper-3.4.5-cdh5.1.2
    
    # Zookeeper Storage and Logging.
    zookeeper_data_store: /data/ansible/zookeeper
    zookeeper_logging: /data/ansible/zookeeper_logging

Global Vars can be found in the location `group_vars/all`.

    # --------------------------------------
    # USERs
    # --------------------------------------
    
    zookeeper_user: zkadmin
    zookeeper_group: zkadmin
    zookeeper_password: $6$rounds=40000$1qjG/hovLZOkcerH$CK4Or3w8rR3KabccowciZZUeD.nIwR/VINUa2uPsmGK/2xnmOt80TjDwbof9rNvnYY6icCkdAR2qrFquirBtT1


    # Common Location information.
    common:
      install_base_path: /usr/local
      soft_link_base_path: /opt


## Step 2. User information com from global vars.

Username can be changed in the Global Vars, `zookeeper_user`.
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

Create a File called `zookeeper.yml` with `hosts` file in root of the directory structure.
Below is the sample directory structure.


    zookeeper.yml
    hosts
    global_vars
      --> all
    file_archives
      --> zookeeper-3.4.5-cdh5.1.2.tar.gz
      --> ...
    roles
      --> zookeeper_install_tarball
      --> ...
      
Below are the contents for `zookeeper.yml`

    #
    #-----------------------------
    # ZOOKEEPER CLUSTER SETUP
    #-----------------------------
    #
    
    - hosts: zookeepernodes
      remote_user: root
      roles:
        - zookeeper_install_tarball

Steps used in `zookeeper_install_tarball` role.

1. Create a user to running zookeeper service. **NOTE:** `user` info from from `global_vars`.
2. Copy tgz file and extract in destination.
3. Changing permission to directory, setting `zookeeper_user` as the new owner.
4. Creating Symbolic link. **NOTE:** `soft_link` info from from `global_vars`.
5. Updating Configuration File in Zookeeper.
6. Creating a directory for Zookeeper.
7. Initializing `myid` File for Zookeeper.
8. Starting Zookeeper Service.

Here is the main.yml file.

    # main.yml file
    
    # Create a zookeeper_user.
    - include: user.yml
    
    # Install from tar.gz file.
    - include: install.yml
    
    # Configure zookeeper with zoo.cfg and setting up directories.
    - include: configure.yml
    
    # Initializing - creating myid file for each zookeeper to run in a Cluster.
    - include: init.yml
    
    # Start Zookeeper on all servers.
    - include: start.yml

        
Here are the contents of `hosts` file.
In `hosts` file `zookeeper_id` will be used to create an `id` in `myid` file, for each zookeeper running as a cluster.

    #
    # zookeeper cluster
    # 
    
    [zookeepernodes]
    10.10.18.25 zookeeper_id=1
    10.10.18.87 zookeeper_id=2
    10.10.18.90 zookeeper_id=3
    

## Step 4. Executing yml.

Execute below command. 

    ansible-playbook ansible_zookeeper.yml -i hosts --ask-pass
    
 