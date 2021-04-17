//
//  TSPlayerShot.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/4/17.
//

import Foundation
import SpriteKit

class TSPlayerShot: TSBullet, IPlayerShotCollisionDetect{
    func hit(enemy: TSEnemy, scene: STGScene) -> Bool {
        let dis=pow(enemy.x-x,2)+pow(enemy.y-y,2)
        return penetrate>0 && dis<pow(hitbox,2)+pow(enemy.hitboxB, 2)
    }
    
    func onHit(enemy: TSEnemy, scene: STGScene) {
        penetrate-=1
        enemy.hp-=damage
    }
    
    var penetrate: Int
    var damage: Double
    
    init(type: Int, penetrate: Int, damage: Double){
        self.penetrate=penetrate
        self.damage=damage
        super.init(type: type, duration: 0)
        self.hitbox*=3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
