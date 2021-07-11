//
//  Animator.swift
//  ConfettiToastExample
//
//  Created by Miles Vinson on 7/11/21.
//

import UIKit

/**
 A class to manage animations driven by CADisplayLink.
 */
class Animator: NSObject {
    
    private var displayLink: CADisplayLink?
    private var animationCallback: ((CGFloat, CGFloat) -> Void)?
    
    private var easing: ((CGFloat) -> CGFloat)!
    private var fromValue: CGFloat!
    private var toValue: CGFloat!
    private var duration: Double!
    private var startTime: Double!
    
    /**
     Starts a CADisplayLink which calls the animation function with updated progress and interpolated value.
     - Parameter animation: Callback function with the current progress of the animation (0.0 - 1.0) and the interpolated value of fromValue and toValue.
     */
    public func interpolate(
        from fromValue: CGFloat,
        to toValue: CGFloat,
        duration: Double,
        animation: ((CGFloat, CGFloat) -> Void)?
    ) {
        
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.animationCallback = animation
        self.easing = Easing.exponentialEaseInOut
        self.startTime = CACurrentMediaTime()
        
        let displayLink = CADisplayLink(target: self, selector: #selector(animationDidUpdate))
        displayLink.add(to: .current, forMode: .common)
        self.displayLink = displayLink
        
    }
    
    private func endAnimation() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc func animationDidUpdate() {
        let elapsed = CACurrentMediaTime() - startTime
        
        if elapsed >= duration
        {
            animationCallback?(1, toValue)
            endAnimation()
        }
        else
        {
            let progress = CGFloat(easing(CGFloat(elapsed/duration)))
            let interpolatedValue = fromValue + (toValue - fromValue) * progress
            animationCallback?(progress, interpolatedValue)
        }
    }
    
    struct Easing {
        
        static func exponentialEaseInOut(_ x: CGFloat) -> CGFloat {
            if x == 0.0 || x == 1.0 {
                return x
            }

            if x < 0.5 {
                return 0.5 * pow(2, (20 * x - 10))
            } else {
                return -0.5 * pow(2, (-20 * x + 10)) + 1.0
            }
        }

    }
    
}
