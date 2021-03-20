//
//  ShotsheetConstant.swift
//  TestSTG4
//
//  Created by Wenqing Ge on 2021/3/19.
//

import Foundation
import SpriteKit

func cacheTexture(){
    if textureCache.count>1{
        print("Already cached texture")
        return
    }
    
    print("Loading Texture...")
    
    if let file=Bundle.main.url(forResource: "sheet", withExtension: "shot"){
        do{
            let str=try String(contentsOf: file)
            
            let lines=str.split(separator: "\n")
            
            for i in lines{
                let vars=i.split(separator: ",")
                shotName.append(String(vars[0]))
                sheet.append([Int(vars[1])!,Int(vars[2])!,Int(vars[3])!,Int(vars[4])!])
                print("Loaded:\(vars[0])")
            }
        }catch{
            fatalError("Cannot load sheet.shot file!")
        }
    }else{
        fatalError("Cannot load sheet.shot file!")
    }
    print("Caching Texture...")
    for i in shotName{
        let sub=SKTexture(imageNamed: i)
        textureCache.append(sub)
    }
}

let SS_X=0
let SS_Y=1
let SS_SX=2
let SS_SY=3
var shotName:[String]=[]
var sheet=[
    [0,0,0,0]
]

var textureCache: [SKTexture]=[
    SKTexture(),
]
