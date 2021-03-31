//
//  SEButton.swift
//  TestSTG4 iOS
//
//  Created by Wenqing Ge on 2021/3/31.
//

import Foundation
import SpriteKit

/**
 A button with labels
 */
class SEButton: SKLabelNode{
    
    var f: () -> Void
    
    init(text: String, f: @escaping () -> Void){
        self.f=f
        super.init()
        self.text=text
        isUserInteractionEnabled=true
    }
    
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        f()
    }
    #endif
    
    #if os(macOS)
    override func mouseDown(with event: NSEvent) {
        f()
    }
    
    #endif
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
