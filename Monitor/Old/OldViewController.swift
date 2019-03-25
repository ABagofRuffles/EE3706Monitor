////
////  ViewController.swift
////  Monitor
////
////  Created by Rafael Rosales on 3/10/19.
////  Copyright © 2019 Rafael Rosales. All rights reserved.
////
//
//import UIKit
//import CocoaMQTT
//
//class ViewController: UIViewController, didReceiveMessageDelegate {
//    
//    let mqtt = MQTT()
//    
//    @IBOutlet weak var temperatureLabel: UITextField!
//    
//    func setMessage(message: String) {
//        temperatureLabel.text = message
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        mqtt.delegate = self
//        
//        let notificationCenter = NotificationCenter.default
//        
//        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.NSExtensionHostWillResignActive, object: nil)
//        
//        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.NSExtensionHostWillEnterForeground, object: nil)
//    }
//    
//    @objc func appMovedToBackground() {
//        print("App moved to background. Disconnecting.")
//        mqtt.disconnect()
//    }
//    
//    @objc func appMovedToForeground() {
//        print("App moved to foreground. Connecting...")
//        mqtt.connect()
//    }
//    
////    Excutes when switch changes states (ON or OFF)
//    @IBAction func gpio40Switch(_ sender: UISwitch) {
//        //        if swith is ON, then publish to topic "rpi/gpio" with message "on"
//        //        if swith is OFF, then publish to topic "rpi/gpio" with message "off"
//        if sender.isOn {
//            mqtt.publish(topic: "rpi/gpio", message: "on")
//        } else {
//            mqtt.publish(topic: "rpi/gpio", message: "off")
//        }
//    }
//    
////    Excecutes when Connect Button gets pressed
//    @IBAction func connectButton(_ sender: UIButton) {
//        mqtt.connect()
//    }
//    
////    Excecutes when Disconnect Button gets pressed
//    @IBAction func disconnectButton(_ sender: UIButton) {
//        mqtt.disconnect()
//    }
//    
//}
//
