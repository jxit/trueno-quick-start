#!/bin/bash

# Create trueno file storage path
sudo mkdir -p /jxserving/storage

# Copy the sample AI ​​model to the trueno file storage path
sudo cp -rf model-zoo/*  /jxserving/storage/
# Unzip the AI ​​model
sudo bash extract_ai_model.sh 226a7354795692913f24bee21b0cd387-1.tar.gz

# Copy test image to /tmp path
cp image.jpg /tmp/image.jpg

# pull  trueno_image
sudo docker-compose pull

# pull edgex-foundry 2.0 and device_trueno_mqtt_image
sudo docker-compose -f edgex-2_0/docker-compose.yml pull
