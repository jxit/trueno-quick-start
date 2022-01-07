# Trueno quick experience



## What is Trueno

**Trueno** (Spanish, English meaning "thunder") is a self-consistent intelligent service SaaS platform. It's main purpose is to build a pipeline which is lightweight, highly compatible for ai platform and easy-to-use. User can quickly deploy AI models and infer on AI platform with Trueno .

Trueno provides an abstract AI backend that can be associated with different AI backend models for inference , such as tensorflow, Huawei atlas, rockchip rknn, pytorch, etc.

Trueno provides two data processing methods: synchronous and asynchronous:

- synchronous: The image data is transferred to the queue through RESTful and RPC methods, and after AI inference, the AI results are output synchronously.
- asynchronous: Applications publish image data to Trueno through MQTT, and after receiving the data for AI inference,  Trueno publishes an MQTT topic containing AI results to MQTT broker.



## Platform requirements

- An X86 computer, pre-installed with ubuntu 18.04 LTS or above.
- Pre-installed docker and docker-compose environment.
- Pre-installed EMQ-X Broker.
- Able to connect to the Internet normally.
- Free memory space above 2G, free disk space above 10G.



## Installation requirements

This Trueno sample requires pre-installed docker, docker-compose and EMQ-X Broker environments. If not installed, you can execute the following commands:

```shell
$ sudo bash install_dependency.sh
```



## Install and run Trueno

### 1.Install Trueno

Description of the key components of this sample:

- Trueno-tensorflow-cpu image: ubuntu 18.04 image pre-installed with environments such as trueno, opencv, numpy and tensorflow.
- device-trueno-mqtt image: A device microservice developed based on edgex 2.0 provides an interface to send mqtt image data to trueno and the AI results returned by subscription.
- model-zoo/226a7354795692913f24bee21b0cd387-1.tar.gz: A sample model of tensorflow AI that can be run on the Trueno-tensorflow-cpu container.
  - The sample model is only used to verify the trueno process, and the data of the AI model does not have practical meaning.
  - Later, we can consider using a third-party standard AI model for demonstration.

Execute the following command to install Trueno

```shell
$ sudo bash install.sh
```

The installation process is as follows:

- Pull the Trueno-tensorflow-cpu image and the device-trueno-mqtt device microservice image from docker harbor.
- Pull Edgex-Foundry 2.0 related mirrors
- Unzip sample tensorflow AI model 



### 2.Run Trueno

```shell
$ sudo bash run.sh
```



### 3.Infer on Trueno

#### 1）Asynchronous communication via edgex restful api

Send the GET command to the device-trueno-mqtt device microservice through the restful api. The device microservice will read the local /tmp/image.jpg image file, send the image data to trueno and subscribe to the AI result, then finally return the AI result of the trueno response To core data.

Execute command:

```shell
$ curl http://localhost:59882/api/v2/device/name/Trueno-Mqtt-Go-Device/Mqtt_Publish
```

Response：

```json
{
    "apiVersion": "v2",
    "statusCode": 200,
    "event": {
        "apiVersion": "v2",
        "id": "70100c31-4ad0-4165-948f-21f68fe7b82e",
        "deviceName": "Trueno-Mqtt-Go-Device",
        "profileName": "Trueno-Mqtt-Go-Device",
        "sourceName": "Mqtt_Publish",
        "origin": 1638763828860231593,
        "readings": [
            {
                "id": "6578041d-0cb9-4da5-a9fd-91511506cc74",
                "origin": 1638763828860231593,
                "deviceName": "Trueno-Mqtt-Go-Device",
                "resourceName": "Mqtt_Publish",
                "profileName": "Trueno-Mqtt-Go-Device",
                "valueType": "String",
                "binaryValue": null,
                "mediaType": "",
                "value": "{\"image_id\":9, \"airesult\":[[\"jsxs\", \"0.5343847870826721\", \"0\", \"12\", \"167\", \"79\"]]}"
            }
        ]
    }
}
```

#### 2）Synchronous communication via http

Execute the python test program, it will send the image.jpg as frame buffer to trueno through the http post command, then get the AI result returned after trueno ai inference.

```shell
$ cd test/
$ python3 apis_restful.py
>>>> 1
raw: {'B6d380fab8d7c3b77d49ba2431c5adf27': '[["jsxs", "0.5343847870826721", "0", "12", "167", "79"]]'}
>>>> 2
raw: {'B6d380fab8d7c3b77d49ba2431c5adf27': '[["jsxs", "0.5343847870826721", "0", "12", "167", "79"]]'}
>>>> 3
raw: {'B6d380fab8d7c3b77d49ba2431c5adf27': '[["jsxs", "0.5343847870826721", "0", "12", "167", "79"]]'}
>>>> 4
raw: {'B6d380fab8d7c3b77d49ba2431c5adf27': '[["jsxs", "0.5343847870826721", "0", "12", "167", "79"]]'}
>>>> 5
raw: {'B6d380fab8d7c3b77d49ba2431c5adf27': '[["jsxs", "0.5343847870826721", "0", "12", "167", "79"]]'}
```

#### 