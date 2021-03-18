//
//  TSBullet.swift
//  TestSTG4 macOS
//
//  Created by Wenqing Ge on 2021/3/17.
//

import Foundation
import SpriteKit

class TSBullet: TSObject{
    var type: Int
    
    var display: SKSpriteNode
    
    init(type: Int){
        self.type=type
        self.display=SKSpriteNode()
        super.init()
        
        display.texture=SKTexture(imageNamed: "bullet.png")
        addChild(display)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
