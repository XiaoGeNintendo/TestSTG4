//
//  TSObject.swift
//  TestSTG4 macOS
//
//  Created by Wenqing Ge on 2021/3/17.
//

import Foundation
import SpriteKit

/**
 Represent an object in the frame
 */
class TSObject: SKNode{
    
    var x:Double=0,y:Double=0
    var vx:Double=0,vy:Double=0
    var ax:Double=0,ay:Double=0
    
    var id: Int = -1
    var alive = true
    
    func setPos(x: Double, y: Double){
        self.x=x
        self.y=y
        
    }
    /**
     Be called each frame to update the properities of the object
     */
    func update(){
        vx+=ax
        vy+=ay
        
        x+=vx
        y+=vy
        
        self.position=CGPoint(x: x,y: y)
    }
    
    func isOOB() -> Bool{
        let VALUE:Double=100
        return x >= Double(WIDTH) + VALUE || x <= -VALUE || y >= Double(HEIGHT) + VALUE || y <= -VALUE
    }
}
