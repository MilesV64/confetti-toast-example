//
//  ViewController.swift
//  ConfettiToastExample
//
//  Created by Miles Vinson on 7/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    let triggerButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        triggerButton.setTitle("Show Toast", for: .normal)
        triggerButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        triggerButton.addTarget(self, action: #selector(didTapTriggerButton), for: .touchUpInside)
        view.addSubview(triggerButton)
        
    }

    @objc func didTapTriggerButton() {
        let notification = ConfettiToastView()
        
        view.addSubview(notification)
        notification.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notification.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            notification.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            notification.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            notification.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        notification.transform = CGAffineTransform(
            translationX: 0, y: view.safeAreaInsets.bottom + 100)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            notification.transform = .identity
        }, completion: nil)
        
        notification.animate()
                
        //dismiss notification after 4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                notification.transform = CGAffineTransform(
                    translationX: 0, y: self.view.safeAreaInsets.bottom + 100)
            }, completion: { complete in
                notification.removeFromSuperview()
            })
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        triggerButton.bounds.size = CGSize(width: 100, height: 44)
        triggerButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }

}

