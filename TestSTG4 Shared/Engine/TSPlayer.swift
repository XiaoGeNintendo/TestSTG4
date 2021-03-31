//
//  TSPlayer.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/3/20.
//

import Foundation
import SpriteKit

class TSPlayer:TSObject{
    var grazeRange: Double = 50
    var hitbox: Double = 1
    
    var hitshow=SKSpriteNode()
    /**
     MacOS Version only
     */
    var moveSpeed: Double = 3
    
    var invFrame: Int = 0
    var deathbombWindow : Int = 0
    override init(){
        super.init()
        
        hitshow.texture=SKTexture(imageNamed: "hitbox")
        hitshow.size=CGSize(width: 64, height: 64)
        hitshow.run(SKAction.repeatForever(SKAction.rotate(byAngle: 2*3.14, duration: 5)))
        addChild(hitshow)
    }
    
    func collide(bullet: TSBullet) -> Bool{
        let dis=pow(bullet.x-x,2)+pow(bullet.y-y,2)
        return dis<pow(hitbox,2)+pow(bullet.hitbox, 2)
    }
    
    func graze(bullet: TSBullet) -> Bool{
        let dis=pow(bullet.x-x,2)+pow(bullet.y-y,2)
        return dis<pow(grazeRange,2)+pow(bullet.hitbox, 2)
    }
    
    override func update() {
        x=min(max(0,x),Double(WIDTH))
        y=min(max(0,y),Double(HEIGHT))
        
        invFrame=max(0,invFrame-1)
        
        if deathbombWindow==1{
            boss?.system.onDeathbombWindowEnd()
        }
        deathbombWindow=max(0,deathbombWindow-1)
        
        if invFrame%2==0{
            alpha=1
        }else{
            alpha=0.5
        }
        
        super.update()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
