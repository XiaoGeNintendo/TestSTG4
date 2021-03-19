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
    let texture=SKTexture(imageNamed: "default_shot.png")
    for i in sheet{
        
        let SZ:CGFloat=512
        var x1:CGFloat=CGFloat(i[0])/SZ
        var y1:CGFloat=1-CGFloat(i[1])/SZ
        var w1:CGFloat=CGFloat(i[2])/SZ
        var h1:CGFloat=CGFloat(i[3])/SZ
        
        let sub=SKTexture(rect: CGRect(x: x1, y: y1, width: w1, height: h1), in: texture)
        textureCache.append(sub)
    }
}

let SS_X=0
let SS_Y=1
let SS_SX=2
let SS_SY=3
var sheet=[
    [0,0,0,0],
]

var textureCache: [SKTexture]=[
    SKTexture(),
]
