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

    // Instatiate a client
    let mqtt = MQTT()
    
    // Instatiate Display elements
    let gradientView = GradientView()
    
    let dataDisplayView = DataDisplayView()
    var currentUnit = Unit.celsius
    var currentValue = 0.0
    
    
    
    let connectionButton = UIButton()

    // MARK: - Lifecycle
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
        dataDisplayView.label.text = "\(currentValue)" + currentUnit.description
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tap))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        dataDisplayView.label.addGestureRecognizer(singleTap)
        dataDisplayView.label.isUserInteractionEnabled = true
        
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
        connectionButton.height(150)
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
    
    @objc func tap(recognizer: UITapGestureRecognizer) {
        print("Data label has been tapped.")

        switch currentUnit {
        case .celsius:
            currentValue += 273.15
            currentUnit = .kelvin
        case .kelvin:
            currentValue = (currentValue * 1.8) - 459.67
            currentUnit = .fahrenheit
        case .fahrenheit:
            currentValue = (currentValue - 32)/1.8
            currentUnit = .celsius
        }
        
        dataDisplayView.label.text = "\(currentValue)" + currentUnit.description
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
    
    // MARK: - Nested types
    public enum Unit{
        case celsius
        case kelvin
        case fahrenheit
        
        public var description: String {
            switch self {
            case .celsius: return "°C"
            case .kelvin: return "K"
            case .fahrenheit: return "°F"
            }
        }
    }
}

extension MainViewController: MQTTDelegate {
    // Sets the displayed real-time data
    func setMessage(message: String) {
        switch currentUnit {
        case .celsius:
            currentValue = Double(message)!
        case .kelvin:
            currentValue = Double(message)! + 273.15
        case .fahrenheit:
            currentValue = (Double(message)! * 1.8) + 32
        }
        dataDisplayView.label.text = "\(currentValue)" + currentUnit.description

    }
    
    // Sets the button text to the relevant state
    func setStatus(_ status: CocoaMQTTConnState) {
        switch status {
        case .initial, .connected:
            connectionButton.setTitle("Disconnect", for: .normal)
        case .connecting:
            connectionButton.setTitle("Connecting...", for: .normal)
        case .disconnected:
            connectionButton.setTitle("Connect", for: .normal)
            dataDisplayView.label.text = "\(currentValue)" + currentUnit.description
        }
    }
}
