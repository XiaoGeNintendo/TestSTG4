//
//  TSSprite.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/4/17.
//
import Foundation
import SpriteKit

/**
 Sprite UI Component Wrapper
 */
class TSSPrite: TSObject{
    var s = SKSpriteNode()
    init(text: String){
        super.init()
        s.texture=SKTexture(imageNamed: text)
        s.position=CGPoint(x: 0, y: 0)
        addChild(s)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
