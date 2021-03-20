//
//  MacView.swift
//  TestSTG4 macOS
//
//  Created by Wenqing Ge on 2021/3/17.
//

import SwiftUI
import SpriteKit

struct MacView: View {
    
    var game: SKScene {
        let scene = STGScene()
        scene.initSTGScene(painter: TSBackground(), script: ["test2","testScript"], system: TSSystem(), player: TSPlayer())
        scene.size = CGSize(width: WIDTH, height: HEIGHT)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: game).frame(width: WIDTH, height: HEIGHT)
    }
}

