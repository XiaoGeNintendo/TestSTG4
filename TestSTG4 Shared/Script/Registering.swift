//
//  ScriptRegister.swift
//  TestSTG4 iOS
//
//  Created by Wenqing Ge on 2021/3/18.
//

import Foundation
import JavaScriptCore

func reg<T>(f: T, name: String, to: JSContext?){
    print("Passed function:\(name)")
    let obj=unsafeBitCast(f, to: AnyObject.self)
    to?.setObject(obj, forKeyedSubscript: name as (NSCopying & NSObjectProtocol))
}

func regAll(to: JSContext?){
    reg(f: pt, name: "print", to: to)
    reg(f: err, name: "fatal", to: to)
    
    reg(f: CreateShot, name: "createShot", to: to)
    reg(f: CreateShotXY, name: "createShotXY", to: to)
    reg(f: SetAcc, name: "setAcc", to: to)
    reg(f: SetOmega,name: "setOmega", to:to)
    reg(f: DeleteBullet, name: "deleteBullet", to: to)
    
    reg(f: GetHeight, name: "getH", to: to)
    reg(f: GetWidth, name: "getW", to: to)
    reg(f: GetX, name: "getX", to: to)
    reg(f: GetY, name: "getY", to: to)
    reg(f: SetRawSpeed, name: "setRawSpeed", to: to)
    reg(f: SetRawAcc, name: "setRawAcc", to: to)
    reg(f: isAlive, name: "isAlive", to: to)
    
    reg(f: CreateEnemy, name: "createEnemy", to: to)
}
