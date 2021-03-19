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
     Add a bullet to the bullet pool
     */
    func addBullet(bullet: TSBullet){
        if disposed.isEmpty{
            print("Too many bullets!! Will not add a new one")
            return
        }
        
        bullet.id=disposed.first!
        bullets[disposed.first!]=bullet
        layer[LAYER_BUL].addChild(bullet)
        disposed.removeFirst()
    }
    
    /**
     Must be called to set parameters
     */
    func initSTGScene(painter: TSBackground, script: [String], system: TSSystem){
        //Set Current Active Scene
        boss=self
        
        //Load background
        bgp=painter
        bgp.onInit(scene: self)
        
        //Load shotsheet
        cacheTexture()
        
        //Init script
        print("Initalizing Script")
        scriptPath=script.last!
        regAll(to: jsc)
        
        for i in script{
            loadScript(script: i)
        }
        
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
        print("Presenting Layers")
        for i in 0..<LAYERCNT{
            addChild(layer[i])
        }
        
//        addChild(SKLabelNode(text: "asd"))
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
        
        for i in layer[LAYER_BUL].children{
//            print(i)
        }
    }
}
