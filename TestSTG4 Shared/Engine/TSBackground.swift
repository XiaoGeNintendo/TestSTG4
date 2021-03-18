//
//  TSBackground.swift
//  TestSTG4 macOS
//
//  Created by Wenqing Ge on 2021/3/17.
//

import Foundation

/**
 A class to create backgrounds. Implement `onInit` `onUpdate` and `onRemove`
 */
class TSBackground{
    var scene: STGScene? = nil
    init(){
        
    }
    
    func onInit(scene: STGScene){
        self.scene=scene
    }
    
    func onUpdate(){
        
    }
    
    func onRemove(){
    
    }
}
