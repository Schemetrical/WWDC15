//
//  PassingTapsTextView.swift
//  WWDC15
//
//  Created by Yichen Cao on 4/25/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

import UIKit

class PassingTapsTextView: UITextView {
    
    var button:UIButton?
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !self.dragging {
            self.button?.sendActionsForControlEvents(.TouchUpInside)
        } else {
            super.touchesEnded(touches, withEvent: event)
        }
    }

}
