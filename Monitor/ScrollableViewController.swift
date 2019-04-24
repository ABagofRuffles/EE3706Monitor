//
//  ScrollableView.swift
//  Monitor
//
//  Created by Rafael Rosales on 4/20/19.
//  Copyright © 2019 Rafael Rosales. All rights reserved.
//

import UIKit
import ScrollingStackViewController

class ScrollableViewController: ScrollingStackViewController {
    
    var viewController1: UIViewController!
    var viewController2: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        viewController1 = MainViewController.instantiateViewController(withIdentifier: "ChildController1") as! Child
        viewController2 = storyboard.instantiateViewController(withIdentifier: "ChildController2") as! ChildController2
        
        add(viewController: viewController1)
        add(viewController: viewController2)
    }
}
