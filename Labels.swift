//
//  Labels.swift
//  RunnerApp
//
//  Created by Janusz Chudzynski on 1/31/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable  class SingleLabel:UIView{

    required init(coder aDecoder: NSCoder) {
        self.text = ""
        super.init(coder: aDecoder)
      
    }
    
    @IBInspectable var text:String {
        didSet{
            self.setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {
        RunnerGraphicsStyleKit.drawSingleLabel(singleLabelText: self.text, mainFrame: rect)
        
    }

}

@IBDesignable  class DoubleLabel:UIView{
    required init(coder aDecoder: NSCoder) {
        self.bottomText = ""
        self.topText = ""
        super.init(coder: aDecoder)
    }

    
    @IBInspectable var bottomText:String{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var topText:String {
        didSet{
            setNeedsDisplay()
        }
    }

    
    override func drawRect(rect: CGRect) {
     
        RunnerGraphicsStyleKit.drawTwoLabels(bottomLabelText: self.bottomText, mainFrame: rect, topLabelText: self.topText)
    }
    
}
