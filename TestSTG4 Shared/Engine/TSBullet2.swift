//
//  TSBullet2.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/3/19.
//

import Foundation

class TSBullet2: TSBullet{
    
    var v:Double=0
    var a:Double=0
    var omega:Double=0
    override init(type: Int){
        super.init(type: type)
    }
    
    override func update() {
        vx=v*cos(a/180*3.14)
        vy=v*sin(a/180*3.14)
        a+=omega
        display.zRotation=CGFloat(a/180*3.14)
        super.update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

