//
//  TSLabel.swift
//  TestSTG4 iOS
//
//  Created by Wenqing Ge on 2021/3/31.
//

import Foundation
import SpriteKit

/**
 Label UI Component Wrapper
 */
class TSLabel: TSObject{
    var lbl = SKLabelNode()
    init(text: String){
        super.init()
        lbl.text=text
        lbl.position=CGPoint(x: 0, y: 0)
        addChild(lbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
