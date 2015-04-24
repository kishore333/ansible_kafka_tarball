# Ansible Kafka Installation From `tarball`

This Installation is configuration of Kafka from `tar.gz` file.
Kafka needs zookeeper, you can run the standalone `zookeeper` but recommend to use the `ansible_zookeeper_tarball` repo.

Link to `ansible_zookeeper_tarball` : https://github.com/zubayr/ansible_zookeeper_tarball

Prerequisite : Assuming we have already install the zookeeper cluster. 

## Step 1: Download Kafka from Apache.

Download the file in `kafka` directory.

    wget http://download.nextag.com/apache/kafka/0.8.2.1/kafka_2.9.2-0.8.2.1.tgz


## Step 2: Update Path in `ansible_kafka.yml`.

Update path in the `ansible_kafka.yml` file so that it reflects the path required.
As shown below.

     # Remote Destination path on kafka Nodes.
     remote_dest_path: /root/ansible/kafka

     # Source Base path where the ansible script is running.
     src_base_path: /root/ansible_scripts/ansible_kafka_tarball

     # Data Storage path on Destination kafka Nodes.
     kafka_data_store: /data1/ansible/kafka

     # kafka Install Directory on Destination kafka Nodes.
     kafka_base: /opt/kafka

     # Zookeeper Variables.
     zookeeper_connect: ['10.10.18.91']

     # Zookeeper Cluster Information. IP:port
     zookeeper_cluster: '10.10.18.91:2181,10.10.18.92:2181,10.10.18.93:2181'

Also update the below line in the `ansible_kafka.yml` file.

    - name: Lets wait to see if we have Port 2181 is available.
    wait_for: host=10.10.18.91 port=2181 delay=5 timeout=15
    
Add one of the `zookeeper-ip` in `host`, we are checking for zookeeper before we start the server here.

## Step 3: Update Hosts in the Hosts file.

Updated IP address as per your requirement.
Make sure you use unique ids for `kafka_broker_id1=11 kafka_port1=9091 kafka_broker_id2=12 kafka_port2=9092`, as this will be used later in the script.

Note: Make sure the `kafka_broker_id` is unique in the cluster and is not repeated. 

## Step 3: (Optional) We use a user called `hdadmin` for Kafka.

Change this to any user you like as per requirement. Currently we are using `hdadmin`.
Note : Just find and replace `hdadmin` to any user you like. user will be created with password `hdadmin@123`

Password can be changed using the below python script.

    python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.encrypt(getpass.getpass())"


## Step 4: Now we are ready to Execute.

    # ansible-playbook ansible_kafka.yml --ask-pass
