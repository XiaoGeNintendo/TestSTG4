//
//  StageSelectScene.swift
//  TestSTG4 iOS
//
//  Created by Wenqing Ge on 2021/3/31.
//

import Foundation
import SpriteKit

let stages=[
    ["Test Script","testScript","This is a test script"],
    ["Test Script 2","testScript","This is the same script"]
]

class StageSelectScene: SKScene{
    var lbl = SKLabelNode(text: "Scene Select")
    var desc = SKLabelNode(text: "Press/Click Arrow Keys to select a scene")
    var play = SEButton(text: "Play Scene", f: {
    })
    
    var l = SEButton(text: "<"){
    }
    
    var r = SEButton(text: ">"){
    }
    
    var now = 0
    
    func notify(){
        lbl.text=stages[now][0]
        desc.text=stages[now][2]
    }
    
    override func didMove(to view: SKView) {
        lbl.position=CGPoint(x: WIDTH/2, y: HEIGHT/5*4)
        addChild(lbl)
        
        desc.position=CGPoint(x: WIDTH/2, y: HEIGHT/10*7)
        desc.fontSize=12
        addChild(desc)
        
        play.position=CGPoint(x: WIDTH/2, y: HEIGHT/5)
        play.f={
            let sc=STGScene()
            sc.initSTGScene(painter: TSBackground(), script: [stages[self.now][1]], system: DemoSystem(), player: TSPlayer())
            sc.size = CGSize(width: WIDTH, height: HEIGHT)
            sc.scaleMode = .aspectFill
            
            view.showsFPS=true
            view.presentScene(sc,transition: SKTransition.doorsOpenVertical(withDuration: 1))
        }
        addChild(play)
        
        l.position=CGPoint(x: WIDTH/5, y: HEIGHT/5)
        l.f={
            self.now=(self.now+stages.count-1)%stages.count
            self.notify()
        }
        addChild(l)
        
        r.f={
            self.now=(self.now+1)%stages.count
            self.notify()
        }
        r.position=CGPoint(x: WIDTH/5*4, y: HEIGHT/5)
        addChild(r)
        
    }
}
