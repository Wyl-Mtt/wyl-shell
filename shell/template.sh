#!/bin/bash
source ./config
function addcompose(){
cat <<EOF>> ./$servicesname.yml
version: "3"
services:
  $servicesname:
    user: \${uid}
    image: $images
    network_mode: host
    container_name: $servicesname
    privileged: true
    volumes:
      $volumes
    ulimits:
      core: 0
      nproc: 65535
      nofile:
        soft: 65535
        hard: 65535
    extra_hosts:
      - "$hostname:127.0.0.1"
      - "intersense:127.0.0.1"
      - "noderd.intersense.sensetime.com:127.0.0.1"
      - "gateway-external.default.svc.cluster.local:127.0.0.1"
      - "eureka-external.default.svc.cluster.local:127.0.0.1"
      - "eureka.default.svc.cluster.local:127.0.0.1"
      - "cassandra-0.cassandra.default.svc.cluster.local:127.0.0.1"
      - "mysql-master.default.svc.cluster.local:127.0.0.1"
      - "zookeeper-0.zookeeper.default.svc.cluster.local:127.0.0.1"
      - "zookeeper-external.default.svc.cluster.local:127.0.0.1"
      - "kafka.default.svc.cluster.local:127.0.0.1"
      - "cassandra-external.default.svc.cluster.local:127.0.0.1"
      - "jobmanager:127.0.0.1"
      - "flink-jobmanager:127.0.0.1"
      - "taskmanager:127.0.0.1"
      - "sensebi.default.svc.cluster.local:127.0.0.1"
    deploy:
      restart_policy:
        condition: on-failure
    command: $commands
EOF
}
if [ -d $path"/"$servicesname ];then
        rm -rf  $path"/"$servicesname"/"$servicesname.yml
        cd $path"/"$servicesname
        addcompose
        addini
    else
        mkdir -p $path"/"$servicesname
        cd $path"/"$servicesname
        addcompose
        addini
fi