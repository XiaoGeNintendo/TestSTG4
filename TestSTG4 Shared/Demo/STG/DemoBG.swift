//
//  DemoBG.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/4/17.
//

import Foundation
import SpriteKit


class DemoBG: TSBackground{
    
    override func onInit(scene: STGScene) {
        super.onInit(scene: scene)
        
        let layer1 = TSSPrite(text: "bamboo")
        layer1.position=CGPoint(x: 0, y: 0)
        layer1.s.size=CGSize(width: WIDTH, height: HEIGHT)
        layer1.s.anchorPoint=CGPoint(x: 0, y: 0)
        
        let layer2 = TSSPrite(text: "pattern")
        layer2.alpha=0.2
        layer2.position=CGPoint(x: 0, y: 0)
        layer2.s.size=CGSize(width: 678*2, height: 480*2)
        
//        layer2.run(SKAction.repeatForever(
//            SKAction.sequence([
//                SKAction.move(by: CGVector(dx: 100, dy: 100), duration: 1),
//                SKAction.move(by: CGVector(dx: -100, dy: -100), duration: 1),
//            ])
//        ))
        
        layer2.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeAlpha(by: 0.5, duration: 1),
            SKAction.wait(forDuration: 1),
            SKAction.fadeAlpha(by: -0.5, duration: 1),
            SKAction.wait(forDuration: 1)
        ])));
        
        scene.layer[LAYER_BG].addChild(layer2)
        scene.layer[LAYER_BG].addChild(layer1)
        
    }
}
