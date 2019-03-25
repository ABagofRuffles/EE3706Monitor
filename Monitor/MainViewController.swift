//
//  MainViewController.swift
//  Monitor
//
//  Created by Rafael Rosales on 3/10/19.
//  Copyright © 2019 Rafael Rosales. All rights reserved.
//

import UIKit
import CocoaMQTT
import TinyConstraints
import GradientView

class MainViewController: UIViewController {
    // MARK: Variables
    // Instatiate a client
    let mqtt = MQTT()
    
    // Instatiate Display elements
    let gradientView = GradientView()
    let dataDisplayView = DataDisplayView()
    let connectionButton = UIButton()

    // Everything in here runs on startup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mqtt.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.NSExtensionHostWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.NSExtensionHostWillEnterForeground, object: nil)
        
        // Setup the Window with Subviews
        setupSubviews()
        addSubviews()
        setupConstraints()
    }

    // MARK: - Setup
    private func setupSubviews() {
        // Background gradient properties
        let topColor = UIColor(red: 69 / 255.0, green: 0 / 255.0, blue: 255 / 255.0, alpha: 1)
        let bottomColor = UIColor(red: 150 / 255.0, green: 147 / 255.0, blue: 198 / 255.0, alpha: 1)
        gradientView.colors = [topColor, bottomColor]
        
        // Data Initial Value to be displayed on top of the background
        dataDisplayView.label.text = "0°C"
        
        // Adds the connection button on top of the background
        connectionButton.addTarget(self, action: #selector(connectButtonAction), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(gradientView)
        view.addSubview(dataDisplayView)
        view.addSubview(connectionButton)
    }
    
    private func setupConstraints() {
        // Background constraints
        gradientView.edgesToSuperview()
        
        // Data constraints
        dataDisplayView.left(to: self.view, offset: 40)
        dataDisplayView.right(to: self.view, offset: -40)
        dataDisplayView.centerInSuperview()
        dataDisplayView.height(300)
        
        // Button properties and constraints
        connectionButton.setTitle("Connect", for: .normal)
        connectionButton.setTitleColor(.white, for: .normal)
        connectionButton.setTitleColor(.lightGray, for: .highlighted)
        connectionButton.centerXToSuperview()
        connectionButton.bottomToSuperview(usingSafeArea: true)
    }
    
    // MARK: - Functions
    @objc func appMovedToBackground() {
        print("App moved to background. Disconnecting.")
        mqtt.disconnect()
    }
    
    @objc func appMovedToForeground() {
        print("App moved to foreground. Connecting...")
        mqtt.connect()
    }
    
    // Excecutes when Connect Button gets pressed
    @objc func connectButtonAction() {
        switch mqtt.connectionStatus {
        case .connected:
            mqtt.disconnect()
        case .disconnected:
            mqtt.connect()
        default:
            break
        }
    }
}

extension MainViewController: MQTTDelegate {
    // Sets the displayed real-time data
    func setMessage(message: String) {
        dataDisplayView.label.text = message
    }
    
    // Sets the button text to the relevant state
    func setStatus(_ status: MQTT.ConnectionStatus) {
        switch status {
        case .connecting:
            connectionButton.setTitle("Connecting...", for: .normal)
        case .connected:
            connectionButton.setTitle("Disconnect", for: .normal)
        case .disconnected:
            connectionButton.setTitle("Connect", for: .normal)
            dataDisplayView.label.text = "0°C"
        }
    }
}
