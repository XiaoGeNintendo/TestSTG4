//
//  StartScene.swift
//  TestSTG4 iOS
//
//  Created by Wenqing Ge on 2021/3/31.
//

import Foundation
import SpriteKit

class StartScene: SKScene{
    
    var btn: SEButton=SEButton(text: "Game Start"){
        
    }
    
    var title=SKLabelNode(text: "Test STG 4")
    var sub=SKLabelNode(text:"XGN from Hell Hole Studios 2021")
    override func didMove(to view: SKView) {
        title.position=CGPoint(x: WIDTH/2, y: HEIGHT/3*2)
        title.alpha=0
        title.run(SKAction.fadeIn(withDuration: 1))
        addChild(title)
        
        sub.position=CGPoint(x: WIDTH/2, y: 0)
        sub.alpha=0
        sub.fontSize=12
        sub.run(SKAction.fadeIn(withDuration: 1))
        addChild(sub)
        
        btn.f={
            let sc=StageSelectScene()
            sc.size=CGSize(width: WIDTH, height: HEIGHT)
            sc.scaleMode = .aspectFill
            view.presentScene(sc, transition: SKTransition.flipHorizontal(withDuration: 1))
        }
        btn.alpha=0
        btn.position=CGPoint(x: WIDTH/2, y: HEIGHT/2)
        btn.run(SKAction.fadeIn(withDuration: 1))
        addChild(btn)
    }
    
    
}
