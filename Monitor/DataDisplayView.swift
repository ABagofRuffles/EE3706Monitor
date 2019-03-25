//
//  DataDisplayView.swift
//  Monitor
//
//  Created by Rafael Rosales on 3/24/19.
//  Copyright © 2019 Rafael Rosales. All rights reserved.
//

import UIKit
import TinyConstraints

class DataDisplayView: UIView {

    private let stackView = UIStackView()
    let label = UILabel()
    let graphView = UIView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupSelf()
        setupStackView()
        setupLabel()
        setupGraphView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupSelf() { }
    
    private func setupStackView()  {
        addSubview(stackView)
        stackView.edgesToSuperview()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(graphView)
    }
    
    private func setupLabel() {
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 70, weight: .light)
    }
    
    private func setupGraphView() {
        graphView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        graphView.layer.cornerRadius = 15
    }
}
