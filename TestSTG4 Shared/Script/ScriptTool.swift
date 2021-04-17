//
//  ScriptTool.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/3/20.
//

import Foundation

func replaceMacro(_ str: String, _ uuid: String) -> String{
    let nid=uuid.replacingOccurrences(of: "-", with: "_")
    var nstr=str.replacingOccurrences(of: "@update", with: "function update_\(nid)()")
    nstr=nstr.replacingOccurrences(of: "@init", with: "function onInit_\(nid)(scene)")
    nstr=nstr.replacingOccurrences(of: "@id", with: "\(nid)")
    
    //macro
    
    return nstr
}
