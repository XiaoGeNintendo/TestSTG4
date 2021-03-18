//
//  CommonScript.swift
//  TestSTG4 iOS
//
//  Created by Wenqing Ge on 2021/3/18.
//

import Foundation
import JavaScriptCore

let pt: @convention(block) (String) -> Void = { msg in
    print("JS:"+msg)
}

let err: @convention(block) (String) -> Void = { msg in
    fatalError("JS Error: \(msg)")
}
