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
    var objects:[TSObject?]=[]
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
    
    func addObj(obj: TSObject, to: Int){
        if disposed.isEmpty{
            print("Too many objects!! Will not add a new one")
            return
        }
        
        obj.id=disposed.first!
        objects[disposed.first!]=obj
        layer[to].addChild(obj)
        disposed.removeFirst()
    }
    
    /**
     Add a bullet to the bullet pool
     */
    func addBullet(bullet: TSBullet){
        addObj(obj: bullet, to: LAYER_BUL)
    }
    
    /**
     Add a playershot to the bullet pool
     */
    func addShot(bullet: TSPlayerShot){
        addObj(obj: bullet, to: LAYER_PL)
    }
    
    /**
     Force return a bullet. If not a bullet, will crash happily :)
     */
    func getBullet(id: Int) -> TSBullet{
        return objects[id] as! TSBullet
    }
    
    func removeObject(id: Int){
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
        objects=Array(repeating: nil, count: BULLETMAX)
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
        
        let watch=StopWatch(no: true)
        let w2=StopWatch(no: true)
        
        //update ui components
        bgp.onUpdate()
        
        watch.tap("UI Update")
        
        //update objects
        for i in 0..<LAYERCNT{
            updateLayer(layer[i])
        }
        
        watch.tap("Layer update")
        
        //update keys
        #if os(macOS)
        updateKey()
        #endif
        
        watch.tap("Key update")
        
        //run script
        let fun=jsc?.objectForKeyedSubscript("poolUpdate")
        fun?.call(withArguments: nil)
        
        let fun2=jsc?.objectForKeyedSubscript("update_\(stack.last!)")
        fun2?.call(withArguments: nil)
        
        watch.tap("Script Handling")
        //garbage collect
        for i in layer[LAYER_BUL].children{
            let bullet=i as! TSBullet
            if bullet.isOOB() && bullet.autoFree && bullet.alive{
                bullet.delete()
            }
        }
        
        for i in layer[LAYER_ENE].children{
            let enemy=i as! TSEnemy
            if enemy.alive{
                if enemy.hp<=0.5 || enemy.isOOB() && enemy.autoFree{
                    enemy.delete()
                }
            }
        }
        
        for i in layer[LAYER_PL].children{
            if let bullet=i as? TSPlayerShot{
                if bullet.alive && (bullet.isOOB() || bullet.penetrate==0){
                    bullet.delete()
                }
            }
        }
        
        watch.tap("Garbage Collect")
        //collision detect - bullet
        for i in 0..<LAYERCNT{
            if i == LAYER_BUL{
                continue
            }
            for j in layer[i].children{
                if let collider = j as? IPlayerCollisionDetect{
                    for k in layer[LAYER_BUL].children{
                        let bullet=k as! TSBullet
                        if bullet.alive && collider.collide(bullet: bullet, scene: self){
                            collider.onHit(bullet: bullet, scene: self)
                        }
                    }
                }
                if let collider = j as? IPlayerGrazeCollisionDetect{
                    for k in layer[LAYER_BUL].children{
                        let bullet=k as! TSBullet
                        if bullet.alive && bullet.grazeCount>0 && collider.graze(bullet: bullet, scene: self){
                            bullet.grazeCount-=1
                            collider.onGraze(bullet: bullet, scene: self)
                        }
                    }
                }
            }
        }
        
        //collision detect - enemy
        for i in 0..<LAYERCNT{
            if i==LAYER_BUL {
                continue
            }
            for j in layer[i].children{
                if let collider = j as? IPlayerShotCollisionDetect{
                    for k in layer[LAYER_ENE].children{
                        let enemy=k as! TSEnemy
                        if enemy.hp>0 && enemy.alive && collider.hit(enemy: enemy, scene: self){
                            collider.onHit(enemy: enemy, scene: self)
                        }
                    }
                }
            }
        }
        
        watch.tap("Collision")
        //update system
        system.onUpdate()
        
        //always shot
        if player.deathbombWindow==0{
            system.onShoot()
        }
        watch.tap("System")
        
        w2.tap("==========================")
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
