//
//  ShotScript.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/3/19.
//

import Foundation

//let pool = Bullet2Pool()

let CreateShot: @convention(block) (Int,Double,Double,Double,Double) -> Int = { type,x,y,v,a in
//    let bullet=pool.new(type: type)
    let bullet = TSBullet2(type: type)
    bullet.v=v
    bullet.x=x
    bullet.y=y
    bullet.a=a
    
    boss!.addBullet(bullet: bullet)
    
    return bullet.id
}

let CreateShotXY: @convention(block) (Int,Double,Double,Double,Double) -> Int = { type,x,y,vx,vy in
    let bullet=TSBullet(type: type)
    bullet.vx=vx
    bullet.vy=vy
    bullet.x=x
    bullet.y=y
    
    boss!.addBullet(bullet: bullet)
    
    return bullet.id
}

let SetAcc: @convention(block) (Int,Double) -> Void = { id,ax in
    var bullet=boss?.getBullet(id: id) as! TSBullet2
    bullet.acc=ax
}

let SetOmega: @convention(block) (Int,Double) -> Void = { id,omega in
    var bullet=boss?.getBullet(id: id) as! TSBullet2
    bullet.omega=omega
}

let DeleteBullet: @convention(block) (Int) -> Void = { id in
    var bullet=boss?.getBullet(id: id)
    bullet?.delete()
}
