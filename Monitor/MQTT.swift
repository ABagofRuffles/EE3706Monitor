//
//  MQTT.swift
//  Monitor
//
//  Created by Rafael Rosales on 3/10/19.
//  Copyright © 2019 Rafael Rosales. All rights reserved.
//

import Foundation
import CocoaMQTT

protocol MQTTDelegate {
    func setMessage(message: String)
    func setStatus(_ status: CocoaMQTTConnState)
}

class MQTT: CocoaMQTTDelegate {
    
    var delegate: MQTTDelegate?
    
    let mqttClient = CocoaMQTT(clientID: "iOS Device " + ProcessInfo().processIdentifier.description, host: "98.242.96.24", port: 1883)
    var connectionStatus: CocoaMQTTConnState = .disconnected {
        didSet {
            delegate?.setStatus(connectionStatus)
        }
    }

    func connect() {
        mqttClient.delegate = self
        mqttClient.connect()
        connectionStatus = .connecting
        
        print("Connecting...")
    }
    
    func disconnect() {
        mqttClient.disconnect()
        connectionStatus = .disconnected
        print("Disconnected")
    }
    
    func publish(topic: String, message: String) {
        mqttClient.publish(topic, withString: message)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        connectionStatus = .connected
        print("Connected")
        mqttClient.subscribe("rpi/TEMP")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        if let messageDecoded = String(bytes: message.payload, encoding: .utf8) {
            print("Did receive a message: \(messageDecoded)")
            delegate?.setMessage(message: "\(messageDecoded)")
            
        } else {
            print("There was either:\nRecieving the message payload or\nwith converting the message payload into an integer")
            delegate?.setMessage(message: "ERROR")
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("Did subscribe to \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("Did unsubscribe to \(topic)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("Did ping \(mqtt.host)")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("\(mqtt.host) ponged us!")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {

    }
}
