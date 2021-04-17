//
//  TSEnemy.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/4/17.
//

import Foundation
import SpriteKit

/**
 A TSObject with health
 */
class TSEnemy: TSObject{
    var hp: Double
    var hitboxP: Double
    var hitboxB: Double
    var display: SKSpriteNode = SKSpriteNode()
    var autoFree = true
    
    init(hp: Double, playerHitbox: Double, bulletHitbox: Double){
        self.hp=hp
        self.hitboxP=playerHitbox
        self.hitboxB=bulletHitbox
        super.init()
        
        position=CGPoint(x: -1000, y: -1000)
        
        self.display.position=CGPoint(x: 0, y: 0)
        display.texture=SKTexture(imageNamed: "testEnemy")
        display.size=CGSize(width: 32, height: 32)
        addChild(display)
    }
    
    /**
     Delete this enemy ELEGANTLY
     */
    func delete(){
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
