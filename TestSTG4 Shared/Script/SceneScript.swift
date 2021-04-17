//
//  SceneScript.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/3/20.
//

import Foundation

let INF:Double = 1e9

let GetWidth: @convention(block) () -> Double = {
    return Double(WIDTH)
}


let GetHeight: @convention(block) () -> Double = {
    return Double(HEIGHT)
}

let GetX: @convention(block) (Int) -> Double = { id in
    return boss?.objects[id]?.x ?? -INF
}

let GetY: @convention(block) (Int) -> Double = { id in
    return boss?.objects[id]?.y ?? -INF
}

let SetRawSpeed: @convention(block) (Int,Double,Double) -> Void = { id,x,y in
    boss?.objects[id]?.vx=x
    boss?.objects[id]?.vy=y
}

let SetRawAcc: @convention(block) (Int,Double,Double) -> Void = { id,x,y in
    boss?.objects[id]?.ax=x
    boss?.objects[id]?.ay=y
}

let isAlive: @convention(block) (Int) -> Bool = { id in
//    print("\(id) \(boss?.objects[id]!)")
    return boss?.objects[id]?.alive ?? false
}
