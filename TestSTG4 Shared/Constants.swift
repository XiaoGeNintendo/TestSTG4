//
//  Constants.swift
//  TestSTG4 macOS
//
//  Created by Wenqing Ge on 2021/3/17.
//

import Foundation

let WIDTH:CGFloat = 380, HEIGHT:CGFloat = 450

let BULLETMAX = 65536

let LAYERCNT = 6

let LAYERNAME = ["Background","Object","Player","Enemy","Bullet","UI"]

let LAYER_BG=0
let LAYER_OBJ=1
let LAYER_PL=2
let LAYER_ENE=3
let LAYER_BUL=4
let LAYER_UI=5

var boss:STGScene? = nil
