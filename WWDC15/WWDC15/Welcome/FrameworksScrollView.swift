//
//  FrameworksScrollView.swift
//  WWDC15
//
//  Created by Yichen Cao on 4/21/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

import UIKit

let fadePercentage:CGFloat = 0.2

class FrameworksScrollView: UIScrollView, UIScrollViewDelegate {

    let frameworks = [["Accelerate", "Accounts", "AddressBook", "AddressBookUI", "AudioToolbox", "AudioUnit", "AVFoundation", "_AVKit", "CFNetwork", "_CloudKit", "CoreAudio", "_CoreAudioKit", "_CoreAuthentication", "CoreBluetooth", "CoreData", "CoreFoundation", "CoreImage", "CoreLocation", "CoreMedia"], ["CoreMotion", "CoreText", "CoreVideo", "EventKit", "EventKitUI", "ExternalAccessory", "Foundation", "GameController", "GameKit", "GLKit", "GSS", "_HealthKit", "_HomeKit", "iAd", "ImageIO", "IOKit", "JavaScriptCore", "_LocalAuthentication", "MapKit", "MediaAccessibility", "MediaPlayer", "MessageUI"], ["_Metal", "MobileCoreServices", "MultipeerConnectivity", "_NetworkExtension", "NewsstandKit", "_NotificationCenter", "OpenGLES", "PassKit", "_Photos", "_PhotosUI", "_PushKit", "QuartzCore", "QuickLook", "_SceneKit", "Security", "Social", "SpriteKit", "StoreKit", "UIKit", "VideoToolbox", "_WebKit"]]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showsHorizontalScrollIndicator = false
        var maximumWidth:CGFloat = 0.0
        var height:CGFloat = 0.0
        for frameworkIndex in 0..<self.frameworks.count {
            var label = UILabel()
            var attributedString = NSMutableAttributedString()
            for frameworkName in self.frameworks[frameworkIndex] {
                if frameworkName.hasPrefix("_") {
                    attributedString.appendAttributedString(NSAttributedString(string: (frameworkName as NSString).substringFromIndex(1), attributes: [NSForegroundColorAttributeName : UIColor(red: 0.333, green: 0.000, blue: 0.518, alpha: 1.0).colorByAdding(-0.3)!]))
                } else {
                    attributedString.appendAttributedString(NSAttributedString(string: frameworkName, attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()]))
                }
                attributedString.appendAttributedString(NSAttributedString(string: "   "))
            }
            label.attributedText = attributedString.attributedSubstringFromRange(NSMakeRange(0, attributedString.length - 3))
            label.font = UIFont(name: "GillSans-Light", size: 25)
            label.sizeToFit()
            if label.frame.size.width > maximumWidth {
                maximumWidth = label.frame.size.width
            }
            height += label.frame.size.height + 8
            label.frame.origin = CGPoint(x: (frameworkIndex == 1 ? 0 : 20) + 20, y: CGFloat(frameworkIndex) * (label.frame.size.height + 8))
            self.addSubview(label)
        }
        self.contentSize = CGSize(width: maximumWidth + 40, height: height - 8)
        self.frame.size = CGSize(width: maximumWidth + 40, height: height - 8)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
