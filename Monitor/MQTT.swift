import Foundation
import CocoaMQTT

protocol MQTTDelegate {
    func setMessage(message: String)
    func setStatus(_ status: MQTT.ConnectionStatus)
}

class MQTT: CocoaMQTTDelegate {
    
    var delegate: MQTTDelegate?
    let mqttClient = CocoaMQTT(clientID: "iOS Device", host: "192.168.0.22", port: 1883)
    var connectionStatus: ConnectionStatus = .disconnected {
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
        mqttClient.subscribe("rpi/DHT")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        let messageDecoded = String(bytes: message.payload, encoding: .utf8)
        print("Did receive a message: \(messageDecoded!)")
        delegate?.setMessage(message: "\(messageDecoded!) ºC")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("Did subscribe to \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        
    }
    
    // MARK: - Nested types
    enum ConnectionStatus {
        case connecting
        case connected
        case disconnected
    }
}
