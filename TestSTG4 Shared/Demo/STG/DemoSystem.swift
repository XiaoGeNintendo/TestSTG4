//
//  DemoSystem.swift
//  TestSTG4 iOS
//
//  Created by Wenqing Ge on 2021/3/31.
//

import Foundation
import SpriteKit

class DemoSystem: TSSystem{
    
    var graze = 0
    var life = 3
    var bomb = 2
    var value = 1000
    var score = 0
    
    var pl : TSPlayer = TSPlayer()
    
    var scoreLabel = TSLabel(text: "Score 0")
    var grazeLabel = TSLabel(text: "Graze 0")
    var bulletLabel = TSLabel(text: "Bullet 0")
    func setup(_ scoreLabel: TSLabel,_ down: Double){
        scoreLabel.lbl.horizontalAlignmentMode = .left
        scoreLabel.lbl.verticalAlignmentMode = .top
        scoreLabel.setPos(x: 0, y: Double(HEIGHT)-down)
        scoreLabel.lbl.fontSize=20
        scene?.layer[LAYER_UI].addChild(scoreLabel)
    }
    
    override func onInit(scene: STGScene) {
        super.onInit(scene: scene)
        pl=scene.player
        
        setup(scoreLabel, 0)
        setup(grazeLabel, 20)
        setup(bulletLabel, 40)
    }
    
    override func onUpdate() {
        scoreLabel.lbl.text="SCORE \(score)"
        grazeLabel.lbl.text="GRAZE \(graze)"
        bulletLabel.lbl.text="BULLET \(scene?.layer[LAYER_BUL].children.count ?? 0)"
    }
    
    override func onGraze(bullet: TSBullet) {
        graze+=1
        if graze%10==0{
            value += 10
        }
    }
    
    override func onHit(bullet: TSBullet) {
        print("hit")
        pl.deathbombWindow = 60
    }
    
    override func onBomb() {
        if bomb > 0{
            bomb -= 1
            
            if pl.deathbombWindow>0{
                pl.deathbombWindow = 0
            }
            
            pl.invFrame += 180
            
            for i in scene?.layer[LAYER_BUL].children ?? []{
                let x=i as! TSBullet
                x.delete()
            }
        }
    }
    
    override func onDeathbombWindowEnd() {
        life -= 1
        bomb = 3
        scene?.player.x=Double(WIDTH/2)
        scene?.player.y=Double(HEIGHT/5)
        scene?.player.invFrame = 300
    }
}
