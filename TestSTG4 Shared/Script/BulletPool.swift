//
//  BulletPool.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/3/31.
//

import Foundation

class Bullet2Pool{
    var bullets: [TSBullet2] = []
    
    let COUNT = 65536
    var get = 0
    
    init(){
        for _ in 0..<COUNT{
            bullets.append(TSBullet2(type: 0))
        }
    }
    
    func new(type: Int) -> TSBullet2{
        let ret = bullets[get]
        ret.reset(type: type)
        get += 1
        if get == COUNT{
            get = 0
        }
        return ret
    }
}
