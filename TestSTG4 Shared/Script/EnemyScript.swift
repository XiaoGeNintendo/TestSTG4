//
//  EnemyScript.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/4/17.
//

import Foundation

//let pool = Bullet2Pool()

let CreateEnemy: @convention(block) (Int,Double,Double,Double,Double,Double) -> Int = { type,x,y,a,b,c in
    let bullet=TSEnemy(hp: a, playerHitbox: b, bulletHitbox: c)
    bullet.x=x
    bullet.y=y
    
    boss?.addObj(obj: bullet, to: LAYER_ENE)
    return bullet.id
}
