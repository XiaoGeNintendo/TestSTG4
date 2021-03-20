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
    var stack:[String]=[]
    
    func setName(name: String){
        print("Hello World")
    }
    
    func loadScript(script: String){
        print("Loading script:\(script)")
        if let jsfile=Bundle.main.url(forResource: script, withExtension: "js"){
            do{
                var content=try String(contentsOf: jsfile)
                
                //replace essential macro
                let uuid=UUID().uuidString
                content=replaceMacro(content,uuid)
                pushScriptStack(id: uuid)
                
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
    
    func getBullet(id: Int) -> TSBullet{
        return bullets[id]!
    }
    
    func removeBullet(id: Int){
        disposed.append(id)
    }
    
    func pushScriptStack(id: String){
        stack.append(id.replacingOccurrences(of: "-", with: "_"))
        print("Pushed script stack:\(id)")
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
        loadScript(script: "global")
        for i in script{
            loadScript(script: i)
        }
        
        jsc?.exceptionHandler={ context, exception in
            fatalError("Javascript error: "+(exception?.toString())!)
        }
        
        let fun=jsc?.objectForKeyedSubscript("onInit_\(stack.last!)")
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
        let fun=jsc?.objectForKeyedSubscript("poolUpdate")
        fun?.call(withArguments: nil)
        
        let fun2=jsc?.objectForKeyedSubscript("update_\(stack.last!)")
        fun2?.call(withArguments: nil)
        
        //garbage collect
        for i in layer[LAYER_BUL].children{
            let bullet=i as! TSBullet
            if bullet.isOOB() && bullet.autoFree{
                bullet.delete()
            }
        }
        
        //update system
        system.onUpdate()
        
//        if layer[LAYER_BUL].children.count>=1000{
//            print(layer[LAYER_BUL].children.count)
//        }
    }
}
