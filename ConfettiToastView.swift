//
//  ConfettiToastView.swift
//  ConfettiToastExample
//
//  Created by Miles Vinson on 7/11/21.
//

import UIKit

class ConfettiToastView: UIView {
    
    private let confettiCircle = ConfettiCircle()
    private let label = UILabel()
        
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.systemBlue
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous
        self.layer.shadowColor = UIColor.systemBlue.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 14
        addSubview(confettiCircle)
        
        confettiCircle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confettiCircle.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            confettiCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            confettiCircle.heightAnchor.constraint(equalToConstant: 38),
            confettiCircle.widthAnchor.constraint(equalToConstant: 38)
        ])
        
        label.text = "Success!"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.white
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: confettiCircle.rightAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
    public func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.confettiCircle.animate()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
