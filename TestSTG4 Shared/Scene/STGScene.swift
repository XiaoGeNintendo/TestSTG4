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
    
    var player = TSPlayer()
    
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
    func initSTGScene(painter: TSBackground, script: [String], system: TSSystem, player: TSPlayer){
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
        
        //Init bullet
        bullets=Array(repeating: nil, count: BULLETMAX)
        for i in 0..<BULLETMAX{
            disposed.append(i)
        }
        
        //Init player
        self.player=player
        self.player.x=Double(WIDTH)/2
        self.player.y=Double(HEIGHT)/4
        layer[LAYER_PL].addChild(self.player)
        
        //Init system
        self.system=system
        self.system.onInit(scene: self)
        
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
    
    func update(){
        
        //update ui components
        bgp.onUpdate()
        
        //update objects
        for i in 0..<LAYERCNT{
            updateLayer(layer[i])
        }
        
        //update keys
        #if os(macOS)
        updateKey()
        #endif
        
        //run script
        let fun=jsc?.objectForKeyedSubscript("poolUpdate")
        fun?.call(withArguments: nil)
        
        let fun2=jsc?.objectForKeyedSubscript("update_\(stack.last!)")
        fun2?.call(withArguments: nil)
        
        //garbage collect
        for i in layer[LAYER_BUL].children{
            let bullet=i as! TSBullet
            if bullet.isOOB() && bullet.autoFree && bullet.alive{
                bullet.delete()
            }
        }
        
        //collision detect
        for i in layer[LAYER_BUL].children{
            let bullet=i as! TSBullet
            if bullet.alive && player.invFrame==0 && player.deathbombWindow==0 && player.collide(bullet: bullet){
                system.onHit(bullet: bullet)
            }else if bullet.grazeCount>0 && player.deathbombWindow==0 && player.graze(bullet: bullet){
                bullet.grazeCount-=1
                system.onGraze(bullet: bullet)
            }
        }
        
        //update system
        system.onUpdate()
    }
    
    override func update(_ currentTime: TimeInterval) {
        update()
        
        #if os(macOS)
        if key[S] ?? false{
            update()
            update()
            update()
        }
        #endif
    }
    
    #if os(iOS)
    //touches detection. iOS only
    var touchPosition = CGPoint.zero
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return //Touch unavailable
        }
        
        let loc=touch.location(in: self)
        
        touchPosition=loc
        if player.deathbombWindow==0{
            player.x+=Double(loc.x-touchPosition.x)
            player.y+=Double(loc.y-touchPosition.y)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else{
            return //Touch unavailable
        }
        
        touchPosition = touch.location(in: self)
    }
    #else
    
    var touchPosition = CGPoint.zero
    
    override func mouseDragged(with event: NSEvent) {
        let loc=event.location(in: self)
        
        if player.deathbombWindow==0{
            player.x+=Double(loc.x-touchPosition.x)
            player.y+=Double(loc.y-touchPosition.y)
        }
//        player.x=Double(loc.x)
//        player.y=Double(loc.y)
        
        touchPosition=loc
    }
    
    override func mouseDown(with event: NSEvent) {
        let loc=event.location(in: self)
        
//        player.x=Double(loc.x)
//        player.y=Double(loc.y)
        
        touchPosition=loc
    }

    //key check
    var key:[Int:Bool]=[:]
    
    let SHIFT = -1
    let UP = 126
    let LEFT = 123
    let RIGHT = 124
    let DOWN = 125
    let Z = 6
    let X = 7
    let C = 8
    let ESC = 53
    let R = 15
    let S = 1
    
    override func keyUp(with event: NSEvent) {
        key[Int(event.keyCode)]=false
    }
    
    override func keyDown(with event: NSEvent) {
        key[Int(event.keyCode)]=true
        
        if event.keyCode==X{
            system.onBomb()
        }
    }
    
    
    func updateKey(){
        let speed = key[Z] ?? false ? player.moveSpeed/2 : player.moveSpeed
        
        if player.deathbombWindow == 0{
            if key[UP] ?? false{
                player.y+=speed
            }
            if key[DOWN] ?? false{
                player.y-=speed
            }
            if key[LEFT] ?? false{
                player.x-=speed
            }
            if key[RIGHT] ?? false{
                player.x+=speed
            }
        }
        
    }
    #endif
    
}
