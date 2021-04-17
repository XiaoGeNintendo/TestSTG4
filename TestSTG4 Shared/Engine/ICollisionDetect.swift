//
//  IPlayerCollisionDetect.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/4/17.
//

import Foundation

/**
 To check if it should collide with a bullet
 */
protocol IPlayerCollisionDetect{
    func onHit(bullet: TSBullet, scene: STGScene)
    func onHit(enemy: TSEnemy, scene: STGScene)
    func collide(enemy: TSEnemy, scene: STGScene) -> Bool
    func collide(bullet: TSBullet, scene: STGScene) -> Bool
}

protocol IPlayerGrazeCollisionDetect{
    func onGraze(bullet: TSBullet, scene: STGScene)
    func graze(bullet: TSBullet, scene: STGScene) -> Bool
}

protocol IPlayerShotCollisionDetect{
    func hit(enemy: TSEnemy, scene: STGScene) -> Bool
    func onHit(enemy: TSEnemy, scene: STGScene)
}
