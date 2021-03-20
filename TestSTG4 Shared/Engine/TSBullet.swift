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
    var alive=true
    
    var grazeCount=1
    
    var hitbox:Double = 0
    var id: Int = -1
    
    init(type: Int){
        self.type=type
        self.display=SKSpriteNode()
        super.init()
        
        hitbox=Double(min(sheet[type][SS_SX], sheet[type][SS_SY]))/3.0
        
//        display.texture=SKTexture(imageNamed: "shotsheet")
        display.texture=textureCache[type]
        display.position=CGPoint(x: 0,y: 0)
        display.size=CGSize(width: sheet[type][SS_SX],height: sheet[type][SS_SY])
        display.alpha=0
        display.setScale(5)
        display.run(SKAction.scale(to: 1, duration: 0.1))
        display.run(SKAction.fadeIn(withDuration: 0.1))
        addChild(display)
    }
    
    func isOOB() -> Bool{
        let VALUE:Double=100
        return x >= Double(WIDTH) + VALUE || x <= -VALUE || y >= Double(HEIGHT) + VALUE || y <= -VALUE
    }
    /**
     Delete a bullet ELEGANTLY
     */
    func delete(){
        boss?.removeBullet(id: id)
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
