//
//  STGScene.swift
//  TestSTG4 macOS
//
//  Created by Wenqing Ge on 2021/3/17.
//

import Foundation
import SpriteKit
import JavaScriptCore



class STGScene: SKScene{
    
    var bgp: TSBackground = TSBackground()
    var scriptPath: String = ""
    var system: TSSystem = TSSystem()
    
    var layer:[SKNode]=[SKNode(),SKNode(),SKNode(),SKNode(),SKNode(),SKNode()]
    var bullets:[TSBullet?]=[]
    var disposed:[Int]=[]
    
    var jsc=JSContext()
    
    func setName(name: String){
        print("Hello World")
    }
    
    func loadScript(script: String){
        print("Loading script:\(script)")
        if let jsfile=Bundle.main.url(forResource: script, withExtension: "js"){
            do{
                let content=try String(contentsOf: jsfile)
                
                jsc?.evaluateScript(content, withSourceURL: jsfile)
                
            }catch{
               fatalError("The script cannot be loaded properly")
            }
        }else{
            fatalError("The script cannot be found")
        }
    }
    
    /**
     Must be called to set parameters
     */
    func initSTGScene(painter: TSBackground, script: [String], system: TSSystem){
        bgp=painter
        bgp.onInit(scene: self)
        
        //Init script
        print("Initalizing Script")
        scriptPath=script.last!
        regAll(to: jsc)
        
        jsc?.exceptionHandler={ context, exception in
            fatalError("Javascript error: "+(exception?.toString())!)
        }
        
        let fun=jsc?.objectForKeyedSubscript("onInit")
        let ret=fun?.call(withArguments: [self])
        
        print("Return as: \(ret!)")
        print("JavascriptCore loaded successfully")
        
        //Init system
        self.system=system
        self.system.onInit(scene: self)
        
        bullets=Array(repeating: nil, count: BULLETMAX)
        for i in 0..<BULLETMAX{
            disposed.append(i)
        }
    }

    override func didMove(to view: SKView) {
        for i in 0..<LAYERCNT{
            addChild(layer[i])
        }
    }
    
    func updateLayer(_ layer: SKNode){
        for i in layer.children{
            let obj=i as! TSObject
            obj.update()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //update ui components
        bgp.onUpdate()
        
        //update objects
        for i in 0..<LAYERCNT{
            updateLayer(layer[i])
        }
        
        //run script
        let fun=jsc?.objectForKeyedSubscript("update")
        fun?.call(withArguments: nil)
        
        //update system
        system.onUpdate()
        
    }
}
