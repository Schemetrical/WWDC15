//
//  PulsingButton.swift
//  WWDC15App
//
//  Created by Yichen Cao on 4/15/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//
//  Shared this file to some people (mitchellsweet) because apparently its really nice
//

import UIKit
import QuartzCore

let buttonLength:CGFloat = 30.0;
let duration:CFTimeInterval = 2.0
let buttonThickness:CGFloat = 2.5

class PulsingButton: UIButton {
    
    var pulseView:UIView = {
        var view = UIView(frame: CGRectMake(0, 0, buttonLength, buttonLength))
        view.layer.cornerRadius = view.bounds.size.width / 2
        view.layer.borderWidth = 1.2
        view.layer.borderColor = UIColor.grayColor().CGColor
        view.layer.opacity = 0.0
        view.userInteractionEnabled = false
        
        return view
    }()
    
    var canRemoveAnimations = false
    
    func startAnimations() {
        var scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0.05, 1.0]
        scaleAnimation.values = [1.2, 2.0]
        scaleAnimation.calculationMode = kCAAnimationCubic
        scaleAnimation.duration = duration
        scaleAnimation.repeatCount = HUGE // assuming HUGE is pretty huge
        self.pulseView.layer.addAnimation(scaleAnimation, forKey: "scale")
        
        var fadeAnimation = CAKeyframeAnimation(keyPath: "opacity")
        fadeAnimation.keyTimes = [0.0, 0.2, 0.5, 0.8]
        fadeAnimation.values = [0.0, 1.0, 0.3, 0.0]
        fadeAnimation.calculationMode = kCAAnimationCubic
        fadeAnimation.duration = duration
        fadeAnimation.repeatCount = HUGE
        self.pulseView.layer.addAnimation(fadeAnimation, forKey: "opacity")
        
        var anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 1.0
        anim.toValue = 1.0
        self.layer.addAnimation(anim, forKey: "opacity")
        
        NSRunLoop.mainRunLoop().addTimer(NSTimer(timeInterval: duration, target: self, selector: "animationFinished:", userInfo: nil, repeats: true), forMode: NSRunLoopCommonModes)
    }
    
    func removeAnimations() {
        canRemoveAnimations = true
    }
    
    func animationFinished(timer: NSTimer?) {
        if canRemoveAnimations {
            timer?.invalidate()
            self.pulseView.layer.removeAllAnimations()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.pulseView)
        self.backgroundColor = UIColor.whiteColor() 
        self.layer.cornerRadius = self.pulseView.bounds.size.width / 2
        self.layer.borderWidth = buttonThickness
        self.layer.borderColor = UIColor(white: 0.3, alpha: 1.0).CGColor
    }
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        super.addTarget(self, action: "makeSound", forControlEvents: controlEvents)
        super.addTarget(target, action: action, forControlEvents: controlEvents)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func makeSound() {
        SoundManager.sharedInstance.soundNotes(self.tag)
    }
}
