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
    
    var autoFree=true
    var collideReady=false
    
    var grazeCount=1
    
    var hitbox:Double = 0
    
    convenience init(type: Int){
        self.init(type: type, duration: 0.1)
    }
    
    init(type: Int, duration: Double){
        self.type=type
        self.display=SKSpriteNode()
        super.init()
        
        position=CGPoint(x: -1000, y: -1000)
        
        hitbox=Double(min(sheet[type][SS_SX], sheet[type][SS_SY]))/3.0
        
//        display.texture=SKTexture(imageNamed: "shotsheet")
        display.texture=textureCache[type]
        display.position=CGPoint(x: 0,y: 0)
        display.size=CGSize(width: sheet[type][SS_SX],height: sheet[type][SS_SY])
        display.alpha=0
        display.setScale(5)
        display.run(SKAction.scale(to: 1, duration: duration))
        display.run(SKAction.fadeIn(withDuration: duration))
        display.run(SKAction.sequence([SKAction.wait(forDuration: duration),SKAction.run {
            self.collideReady=true
        }]))
        addChild(display)
    }
    
    func reset(type: Int){
        self.type=type
        display.texture=textureCache[type]
        display.position=CGPoint(x: 0,y: 0)
        display.size=CGSize(width: sheet[type][SS_SX],height: sheet[type][SS_SY])
        display.alpha=0
        display.setScale(5)
        display.run(SKAction.scale(to: 1, duration: 0.1))
        display.run(SKAction.fadeIn(withDuration: 0.1))
    }
    
    
    /**
     Delete a bullet ELEGANTLY
     */
    func delete(){
        boss?.removeObject(id: id)
        alive=false
        run(SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 5, duration: 0.1),
                SKAction.fadeOut(withDuration: 0.1)
            ]),
            SKAction.removeFromParent()
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
