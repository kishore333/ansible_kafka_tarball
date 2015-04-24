#!/bin/sh
echo -e "Starting 9091 Server"
nohup sh /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server11.properties > server11.admin.log.file &
echo -e "Starting 9092 Server"
nohup sh /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server12.properties > server12.admin.log.file &
