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
import ILG

class MainViewController: UIViewController, UIScrollViewDelegate {

    // Instatiate a client
    let mqtt = MQTT()
    
    // Instatiate Display elements
    let gradientView = GradientView()
    var topColor = UIColor(red: 69 / 255.0, green: 0 / 255.0, blue: 255 / 255.0, alpha: 1)
    var bottomColor = UIColor(red: 150 / 255.0, green: 147 / 255.0, blue: 198 / 255.0, alpha: 1)
    
    let dataDisplayView = DataDisplayView()
    var currentUnit = Unit.celsius
    var currentValue = Float(0.0)
    var pastValueFromPreviousUnit = Float(0.0)
    var points = [Double]()
    
    let connectionButton = UIButton()
    
    let items = ["Temperature" , "Humidity"]
    var segmentedControl = UISegmentedControl()


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mqtt.delegate = self
        
        dataDisplayView.graphView.interactionDelegate = self

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
        gradientView.colors = [topColor, bottomColor]
        
        // Segmented control
        segmentedControl = UISegmentedControl(items : items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(MainViewController.indexChanged(_:)), for: .valueChanged)
        
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.backgroundColor = .magenta
        segmentedControl.tintColor = .white
        
        // Data Initial Value to be displayed on top of the background
        dataDisplayView.label.text = "\(currentValue)" + currentUnit.description
        dataDisplayView.graphView.update(withDataPoints: generateRandomList(), animated: true)

        
        // Add Tap Gestures
        dataDisplayView.label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MainViewController.tap)))
        handleTap()
        
        dataDisplayView.graphView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        // Adds the connection button on top of the background
        connectionButton.addTarget(self, action: #selector(connectButtonAction), for: .touchUpInside)
    }
    
    private func addSubviews() {
        self.view.addSubview(gradientView)
        self.view.addSubview(dataDisplayView)
        self.view.addSubview(connectionButton)
        self.view.addSubview(segmentedControl)

    }
    
    private func setupConstraints() {
        // Background constraints
        gradientView.edgesToSuperview()
        
        // Button properties and constraints
        connectionButton.setTitle("Connect", for: .normal)
        connectionButton.setTitleColor(.white, for: .normal)
        connectionButton.setTitleColor(.lightGray, for: .highlighted)
        connectionButton.centerXToSuperview()
        connectionButton.bottomToSuperview(usingSafeArea: true)
        connectionButton.height(150)
        
        // Data constraints
        dataDisplayView.left(to: self.view, offset: 40)
        dataDisplayView.right(to: self.view, offset: -40)
        dataDisplayView.bottomToTop(of: connectionButton, offset: 25)
        dataDisplayView.centerInSuperview()
        dataDisplayView.height(350)
        
        // Segmented Control Constraints
        segmentedControl.topToSuperview(offset: 25, usingSafeArea: true)
        segmentedControl.centerXToSuperview()


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
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            print("Changed to Temperature");
            
            mqtt.publish(topic: "monitor/UNIT", message: "y")

            
            // Change background gradient color
            topColor = UIColor(red: 69 / 255.0, green: 0 / 255.0, blue: 255 / 255.0, alpha: 1)
            currentUnit = .celsius
        case 1:
            print("Changed to Humidity")
            
            mqtt.publish(topic: "monitor/UNIT", message: "nah")
            
            // Change background gradient color
            topColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 255 / 255.0, alpha: 1)
            currentUnit = .humidity
        default:
            break
        }
        gradientView.colors = [topColor, bottomColor]
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
        case .humidity:
            break
        }
        
        dataDisplayView.label.text = "\(currentValue)" + currentUnit.description
    }
    
    @objc func handleTap() {
        points = generateRandomList()
        dataDisplayView.graphView.update(withDataPoints: points, animated: true)
    }
    
    fileprivate func generateRandomList() -> [Double] {
        var list = [Double]()
        for _ in 0 ..< Int.random(in: 12...20) {
            list.append(Double.random(in: 0...100))
        }
        return list
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
        case humidity
        
        public var description: String {
            switch self {
            case .celsius: return "°C"
            case .kelvin: return "K"
            case .fahrenheit: return "°F"
            case .humidity: return "%"
            }
        }
    }
}

extension MainViewController: MQTTDelegate, GraphViewInteractionDelegate {
    // Sets the displayed real-time data
    func setMessage(message: String) {
        if Double(message) != nil {
            switch currentUnit {
            case .celsius, .humidity:
                currentValue = Float(message)!
            case .kelvin:
                currentValue = Float(message)! + 273.15
            case .fahrenheit:
                currentValue = (Float(message)! * 1.8) + 32
            }
            points.append(Double(message)!)
            dataDisplayView.graphView.update(withDataPoints: points, animated: true)
            dataDisplayView.label.text = "\(currentValue)" + currentUnit.description
            points.removeFirst()
        }
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
    
    func graphViewInteraction(userInputDidChange currentIndex: Int, graphView: InteractiveLineGraphView, detailCardView: UIView?) {
        dataDisplayView.graphDetailCard.textLabel.text = "Index #\(currentIndex)"
    }
    
    func graphViewInteraction(userInputDidBeginOn graphView: InteractiveLineGraphView, detailCardView: UIView?) {
        print("Began interaction")
    }
    
    func graphViewInteraction(userInputDidEndOn graphView: InteractiveLineGraphView, detailCardView: UIView?) {
        print("Ended interaction")
    }
}
