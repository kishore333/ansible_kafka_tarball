#!/bin/sh
echo -e "Starting 9091 Server"
nohup sh {{ common['soft_link_base_path'] }}/kafka/bin/kafka-server-start.sh {{ common['soft_link_base_path'] }}/kafka/config/server11.properties > my1.admin.log.file &

sleep 5

echo -e "Starting 9092 Server"
nohup sh {{ common['soft_link_base_path'] }}/kafka/bin/kafka-server-start.sh {{ common['soft_link_base_path'] }}/kafka/config/server12.properties > my2.admin.log.file &
