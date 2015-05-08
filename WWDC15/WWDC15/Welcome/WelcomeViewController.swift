//
//  WelcomeViewController.swift
//  WWDC15App
//
//  Created by Yichen Cao on 4/14/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

import UIKit

func cgfUnitClamp(f:CGFloat) -> CGFloat { return max(0.0, min(1.0, f)) }

@objc public class WelcomeViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    let colors = [
        UIColor(white: 0.3, alpha: 1.0),                            // Gray for Indecisiveness
        UIColor(red: 0.746, green: 0.617, blue: 0.000, alpha: 1.0), // Yellow for Curiosity
        UIColor(red: 0.065, green: 0.518, blue: 0.000, alpha: 1.0), // Green for Growth
        UIColor(red: 0.783, green: 0.011, blue: 0.000, alpha: 1.0), // Red for Passion
        UIColor(red: 0.333, green: 0.000, blue: 0.518, alpha: 1.0), // Purple for Imagination
        UIColor.whiteColor()]                                       // Black for Mystery <- you'll see why its white in a moment
    
    let colorDescriptions = [
        "Indecisiveness",
        "Curiosity",
        "Growth",
        "Passion",
        "Imagination",
        "Mystery"]
    
    let keyDates = [
        "SEP 1999", // date de naissance
        "APR 2009",
        "JUL 2011",
        "DEC 2013",
        "JUN 2014",
        "APR 2015"]
    
    let hoursOfCode = [0, 0, 2, 50, 300, 1200] // calculated based off an average of 3 hours per day for the past year and half
    // Programming gets to be part of your lifesyle. A way have fun intellectually.
    
    var mainScrollView:UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.pagingEnabled = true
        #if !DEBUG
            scrollView.scrollEnabled = false // for debugging
        #endif
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    var lineView:UIView = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: buttonThickness))
        view.backgroundColor = UIColor(white: 0.3, alpha: 1.0) // Initial color
        view.layer.cornerRadius = buttonThickness / 2 // Sometimes precision is worth it
        return view
    }()
    
    var hoursOfCodeLabel:UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "GillSans-Light", size: 20)
        label.textColor = UIColor.whiteColor()
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    let titleLabels:[UILabel] = {
        let titles = ["Yichen Cao", "iPod touch", "\"Hello World\";", "@", "WWDC14", "WWDC15"]
        var labels = [UILabel]()
        for screen in 0..<titles.count {
            var label = UILabel()
            label.text = titles[screen]
            label.font = UIFont(name: "HelveticaNeue-Thin", size: 45)
            label.textAlignment = .Center
            label.sizeToFit()
            labels.append(label)
        }
        return labels
    }()
    
    let animationMethods = [animateIndecisivenessScreen, animateCuriosityScreen, animateGrowthScreen, animatePassionScreen, animateImaginationScreen, animateMysteryScreen]
    
    // MARK: Indecisiveness View
    
    var profileImageView:UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "profile"))
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor(white: 0.95, alpha: 1.0).CGColor
        imageView.clipsToBounds = true
        imageView.transform = CGAffineTransformMakeScale(0, 0)
        return imageView
    }()
    
    var descriptionLabel:UILabel = {
        var label = UILabel()
        label.text = "15, STUDENT"
        label.font = UIFont(name: "GillSans-Light", size: 20)
        label.sizeToFit()
        return label
    }()
    
    var continueButton:PulsingButton?
    // Ugh, *lazy* is not an option. Everything is loaded and moved dynamically.
    
    // MARK: Curiosity View
    
    var iOSLabels:[UILabel] = {
        let strings = [["i", "Phone", "OS"], ["my first", "device"]]
        let fonts:[(String, CGFloat)] = [("HelveticaNeue-UltraLight", 70), ("GillSans-Light", 25)]
        var labels = [UILabel]()
        for stringIndex in 0..<strings.count {
            for string in strings[stringIndex] {
                var label = UILabel()
                label.text = string
                label.font = UIFont(name: fonts[stringIndex].0, size: fonts[stringIndex].1)
                label.sizeToFit()
                labels.append(label)
            }
        }
        return labels
    } ()
    
    var ipodImageView:UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "ipod"))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        return imageView
    }()
    
    // MARK: Growth View
    
    var cPlusPlusLabels:[UILabel] = {
        let strings = [["C", "++"], ["my first line of code, in", "for commandline"]]
        let fonts:[(String, CGFloat)] = [("HelveticaNeue-UltraLight", 70), ("GillSans-Light", 25)]
        var labels = [UILabel]()
        for stringIndex in 0..<strings.count {
            for string in strings[stringIndex] {
                var label = UILabel()
                label.text = string
                label.font = UIFont(name: fonts[stringIndex].0, size: fonts[stringIndex].1)
                label.sizeToFit()
                labels.append(label)
            }
        }
        return labels
    } ()
    
    // MARK: Passion View
    
    var objectiveCLabels:[UILabel] = {
        let strings = [["Objective-"], ["my first line of", "for iOS"]]
        let fonts:[(String, CGFloat)] = [("HelveticaNeue-UltraLight", 65), ("GillSans-Light", 25)]
        var labels = [UILabel]()
        for stringIndex in 0..<strings.count {
            for string in strings[stringIndex] {
                var label = UILabel()
                label.text = string
                label.font = UIFont(name: fonts[stringIndex].0, size: fonts[stringIndex].1)
                label.sizeToFit()
                labels.append(label)
            }
        }
        return labels
    } ()
    
    // MARK: Imagination View
    
    var badgeImageView:UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "badge"))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        return imageView
    }()
    
    var frameworksScrollView = FrameworksScrollView()

    // MARK: Mystery View
    
    var sloganLabel:UIView = {
        var view = UIView()
        let strings = ["The epicenter", "of change."]
        var labels = [UILabel]()
        for stringIndex in 0..<strings.count {
            var label = UILabel()
            label.text = strings[stringIndex]
            label.font = UIFont(name: "KozGoPro-ExtraLight", size: 40)
            label.textColor = UIColor.whiteColor()
            label.sizeToFit()
            labels.append(label)
        }
        labels[0].frame.origin = CGPointZero
        labels[0].frame.size.height += 10
        labels[1].center = CGPoint(x: labels[0].center.x, y: labels[0].center.y + labels[1].frame.size.height)
        labels[1].frame.size.height += 10
        labels[1].frame.origin.x += 2.5
        for label in labels {
            view.addSubview(label)
        }
        view.frame.size = CGSize(width: labels[0].frame.size.width, height: labels[0].frame.size.height + labels[1].frame.size.height)
        
        return view
    }()
    
    // MARK: - VC Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.layoutScrollingViews()
        self.layoutStaticViews() // Huge method
        
        #if DEBUG
            var tapgr = UITapGestureRecognizer(target: self, action: "segueToMain:")
            tapgr.numberOfTouchesRequired = 2
            self.view.addGestureRecognizer(tapgr) // To help debug
        #endif
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: nil, animations: { () -> Void in
            self.profileImageView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }) { (completion) -> Void in
            self.showTitle()
        }
        var button = PulsingButton(frame: CGRect(x: 0, y: 0, width: buttonLength, height: buttonLength))
        button.tag = 5
        button.pulseView.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderColor = self.colors[5].CGColor
        button.center = CGPoint(x: self.adjustedCenterX(5), y: self.view.center.y + buttonCenterOffset)
        button.startAnimations()
        self.mainScrollView.addSubview(button)
        button.addTarget(self, action: "segueToMain:", forControlEvents:.TouchUpInside)
    }
    
    // MARK: Initial Item Positions
    
    // Top of screen
    let titleCenterOffset:CGFloat = -180
    let subtitleOffset:CGFloat = -80
    let descriptionOffset:CGFloat = 30
    let buttonCenterOffset:CGFloat = 160
    // Bottom of screen
    
    let sinusoidalAmplitude:CGFloat = 25
    
    var initialProgress:CGFloat?
    var lastScrollProgress:CGFloat?
    var frameworksInitialOffset:CGFloat?
    
    func adjustedCenterX(screen:Int) -> CGFloat {
        return self.view.center.x + self.view.frame.size.width * CGFloat(screen)
    }
    
    func layoutScrollingViews() {
        self.mainScrollView.frame = self.view.frame
        self.mainScrollView.contentSize = CGSize(width: self.view.frame.size.width * 6, height: self.view.frame.size.height) // 6 pages of colors
        self.mainScrollView.delegate = self
        self.view.addSubview(self.mainScrollView)
        
        self.lineView.center = CGPoint(x: self.view.center.x + (buttonLength - buttonThickness) / 2, y: self.view.center.y + self.buttonCenterOffset)
        self.lineView.alpha = 0.0
        self.mainScrollView.addSubview(self.lineView)
        
        self.hoursOfCodeLabel.center = CGPoint(x: self.view.center.x + (buttonLength - buttonThickness) / 2, y: self.view.center.y + 90)
        self.hoursOfCodeLabel.alpha = 0.0
        self.mainScrollView.addSubview(self.hoursOfCodeLabel)
    }
    
    func layoutStaticViews() {
        for screen in 0...5 {
            var label = self.titleLabels[screen]
            if screen == 3 {
                label.center = CGPoint(x: adjustedCenterX(screen) - 128, y: self.view.center.y + titleCenterOffset) // Ugly constant :/
            } else {
                label.center = CGPoint(x: adjustedCenterX(screen), y: self.view.center.y + titleCenterOffset)
            }
            label.textColor = self.colors[screen]
            self.mainScrollView.addSubview(label)
            if screen >= 1 {
                if screen < 5 {
                    var button = PulsingButton(frame: CGRect(x: 0, y: 0, width: buttonLength, height: buttonLength))
                    button.tag = screen
                    button.layer.borderColor = self.colors[screen].CGColor
                    button.center = CGPoint(x: adjustedCenterX(screen), y: self.view.center.y + buttonCenterOffset)
                    self.mainScrollView.addSubview(button)
                    button.addTarget(self, action: "continueToNext", forControlEvents: .TouchUpInside)
                }
                var colorSubtitleLabel = UILabel()
                colorSubtitleLabel.font = UIFont(name: "Avenir-Light", size: 20)
                colorSubtitleLabel.text = colorDescriptions[screen]
                colorSubtitleLabel.sizeToFit()
                colorSubtitleLabel.center = CGPoint(x: adjustedCenterX(screen), y: self.view.center.y + 190)
                colorSubtitleLabel.textColor = self.colors[screen]
                self.mainScrollView.addSubview(colorSubtitleLabel)
                
                var dateLabel = UILabel()
                dateLabel.font = self.descriptionLabel.font
                dateLabel.text = keyDates[screen]
                dateLabel.sizeToFit()
                dateLabel.textColor = colors[screen]
                dateLabel.frame.origin = CGPoint(x: 5 + self.view.frame.size.width * CGFloat(screen), y: self.lineView.frame.origin.y - dateLabel.frame.size.height)
                self.mainScrollView.addSubview(dateLabel)
            }
        }
        self.titleLabels[0].alpha = 0.0
        
        self.profileImageView.center = self.view.center
        self.mainScrollView.addSubview(self.profileImageView)
        
        self.descriptionLabel.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 140)
        self.descriptionLabel.alpha = 0.0
        self.mainScrollView.addSubview(self.descriptionLabel)
        
        let ipodImageSize = self.ipodImageView.image!.size
        self.ipodImageView.frame.size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width / ipodImageSize.width * ipodImageSize.height)
        self.ipodImageView.center = CGPoint(x: adjustedCenterX(1), y: 0) // Initial position
        self.mainScrollView.addSubview(self.ipodImageView)
        
        var badgeImageSize = self.badgeImageView.image!.size
        self.badgeImageView.frame.size = CGSize(width: self.view.frame.size.width * 0.6, height: self.view.frame.size.width * 0.6 / badgeImageSize.width * badgeImageSize.height)
        self.badgeImageView.center = CGPoint(x: adjustedCenterX(4), y: 0) // Initial position
        self.mainScrollView.addSubview(self.badgeImageView)
        
        let labelSets = [self.iOSLabels, self.cPlusPlusLabels, self.objectiveCLabels]
        let labelOffsets:[[(CGFloat, CGFloat)]] = [[(-135, 0), (-40, 0), (105, 0), (0, -43), (0, 43)], [(-40, 0), (28, 0), (0, -43), (0, 43)], [(-22, 0), (0, -43), (0, 43)]] // Hardcoded offsets
        for labelSetIndex in 1...labelSets.count {
            for labelIndex in 0..<labelSets[labelSetIndex - 1].count {
                labelSets[labelSetIndex - 1][labelIndex].center = CGPoint(x: self.adjustedCenterX(labelSetIndex) + labelOffsets[labelSetIndex - 1][labelIndex].0, y: self.view.center.y + subtitleOffset + labelOffsets[labelSetIndex - 1][labelIndex].1)
                labelSets[labelSetIndex - 1][labelIndex].textColor = self.colors[labelSetIndex].colorByAdding(-0.3)
                self.mainScrollView.addSubview(labelSets[labelSetIndex - 1][labelIndex])
            }
        }
        
        let descriptions = ["it was magic, \nwith unbelievable interactivity", "every programmer starts\nwith something simple", "simplicity can be expressed\nin different languages", "my first WWDC at 14,\nreceived scholarship"]
        for descriptionIndex in 1...descriptions.count {
            var descriptionLabel = UILabel()
            descriptionLabel.text = descriptions[descriptionIndex - 1]
            descriptionLabel.numberOfLines = 2
            descriptionLabel.font = UIFont(name: "GillSans-Light", size: 25)
            descriptionLabel.textAlignment = .Center
            descriptionLabel.sizeToFit()
            descriptionLabel.center = CGPoint(x: self.adjustedCenterX(descriptionIndex), y: self.view.center.y + descriptionOffset)
            self.mainScrollView.addSubview(descriptionLabel)
        }
        
        // Container view does two things. It adds a mask and also makes the inside scrollview's bounce independent.
        var containerView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.frameworksScrollView.frame.size.height))
        containerView.center = CGPoint(x: self.adjustedCenterX(4), y: self.view.center.y - 80)
        var gradient = CAGradientLayer()
        var transparent = UIColor.clearColor().CGColor
        var opaque = UIColor.blackColor().CGColor
        gradient.frame = containerView.bounds
        gradient.colors = [transparent, opaque, opaque, transparent]
        gradient.startPoint = CGPointMake(0.0, 0.5) // Change to horizontal
        gradient.endPoint = CGPointMake(1.0, 0.5)
        
        containerView.layer.mask = gradient
        containerView.bounces = false
        
        self.frameworksScrollView.frame.size.width = self.view.frame.size.width
        containerView.addSubview(self.frameworksScrollView)
        
        self.mainScrollView.addSubview(containerView)
        
        self.sloganLabel.center = CGPoint(x: self.adjustedCenterX(5), y: self.view.center.y - 35)
        self.mainScrollView.addSubview(self.sloganLabel)
    }
    
    // MARK: - Scroll View Delegate
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x // Scroll view offset
        if offset >= 0 {
            let screen = Int(offset / self.view.frame.size.width)
            self.animateScreens(offset: offset, screen: screen)
        } else {
            self.lineView.frame.size.width = 0
        }
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.initialProgress = nil
        self.lastScrollProgress = nil
        self.frameworksInitialOffset = nil
    }
    
    // MARK: Dynamic Screens
    
    func animateScreens(#offset:CGFloat, screen:Int) { // Woah, an array of methods :D
        let progress = (offset - CGFloat(screen) * self.view.frame.size.width) / self.view.frame.size.width
        self.animateOffsetViews(offset: offset, screen: screen, progress: progress)
        let firstAnimation = self.animationMethods[screen]
        firstAnimation(self)(offset: offset, screen: screen, progress: progress + 1)
        if self.animationMethods.count > screen + 1 {
            let secondAnimation = self.animationMethods[screen + 1]
            secondAnimation(self)(offset: offset, screen: screen, progress: progress)
        }
    }
    // The following 7 methods is the most dense code I've written. Its basically all math.
    func animateOffsetViews(#offset:CGFloat, screen:Int, progress:CGFloat) {
        let sinusoidalOffset:CGFloat = sinusoidalAmplitude * CGFloat(-cos(M_PI * 2.0 / Double(self.view.frame.size.width) * Double(offset))) + sinusoidalAmplitude
        self.lineView.frame.size.width = min(offset + sinusoidalOffset, 5 * self.view.frame.size.width)
        let currentColor = self.colors[screen]
        let nextColor = self.colors[min(screen + 1, 5)] // so no accidental overflow
        var cr:CGFloat = 0.0, cg:CGFloat = 0.0, cb:CGFloat = 0.0, nr:CGFloat = 0.0, ng:CGFloat = 0.0, nb:CGFloat = 0.0
        currentColor.getRed(&cr, green: &cg, blue: &cb, alpha: nil)
        nextColor.getRed(&nr, green: &ng, blue: &nb, alpha: nil)
        self.lineView.backgroundColor = UIColor(red: cr + (nr - cr) * progress, green: cg + (ng - cg) * progress, blue: cb + (nb - cb) * progress, alpha: 1.0)
        
        let adjustedProgress = CGFloat(screen) + progress
        let currentNumberOfHours = self.hoursOfCode[screen]
        let newNumberOfHours = self.hoursOfCode[min(screen + 1, 5)]
        let numberOfHours = Int(progress * CGFloat(newNumberOfHours - currentNumberOfHours) + CGFloat(currentNumberOfHours))
        self.hoursOfCodeLabel.alpha = 1.5 * adjustedProgress - 0.5
        self.hoursOfCodeLabel.backgroundColor = self.lineView.backgroundColor
        self.hoursOfCodeLabel.text = " \(numberOfHours) hours of code "
        self.hoursOfCodeLabel.sizeToFit()
        self.hoursOfCodeLabel.center.x = min(offset + self.view.frame.size.width / 2, adjustedCenterX(5))
    }
    
    func animateIndecisivenessScreen(#offset:CGFloat, screen:Int, progress:CGFloat) {
        self.continueButton?.removeAnimations() // Remove animations when moved
    }
    
    func animateCuriosityScreen(#offset:CGFloat, screen:Int, progress:CGFloat) {
        let verticalTitleLabelOffset = self.titleLabels[1].frame.origin.y + 5 // Every bit matters
        let curvedOffset = progress * CGFloat(M_PI)
        let adjustedVerticalOffset = -verticalTitleLabelOffset / 2 * cos(curvedOffset) + verticalTitleLabelOffset / 2
        self.ipodImageView.center.y =  adjustedVerticalOffset - self.ipodImageView.frame.size.height / 2

        var adjustedProgress = max(progress - 1.0, 0)
        
        self.iOSLabels[1].alpha = -4.0 * adjustedProgress + 1.0 // When did y = mx + b become so popular?
        self.iOSLabels[0].center.x = min(self.view.frame.size.width * adjustedProgress, self.iOSLabels[1].frame.size.width + 2) + adjustedCenterX(1) + -135
        self.iOSLabels[3].center.x = min(self.iOSLabels[1].frame.size.width * adjustedProgress, self.iOSLabels[1].frame.size.width / 2) + adjustedCenterX(1)
        self.iOSLabels[4].center.x = self.iOSLabels[3].center.x
    }
    
    func animateGrowthScreen(#offset:CGFloat, screen:Int, progress:CGFloat) {
        let numberOfLetters = 14
        self.titleLabels[2].text = "\"Hello World\";".substringToIndex(Int(CGFloat(numberOfLetters) * cgfUnitClamp(progress * 4.0 - 2.5)))
        
        let adjustedProgress = max(progress - 1.0, 0)
        self.cPlusPlusLabels[1].alpha = -4.0 * (progress - 1) + 1.0
        let distanceToTravel = self.cPlusPlusLabels[0].frame.size.width + (self.objectiveCLabels[0].frame.origin.x - self.cPlusPlusLabels[1].frame.origin.x) + self.objectiveCLabels[0].frame.size.width
        self.cPlusPlusLabels[0].center.x = min(distanceToTravel * adjustedProgress, distanceToTravel) + adjustedCenterX(2) - 40
        self.objectiveCLabels[0].alpha = max((3 * adjustedProgress - 2), 0.2)
    }
    
    func animatePassionScreen(#offset:CGFloat, screen:Int, progress:CGFloat) {
        let adjustedProgress = min(progress, 1.0)
        self.titleLabels[2].center.x = max(min((self.view.center.x * (1 + adjustedProgress / 10)) + offset, self.view.center.x * 1.1 + self.view.frame.size.width * 3), adjustedCenterX(2))
        self.titleLabels[3].alpha = max((3 * adjustedProgress - 2), 0.2)
        var cr:CGFloat = 0, cg:CGFloat = 0, cb:CGFloat = 0, nr:CGFloat = 0, ng:CGFloat = 0, nb:CGFloat = 0
        self.colors[2].getRed(&cr, green: &cg, blue: &cb, alpha: nil)
        self.colors[3].getRed(&nr, green: &ng, blue: &nb, alpha: nil)
        self.titleLabels[2].textColor = UIColor(
            red: cr + (nr - cr) * adjustedProgress,
            green: cg + (ng - cg) * adjustedProgress,
            blue: cb + (nb - cb) * adjustedProgress,
            alpha: 1.0)
        self.cPlusPlusLabels[0].textColor = self.titleLabels[2].textColor.colorByAdding(-0.3)
    }
    
    // All of this is to make the auto scrolling scroll off at where *your* scroll left off. Try scrolling the frameworks, and then scroll the main scroll.
    func animateImaginationScreen(#offset:CGFloat, screen:Int, progress:CGFloat) {
        let verticalTitleLabelOffset = self.view.frame.size.height - self.lineView.center.y - 50
        let curvedOffset = progress * CGFloat(M_PI)
        let adjustedVerticalOffset = verticalTitleLabelOffset / 2 * cos(curvedOffset) - verticalTitleLabelOffset / 2
        self.badgeImageView.frame.origin.y = adjustedVerticalOffset + self.view.frame.size.height
        
        let maximumOffset = self.frameworksScrollView.contentSize.width - self.frameworksScrollView.frame.size.width
        // get the initial offset the first time
        if self.initialProgress == nil {
            self.initialProgress = progress
            return;
        }
        // SCROLL DIRECTION
        var direction = false
        if self.lastScrollProgress == nil {
            self.lastScrollProgress = self.initialProgress
            direction = progress > self.lastScrollProgress
        } else {
            direction = progress > self.lastScrollProgress
            if self.lastScrollProgress != self.initialProgress {
                let lastDirection = Bool(self.lastScrollProgress > self.initialProgress)
                if direction != lastDirection {
                    // If opposite directions, reassign variables
                    self.initialProgress = self.lastScrollProgress
                    self.frameworksInitialOffset = self.frameworksScrollView.contentOffset.x
                }
            }
        }
        // CONTENT OFFSET
        if self.frameworksInitialOffset == nil {
            self.frameworksInitialOffset = self.frameworksScrollView.contentOffset.x
        }
        if direction {
            let adjustedProgress = 1 - (2 - progress) / (2 - self.initialProgress!)
            self.frameworksScrollView.contentOffset.x = (maximumOffset - self.frameworksInitialOffset!) * adjustedProgress + self.frameworksInitialOffset!
        } else {
            let adjustedProgress = progress / self.initialProgress!
            self.frameworksScrollView.contentOffset.x = self.frameworksInitialOffset! * adjustedProgress
        }
        
        self.lastScrollProgress = progress
    }
    
    func animateMysteryScreen(#offset:CGFloat, screen:Int, progress:CGFloat) {
        let previousColor = UIColor.whiteColor()
        let newColor = UIColor.blackColor()
        let adjustedProgress = progress * 2.3 - 1.3
        var cr:CGFloat = 0.0, cg:CGFloat = 0.0, cb:CGFloat = 0.0, nr:CGFloat = 0.0, ng:CGFloat = 0.0, nb:CGFloat = 0.0
        previousColor.getRed(&cr, green: &cg, blue: &cb, alpha: nil)
        newColor.getRed(&nr, green: &ng, blue: &nb, alpha: nil)
        self.view.backgroundColor = UIColor(red: cr + (nr - cr) * adjustedProgress, green: cg + (ng - cg) * adjustedProgress, blue: cb + (nb - cb) * adjustedProgress, alpha: 1.0)
        self.hoursOfCodeLabel.textColor = self.view.backgroundColor
    }
    
    // MARK: -
    
    func showTitle() {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.titleLabels[0].alpha = 1.0
        }) { (completion) -> Void in
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.descriptionLabel.alpha = 1.0
            }) { (completion) -> Void in
                self.continueButton = PulsingButton(frame: CGRect(x: 0, y: 0, width: buttonLength, height: buttonLength))
                self.continueButton!.alpha = 0.0
                self.continueButton!.startAnimations()
                
                self.mainScrollView.addSubview(self.continueButton!)
                self.mainScrollView.scrollEnabled = true
                
                self.continueButton!.addTarget(self, action: "continueToNext", forControlEvents: .TouchUpInside)
                self.continueButton!.center = CGPoint(x: self.view.center.x, y: self.view.center.y + self.buttonCenterOffset)
                UIView.animateWithDuration(5.0, delay: 0.0, options: .AllowUserInteraction, animations: { () -> Void in
                    self.continueButton!.alpha = 1.0
                    self.lineView.alpha = 1.0
                }, completion: nil)
            }
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var currentTween:PMTweenUnit?
    
    func continueToNext() {
        let offset = self.mainScrollView.contentOffset.x
        if offset >= 0 {
            let screen = Int(offset / self.view.frame.size.width)
            if screen < 5 {
                self.view.userInteractionEnabled = false
                var tween = PMTweenUnit(
                    object: self.mainScrollView,
                    propertyKeyPath: "contentOffset.x",
                    startingValue: Double(self.mainScrollView.contentOffset.x),
                    endingValue: Double(self.view.frame.size.width) * Double(screen + 1),
                    duration: 1.5,
                    options: .None,
                    easingBlock: PMTweenEasingQuadratic.easingInOut())
                tween.completeBlock = { (_) -> Void in
                    self.view.userInteractionEnabled = true
                }
                self.currentTween = tween
                self.currentTween!.startTween()
                /* Why tween? Try the following code and you'll see. Every bit of detail matters.
                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.mainScrollView.contentOffset = CGPoint(self.view.frame.size.width * CGFloat(screen + 1), 0)
                }, completion: nil)
                */
            }
        }
    }
    
    func segueToMain(sender: UIButton) {
        sender.enabled = false
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.mainScrollView.alpha = 0.0
            self.view.backgroundColor = UIColor.whiteColor()
        }) { (compeletion) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("welcomeDidComplete", object: self)
        }
    }
}

extension UIColor {
    func colorByAdding(f:CGFloat) -> UIColor? {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        if !self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return nil
        }
        return UIColor(red: cgfUnitClamp(r + f), green: cgfUnitClamp(g + f), blue: cgfUnitClamp(b + f), alpha: a)
    }
}
