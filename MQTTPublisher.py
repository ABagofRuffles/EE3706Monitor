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

def on_message(client, userdata, message):
        print (message.payload)
        print (message.topic)
        
        global temperatureWanted
        
        if (message.payload == 'y'):
                print("The TEMPERATURE is wanted")
                temperatureWanted = True
        else:
                print("The HUMIDITY is wanted")
                temperatureWanted = False


clientName = "RPI Publisher"
serverAddress = "192.168.0.22"

print("creating new instance")
mqttClient = mqtt.Client(clientName)

mqttClient.on_message=on_message        


print("connecting to broker")
mqttClient.connect(serverAddress)

print("Subscribing to topic","monitor/UNIT")
mqttClient.subscribe("monitor/UNIT")

sensor = Adafruit_DHT.DHT11
    
while mqttClient.loop() == 0:  
        humidity, temperature = Adafruit_DHT.read_retry(sensor, 4)

        if humidity is not None and temperature is not None:
                if temperatureWanted: 
                        print('Temp={0:0.1f}*'.format(temperature))
                        mqttClient.publish("monitor/TEMP",'{0:0.1f}'.format(temperature))
                else:
                        print("Humidity= %d"% (humidity))
                        mqttClient.publish("monitor/HUM","%d" % (humidity))
                
        

mqttClient.loop_forever()
