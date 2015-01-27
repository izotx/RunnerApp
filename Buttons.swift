//
//  Buttons.swift
//  RunnerApp
//
//  Created by Janusz Chudzynski on 1/26/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation
import UIKit

class startButton:UIButton{
    override  init(frame: CGRect) {
        super.init(frame: frame)
            }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.backgroundColor = UIColor.clearColor()
    

    }
    
    override func drawRect(rect: CGRect) {
       self.backgroundColor = UIColor.clearColor()
        if self.state == UIControlState.Highlighted || self.state == UIControlState.Selected
        {
                StyleKitName.drawSelectedStartButton(frame: rect)
        }
        else
        {       StyleKitName.drawStartButton(frame: rect)
            
        }

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        self.setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
//             StyleKitName.drawSelectedStartButton(frame: self.frame)
            self.setNeedsDisplay()
    }
    
}

class stopButton:UIButton{
    override  init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        if self.state == UIControlState.Highlighted
        {
            StyleKitName.drawStopButton(frame: rect)
        }
        else
        {       StyleKitName.drawStopButton(frame: rect)
        
        }
        

    }
    
    
}

class pauseButton:UIButton{
    override  init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        StyleKitName.drawPauseButton(frame: rect)
    }
    
}
