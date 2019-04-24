//
//  MQTTPublisher.py
//  
//
//  Created by Rafael Rosales on 4/2/19.
//

#!/usr/bin/env python
# -*- coding: utf-8 -*-

import paho.mqtt.client as mqtt
import RPi.GPIO as gpio

def gpioSetup():
    
    gpio.setmode(gpio.BCM)
    gpio.setup(21, gpio.OUT)

def connectionStatus(client, userdata, flags, rc):
    mqttClient.subscribe("rpi/gpio")



gpioSetup()

clientName = "RPI"
serverAddress = "192.168.0.X"

mqttClient = mqtt.Client(clientName)

mqttClient.on_connect = connectionStatus

mqttClient.connect(serverAddress)
mqttClient.loop_forever()
