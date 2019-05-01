#
# MQTTPublisher.py
# 
#
#  Created by Rafael Rosales on 4/2/19.
#

#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time
import paho.mqtt.client as mqtt
import sys
import Adafruit_DHT

temperatureWanted = True

def connectionStatus(client, userdata, flags, rc):
        mqttClient.subscribe("rpi/UNIT")
        
def on_message(client, userdata, msg):
        message = str(msg.payload)
        print (message)
        
        if message is "yes":
                temperatureWanted = True
        else:
                temperatureWanted = False
        

clientName = "RPI Publisher"
serverAddress = "192.168.0.22"

mqttClient = mqtt.Client(clientName)
mqttClient.on_connect = connectionStatus

mqttClient.connect(serverAddress)
sensor = Adafruit_DHT.DHT11



while True:
        
    mqttClient.on_message = on_message
    
    humidity, temperature = Adafruit_DHT.read_retry(sensor, 4)
    

    if humidity is not None and temperature is not None:
        if temperatureWanted: 
                print('Temp={0:0.1f}*'.format(temperature, humidity))
                mqttClient.publish("rpi/TEMP",'{0:0.1f}'.format(temperature))
        else:
                print("Humidity= %d"% (humidity))
                mqttClient.publish("rpi/HUM","%d"% (humidity))

    else:
        print('Failed to get reading. Try again!')
        sys.exit(1)
        
        
mqttClient.loop_forever()
