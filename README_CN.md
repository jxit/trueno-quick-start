# Trueno 快速体验



## 一、什么是Trueno

**Trueno**（西班牙语，英文意思是“thunder”）是一个自洽的智能服务SaaS平台，它主旨是构建一个轻量的、平台和AI模型兼容性强、使用方便的的pipeline，让设备可以快速部署AI和进行AI模型推理。

Trueno提供一个抽象的AI backend，可以关联不同的AI backend模型进行推理，例如tensorflow、华为atlas、rockchip rknn、pytorch等。

Trueno提供同步和异步两种数据处理方式：

- 可以通过RESTful、gRPC方式将图像数据传入队列，进行AI推理后再同步输出AI结果。
- 也可以通过MQTT方式订阅图像数据，接收数据进行AI推理后，再发布包含AI结果的MQTT topic。



## 二、环境要求

- 一台X86的电脑，预装ubuntu 18.04 LTS或以上版本的系统。
- 预装docker与docker-compose环境。
- 预装EMQ-X Broker。
- 能正常连接因特网。
- 2G以上空闲内存空间，10G以上空闲磁盘空间。



## 三、安装依赖

本示例需要预装docker、docker-compose和EMQ-X Broker环境，如果还没安装，可以执行以下命令：

```shell
$ sudo bash install_dependency.sh
```



## 四、安装和运行Trueno

### 1.安装Trueno

本示例的关键组件说明：

- Trueno-tensorflow-cpu镜像：预装trueno、opencv、numpy和tensorflow等环境的ubuntu 18.04镜像。
- device-trueno-mqtt 镜像：基于edgex 2.0开发的设备微服务，提供接口向trueno发送mqtt图像数据及订阅返回的AI结果。
- model-zoo/226a7354795692913f24bee21b0cd387-1.tar.gz：可在Trueno-tensorflow-cpu容器上运行的tensorflow AI示例模型。
  - 该sample模型仅用于验证trueno的流程，AI模型的数据不具备实际意义。
  - 后续可以考虑用第三方标准的AI模型进行演示。

执行命令，会进行如下操作

- 从docekr harbor上拉取Trueno-tensorflow-cpu镜像和device-trueno-mqtt设备微服务镜像。
- 拉取Edgex-Foundry 2.0相关镜像
- 解压tensorflow AI模型

```shell
$ sudo bash install.sh
```

### 2.运行Trueno

```shell
$ sudo bash run.sh
```

### 3.在Trueno上测试推理

#### 1）通过edgex restful进行异步通信

通过restful api向device-trueno-mqtt 设备微服务发送get命令，设备微服务会读取本地/tmp/image.jpg图像文件，向trueno发送图像数据并订阅AI结果，最后将trueno响应的AI结果返回到core data。

发送命令

```shell
$ curl http://localhost:59882/api/v2/device/name/Trueno-Mqtt-Go-Device/Mqtt_Publish
```

响应结果：

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

#### 2）通过http同步通信

执行python测试程序，通过http post命令将image.jpg图片发送到trueno，并获取推理后返回的AI结果。

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