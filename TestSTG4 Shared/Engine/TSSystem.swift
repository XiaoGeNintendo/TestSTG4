//
//  TSSystem.swift
//  TestSTG4 macOS
//
//  Created by Wenqing Ge on 2021/3/17.
//

import Foundation

/**
 System script to handle events and on board drawing
 
 Implement `onInit` `onUpdate` plz
 */

class TSSystem{
    var scene: STGScene? = nil
    init(){
    }
    
    func onInit(scene: STGScene){
        self.scene=scene
    }
    
    func onUpdate(){
        
    }
}
