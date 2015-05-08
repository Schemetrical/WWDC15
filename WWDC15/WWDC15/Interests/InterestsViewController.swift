//
//  InterestsViewController.swift
//  WWDC15App
//
//  Created by Yichen Cao on 4/14/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

import UIKit

class InterestsViewController: UIViewController, UIScrollViewDelegate {
    
    let descriptions = [
        "Its the 21st century. Information is abundant. No longer do you have to write mail to people; there's an app for that. No longer do you have to buy the daily newspaper; there's an app for that.\nBut in a world of information, sometimes its the information that distracts us. Fahrenheit 451; filled with \"non-combustible data\".\nBut we can change that. Phones are supposed to make lives simpler, not lure our attention away from others. At a table where everyone's busy staring at a small screen, what conversation could exist?\nProgramming empowers us to change things. I believe that content should be simple and clean, minimal and on the point. Maybe in a world where technology is invisible, transparent, will we see people who stare at their screens less and talk more.",
        "Everything we see around the world is designed. \nLook around. Think of the millions of hours spent to make the room you're in right now feel this way. Its just how it is. You shouldn't realise that countless hours have been spent to perfect that table corner because good design, not unlike good technology, is transparent. \nI find design to be something natural, spontaneous, but fitting. Good design should feel like its in the right place, at the right moment.",
        "An instant, captured through light passing through precisely engineered lens and sensors, ends up in one image. \nThe silent picture on the table sits to delight passers-by, letting people remember moments of the past from a frozen instant.\nThe art of capturing that instant, of joy or sadness, of action or peace, is something so beautiful, so unique. I think that capturing that unique moment is the beauty of photography.",
        "From the complex richness of colors to the thick textures, drawing takes your observation and puts it onto paper. \nAs a more recent interest of mine, the interweaved colors that form a rich black create so much texture than a pure black. Its not the result that matters, its the process you go through to achieve the result that matters.",
        "Music is art for your ears. I played the violin since I was five, and music has become part of my life.\nFrom the polyphonic dissonance of Bach to the intertwining of tunes from Dvořák, every single note fits perfectly into every phrase. \nI play violin when I'm excited, bored, delighted; sometimes it helps me think, when I'm confused or stuck. Music is something that will truly last forever.",
        "Action is something that everyone needs. I frequently go out for hikes, perhaps a week of camp and hike at 4500m above sea level.\nBut swimming is different. Its completely opposite to our daily lives. In water, suddenly everything seems insignificant. Gravity is no longer present. Being hydrodynamic is much more important. Aside from JV swimming, I also dive recreationally, recently getting my PADI AOWD license."]
    
    var mainScrollView:UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.pagingEnabled = true
        #if !DEBUG
            scrollView.scrollEnabled = false // for debugging
        #endif
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    var titleLabel:UILabel = {
        var label = UILabel()
        label.text = "Interests"
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 45)
        label.alpha = 0
        label.sizeToFit()
        return label
    }()
    
    var balanceTitleLabel:UILabel = {
        var label = UILabel()
        label.text = "Balance"
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 45)
        label.alpha = 0
        label.sizeToFit()
        return label
    }()
    
    var continueArrow:UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "arrow"))
        imageView.alpha = 0
        imageView.tintColor = UIColor.blackColor()
        return imageView
    }()
    
    var subtitleLabels:[[(UILabel, PulsingButton)]] = {
        let titleSets = [["Programming", "Design"], ["Photography", "Drawing"], ["Violin", "Swimming"]]
        var titleLabelSets = [[(UILabel, PulsingButton)]]()
        for titleSet in titleSets {
            var titleLabelSet = [(UILabel, PulsingButton)]()
            for title in titleSet {
                var label = UILabel()
                label.text = title
                label.font = UIFont(name: "Avenir-Light", size: 20)
                label.alpha = 0
                label.sizeToFit()
                
                var button = PulsingButton(frame: CGRect(x: 0, y: 0, width: buttonLength, height: buttonLength))
                button.layer.borderWidth = 0.0
                button.backgroundColor = UIColor.blackColor()
                
                titleLabelSet.append((label, button))
            }
            titleLabelSets.append(titleLabelSet)
        }
        return titleLabelSets
    }()
    
    var connectingLines:[UIView] = {
        var lines = [UIView]()
        for lineIndex in 0..<3 { // <3
            var line = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: buttonThickness))
            line.backgroundColor = UIColor.blackColor()
            lines.append(line)
        }
        return lines
    }()
    
    var activityImageView:UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFit
        imageView.alpha = 0
        return imageView
    }()
    
    var activityTitleLabel:UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 45)
        label.textColor = UIColor.whiteColor()
        label.alpha = 0
        return label
    }()
    
    var activityDescriptionView:PassingTapsTextView = {
        var textView = PassingTapsTextView()
        textView.backgroundColor = nil
        textView.alpha = 0
        textView.editable = false
        textView.selectable = false
        textView.indicatorStyle = .White
        textView.contentInset.bottom = 10
        textView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        return textView
    }()
    
    var connectingLineWidth:CGFloat = 180
    
    var connectingLineDistance:CGFloat = 120

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.connectingLineWidth = self.view.frame.size.width * 0.6
        self.connectingLineDistance = self.view.frame.size.height / 6 + 40
        
        layoutScrollingViews()
        
        self.activityImageView.frame.size.width = self.view.frame.size.width - 40
        self.activityImageView.frame.size.height = self.activityImageView.frame.size.width / 4 * 3 // So 4:3 image
        self.activityImageView.frame.origin = CGPointMake(20, self.view.frame.size.height - self.activityImageView.frame.size.height - 20 - self.tabBarController!.tabBar.frame.size.height)
        self.view.addSubview(self.activityImageView)
        self.view.addSubview(self.activityTitleLabel)
        
        var containerView = UIView()
        var gradient = CAGradientLayer()
        var transparent = UIColor.clearColor().CGColor
        var opaque = UIColor.blackColor().CGColor
        gradient.colors = [transparent, opaque, opaque, transparent]
        gradient.locations = [0.0, 0.05, 0.9, 1.0]
        gradient.startPoint = CGPointMake(0.5, 0.0)
        gradient.endPoint = CGPointMake(0.5, 1.0)
        containerView.layer.mask = gradient
        self.view.addSubview(containerView)
        containerView.addSubview(self.activityDescriptionView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if Int(self.mainScrollView.contentOffset.y / self.view.frame.size.height) != 4 {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.balanceTitleLabel.alpha = 1.0
            }) { (completion) -> Void in
                self.mainScrollView.scrollEnabled = true
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.continueArrow.alpha = 1.0
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adjustedCenterY(screen:Int) -> CGFloat {
        return self.view.center.y + self.view.frame.size.height * CGFloat(screen) - 15
    }
    
    func layoutScrollingViews() {
        self.mainScrollView.frame = self.view.frame
        self.mainScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height * 5) // 5 pages of content
        self.mainScrollView.delegate = self
        self.mainScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.size.height, right: 0)
        self.view.addSubview(self.mainScrollView)
        
        self.balanceTitleLabel.center = CGPointMake(self.view.center.x, adjustedCenterY(0))
        self.mainScrollView.addSubview(self.balanceTitleLabel)
        
        self.continueArrow.center = CGPoint(x: self.view.frame.size.width - 15, y: self.view.frame.size.height - 75)
        self.mainScrollView.addSubview(continueArrow)
        
        for subtitleLabelSetIndex in 0..<self.subtitleLabels.count {
            for subtitleLabelIndex in 0..<self.subtitleLabels[subtitleLabelSetIndex].count {
                var label = self.subtitleLabels[subtitleLabelSetIndex][subtitleLabelIndex].0
                label.center = CGPoint(x: self.view.center.x, y: adjustedCenterY(subtitleLabelSetIndex + 1) + self.connectingLineDistance * CGFloat(subtitleLabelSetIndex - 1) + 30)
                label.alpha = CGFloat(1 - subtitleLabelIndex)
                self.mainScrollView.addSubview(label)
                
                var button = self.subtitleLabels[subtitleLabelSetIndex][subtitleLabelIndex].1
                button.center = CGPoint(x: self.view.center.x, y: adjustedCenterY(subtitleLabelSetIndex + 1) + self.connectingLineDistance * CGFloat(subtitleLabelSetIndex - 1))
                button.alpha = CGFloat(1 - subtitleLabelIndex)
                button.tag = subtitleLabelSetIndex * 2 + subtitleLabelIndex
                self.mainScrollView.addSubview(button)
            }
            self.mainScrollView.addSubview(self.subtitleLabels[subtitleLabelSetIndex][0].1)
            self.mainScrollView.addSubview(self.connectingLines[subtitleLabelSetIndex])
        }
        
        self.titleLabel.center = CGPointMake(self.view.center.x, (self.view.center.y - 150) / 2)
        self.view.addSubview(self.titleLabel)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y // Scroll view offset
        if offset >= 0 {
            let screen = Int(offset / self.view.frame.size.height)
            let progress = (offset - CGFloat(screen) * self.view.frame.size.height) / self.view.frame.size.height
            self.animateScreens(offset: offset, screen: screen, progress: progress)
        }
        self.continueArrow.center.y = min(self.view.frame.size.height - 75 + offset, self.view.frame.size.height - 75 + self.view.frame.size.height * 3)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.y / self.view.frame.size.height) == 4 {
            scrollView.scrollEnabled = false
            for subtitleLabelSetIndex in 0..<self.subtitleLabels.count {
                for subtitleLabelIndex in 0..<self.subtitleLabels[subtitleLabelSetIndex].count {
                    NSTimer.scheduledTimerWithTimeInterval(Double(subtitleLabelSetIndex) * 0.2 + Double(subtitleLabelIndex) * 0.2, target: self, selector: "animateButtons:", userInfo: self.subtitleLabels[subtitleLabelSetIndex][subtitleLabelIndex].1, repeats: false)
                }
            }
        }
    }
    
    func animateScreens(#offset:CGFloat, screen:Int, progress:CGFloat) {
        let contentScreen = screen - 1
        for subtitleLabelSetIndex in 0..<self.subtitleLabels.count {
            for subtitleLabelIndex in 0..<self.subtitleLabels[subtitleLabelSetIndex].count {
                var label = self.subtitleLabels[subtitleLabelSetIndex][subtitleLabelIndex].0
                label.center = CGPoint(
                    x: self.view.center.x + CGFloat(subtitleLabelIndex * 2 - 1) * connectingLineWidth / 2 * (screen <= subtitleLabelSetIndex ? 0 : screen == subtitleLabelSetIndex + 1 ? progress : 1),
                    y: max(adjustedCenterY(subtitleLabelSetIndex + 1), offset + self.view.frame.size.height / 2) + self.connectingLineDistance * CGFloat(subtitleLabelSetIndex - 1) + 30)
                self.mainScrollView.addSubview(label)
                
                var button = self.subtitleLabels[subtitleLabelSetIndex][subtitleLabelIndex].1
                button.center = CGPoint(
                    x: self.view.center.x + CGFloat(subtitleLabelIndex * 2 - 1) * connectingLineWidth / 2 * (screen <= subtitleLabelSetIndex ? 0 : screen == subtitleLabelSetIndex + 1 ? progress : 1),
                    y: max(adjustedCenterY(subtitleLabelSetIndex + 1) + self.connectingLineDistance * CGFloat(subtitleLabelSetIndex - 1), offset + self.view.frame.size.height / 2 + self.connectingLineDistance * CGFloat(subtitleLabelSetIndex - 1)))
                self.mainScrollView.addSubview(button)
            }
            self.subtitleLabels[subtitleLabelSetIndex][1].1.alpha = offset <= (CGFloat(subtitleLabelSetIndex + 1) * self.view.frame.size.height) ? 0 : 1
            self.mainScrollView.addSubview(self.subtitleLabels[subtitleLabelSetIndex][0].1)
            
            var line = self.connectingLines[subtitleLabelSetIndex]
            line.frame.size.width = connectingLineWidth * (screen <= subtitleLabelSetIndex ? 0 : screen == subtitleLabelSetIndex + 1 ? progress : 1)
            line.center = CGPoint(
                x: self.view.center.x,
                y: max(adjustedCenterY(subtitleLabelSetIndex + 1) + 120 * CGFloat(subtitleLabelSetIndex - 1), offset + self.view.frame.size.height / 2 + self.connectingLineDistance * CGFloat(subtitleLabelSetIndex - 1)))
            
            var rightLabel = self.subtitleLabels[subtitleLabelSetIndex][1].0
            rightLabel.alpha = screen <= subtitleLabelSetIndex ? 0 : screen == subtitleLabelSetIndex + 1 ? progress : 1
        }
        self.titleLabel.alpha = screen <= 2 ? 0 : screen == 3 ? progress : 1
    }
    
    func animateButtons(sender:NSTimer) {
        var button = sender.userInfo as! PulsingButton
        button.startAnimations()
        button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
    }
    
    func buttonPressed(sender:PulsingButton) {
        sender.removeAnimations()
        sender.animationFinished(nil)
        if (sender.tag >= 10) {
            sender.tag -= 10
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.activityImageView.alpha = 0.0
                self.activityTitleLabel.alpha = 0.0
                self.activityDescriptionView.alpha = 0.0
            })
            self.mainScrollView.userInteractionEnabled = false
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                sender.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: { (finished) -> Void in
                if finished {
                    self.view.bringSubviewToFront(self.mainScrollView)
                    self.mainScrollView.userInteractionEnabled = true
                }
            })
        } else {
            self.mainScrollView.bringSubviewToFront(sender)
            self.view.sendSubviewToBack(self.mainScrollView)
            let scaleToAnimate:CGFloat = (sqrt(pow(self.view.frame.size.width, 2) + pow(self.view.frame.size.height, 2)) * 0.77) / (buttonLength / 2)
            
            self.modifyActivityImageView(buttonIndex: sender.tag)
            self.modifyActivityDescriptionView(buttonIndex: sender.tag)
            self.activityDescriptionView.button = sender
            
            sender.tag += 10
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                sender.transform = CGAffineTransformMakeScale(scaleToAnimate, scaleToAnimate)
            })
            self.mainScrollView.userInteractionEnabled = false
            UIView.animateWithDuration(0.5, delay: 0.5, options: nil, animations: { () -> Void in
                self.activityImageView.alpha = 1.0
                self.activityTitleLabel.alpha = 1.0
                self.activityDescriptionView.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    self.activityDescriptionView.flashScrollIndicators()
                    self.mainScrollView.userInteractionEnabled = true
                }
            })
        }
    }
    
    func modifyActivityImageView(#buttonIndex: Int) {
        let names = ["Programming", "Design", "Photography", "Drawing", "Violin", "Swimming"]
        self.activityImageView.image = UIImage(named: names[buttonIndex].lowercaseString)
        self.activityTitleLabel.text = names[buttonIndex]
        self.activityTitleLabel.sizeToFit()
        self.activityTitleLabel.center.x = self.view.center.x
        self.activityTitleLabel.frame.origin.y = 20
    }
    
    func modifyActivityDescriptionView(#buttonIndex: Int) {
        self.activityDescriptionView.superview!.frame.origin = CGPoint(x: 20, y: self.activityTitleLabel.frame.origin.y + self.activityTitleLabel.frame.size.height)
        self.activityDescriptionView.superview!.frame.size = CGSize(width: self.activityImageView.frame.size.width, height: self.activityImageView.frame.origin.y - self.activityDescriptionView.superview!.frame.origin.y)
        self.activityDescriptionView.frame = self.activityDescriptionView.superview!.bounds
        self.activityDescriptionView.superview!.layer.mask.frame = self.activityDescriptionView.superview!.bounds
        self.activityDescriptionView.contentOffset = CGPointZero
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1.0
        paragraphStyle.paragraphSpacingBefore = 20
        self.activityDescriptionView.attributedText = NSAttributedString(string: descriptions[buttonIndex], attributes: [NSParagraphStyleAttributeName:paragraphStyle])
        self.activityDescriptionView.font = UIFont(name: "Avenir-Light", size: 20)
        self.activityDescriptionView.textColor = UIColor.whiteColor()
    }
}
