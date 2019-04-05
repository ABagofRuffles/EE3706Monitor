//
//  GraphDetailCardView.swift
//  Monitor
//
//  Created by Rafael Rosales on 4/4/19.
//  Copyright © 2019 Rafael Rosales. All rights reserved.
//

// NOT REALLY WORKING RIGHT NOW

import UIKit

class GraphDetailCardView: UIView {
  
  // MARK: - Properties
  private let circleSize: CGFloat = 12
  
  // MARK: - Subviews
  let textLabel = UILabel()
  let circleView = UIView()
  
  // MARK: - Initialization
  convenience init() {
    self.init(frame: .zero)
    configureSubviews()
    addSubview(textLabel)
    addSubview(circleView)
  }
  
  /// Set view/subviews appearances
  fileprivate func configureSubviews() {
    backgroundColor = .white
    layer.cornerRadius = 3
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowRadius = 3
    layer.shadowOpacity = 0.25
    layer.shadowOffset = CGSize(width: -1, height: 1)

    textLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
    textLabel.textColor = .white
    textLabel.text = "TEST"

    circleView.layer.cornerRadius = circleSize / 2
    circleView.backgroundColor = .black

  }
}

