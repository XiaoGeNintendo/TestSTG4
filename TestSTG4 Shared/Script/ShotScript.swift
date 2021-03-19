//
//  ShotScript.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/3/19.
//

import Foundation


let CreateShot: @convention(block) (Int,Double,Double,Double,Double) -> Void = { type,x,y,v,a in
    let bullet=TSBullet2(type: type)
    bullet.v=v
    bullet.x=x
    bullet.y=y
    bullet.a=a
    
    boss!.addBullet(bullet: bullet)
}
