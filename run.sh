#!/bin/bash

# pull trueno_image
sudo docker-compose up -d

# pull edgex-foundry 2.0 and device_trueno_mqtt_image
sudo docker-compose -f  edgex-2_0/docker-compose.yml  up -d