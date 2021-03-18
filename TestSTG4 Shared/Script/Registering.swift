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
}
