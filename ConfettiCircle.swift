//
//  ConfettiCircle.swift
//  ConfettiToastExample
//
//  Created by Miles Vinson on 7/11/21.
//

import UIKit

class ConfettiCircle: UIView {
    
    private let feedback = UIImpactFeedbackGenerator(style: .medium)
    
    /** Container for arc paths */
    private let arcView = UIView()
    
    /** Arc that animates */
    private let fgArc = CAShapeLayer()
    
    /** Background arc */
    private let bgArc = CAShapeLayer()
    
    private let animator = Animator()
    
    /** Progress of the animating arc */
    private var progress: CGFloat = 0.01
    
    private var didConfetti = false
    
    init() {
        super.init(frame: .zero)
        
        arcView.backgroundColor = .clear
        self.addSubview(arcView)
        
        bgArc.strokeColor = UIColor.white.withAlphaComponent(0.12).cgColor
        bgArc.lineWidth = 4.5
        bgArc.lineCap = .round
        bgArc.fillColor = UIColor.clear.cgColor
        arcView.layer.addSublayer(bgArc)
        
        fgArc.strokeColor = UIColor.white.cgColor
        fgArc.lineWidth = 4.5
        fgArc.lineCap = .round
        fgArc.fillColor = UIColor.clear.cgColor
        arcView.layer.addSublayer(fgArc)
        
    }
    
    public func animate() {
        feedback.prepare()
        progress = 1
        
        animator.interpolate(
            from: 0.01,
            to: 1,
            duration: 1.8,
            animation: updateAnimation)
    }
    
    /**
     Updates the path of the fgArc to the interpolated value from the Animator. After a certain progress, triggers the confetti animation.
     */
    private func updateAnimation(progress: CGFloat, value: CGFloat) {
        let path = UIBezierPath()
        path.addArc(
            withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: self.bounds.width/2 - 2,
            startAngle: -CGFloat.pi/2, endAngle: -CGFloat.pi/2 + (progress * CGFloat.pi*2),
            clockwise: true)
        
        fgArc.path = path.cgPath
        
        if !didConfetti && progress > 0.96 {
            didConfetti = true
            
            confetti()
        }
    }
    
    private func confetti() {
        feedback.impactOccurred()
        
        //bounce the arc view
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            self.arcView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }) { (complete) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.arcView.transform = .identity
            }, completion: nil)
        }
        
        animateConfetti()
    }
    
    private func animateConfetti() {
        
        //colors of the 'confetti'
        let colors: [UIColor] = [
            UIColor.systemOrange,
            UIColor.systemTeal,
            UIColor.systemRed,
            UIColor.systemGreen,
            UIColor.systemPink,
            UIColor.white,
            UIColor.white,
            UIColor.white
        ]
        
        func makeView() -> UIView {
            let view = UIView()
            view.backgroundColor = colors[Int.random(in: 0..<colors.count)]
            view.bounds.size = CGSize(width: 3, height: 3)
            view.center = CGPoint(x: bounds.midX, y: bounds.midY)
            view.layer.cornerRadius = 1.5
            self.addSubview(view)
            return view
        }
        
        //converts angle and radius to CGAffineTransform
        func getTransform(angle: CGFloat, radius: CGFloat) -> CGAffineTransform {
            return CGAffineTransform(translationX: cos(angle)*radius, y: sin(angle)*radius)
        }
        
        //draw 2 confetti views at 7 angles
        
        let startAngle = -CGFloat.pi/2
        let angleStep = (2*CGFloat.pi)/7
        
        //offset for the 2 side by side confetti views from each other
        let angleOffset = CGFloat.pi/6
        
        for i in 0...6 {
            
            let leftView = makeView()
            let rightView = makeView()
            
            let angle = startAngle + angleStep*CGFloat(i)
            
            leftView.transform = getTransform(angle: angle - angleOffset, radius: self.bounds.width/2)
            rightView.transform = getTransform(angle: angle + angleOffset, radius: self.bounds.width/2)
            
            //animate right and left views moving away and fading (with different timing and distance)
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                rightView.transform = getTransform(angle: angle + angleOffset, radius: self.bounds.width*0.6)
            }) { (complete) in
                UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                    rightView.transform = getTransform(angle: angle + angleOffset, radius: self.bounds.width*6.2).concatenating(CGAffineTransform(scaleX: 0.1, y: 0.1))
                    rightView.alpha = 0
                }, completion: nil)
            }
            
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveLinear, animations: {
                leftView.transform = getTransform(angle: angle - angleOffset, radius: self.bounds.width*0.75)
            }) { (complete) in
                UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                    leftView.transform = getTransform(angle: angle - angleOffset, radius: self.bounds.width*7.7).concatenating(CGAffineTransform(scaleX: 0.1, y: 0.1))
                    leftView.alpha = 0
                }, completion: nil)
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        arcView.bounds.size = self.bounds.size
        arcView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        bgArc.frame = self.bounds
        fgArc.frame = self.bounds
        
        bgArc.path = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: self.bounds.width/2 - 2,
            startAngle: -CGFloat.pi/2, endAngle: -CGFloat.pi/2 + CGFloat.pi*2,
            clockwise: true).cgPath
        
        fgArc.path = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: self.bounds.width/2 - 2,
            startAngle: -CGFloat.pi/2, endAngle: -CGFloat.pi/2 + (self.progress * CGFloat.pi*2),
            clockwise: true).cgPath
        
    }
}
