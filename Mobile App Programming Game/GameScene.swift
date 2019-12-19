//
//  GameScene.swift
//  Mobile App Programming Game
//
//  Created by Khan, Rayan A on 12/3/19.
//  Copyright © 2019 Khan, Rayan A. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let monster   : UInt32 = 0b1
    static let projectile: UInt32 = 0b10
}


func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "test")
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.blue
        player.position = CGPoint(x: size.width * -0.2, y: size.height * 0.1)
        addChild(player)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.linearDamping = 1.1
        player.physicsBody?.restitution = 0
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = true
        
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(spawnBlackHole),
            
            SKAction.wait(forDuration: 2.0)
            ])))
        
        
    }
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
    }
    
    
    /*func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }*/
    
    /*func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func rng() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func rng(min: CGFloat, max: CGFloat) -> CGFloat
    {
        return rng() * (max - min) + min
    }
    
    func spawnBlackHole()
    {
        let blackhole = SKSpriteNode(imageNamed: "vortex")
        blackhole.size = CGSize(width: blackhole.size.width, height: blackhole.size.height)
        blackhole.position = CGPoint(x: size.width * 0.9, y: rng(min: size.height * -0.5, max: size.height * 0.5))
        
        let speed = 2.0
        
        let moveAction = SKAction.move(by: CGVector(dx: size.width * -2.5,  dy: 0), duration: TimeInterval(speed))
        let dieAction = SKAction.removeFromParent()
        
        
        
        addChild(blackhole)
        
        blackhole.run(SKAction.sequence([moveAction, dieAction]))
    }
    
    func playSFX(filename: String)
    {
        guard (Bundle.main.path(forResource: filename.lowercased(), ofType: "wav") != nil) else
        {
            print("Error playing sound \"\(filename.lowercased()).wav\".")
            return;
        }
        run(SKAction.playSoundFileNamed(filename.lowercased()+".wav", waitForCompletion: false))
    }
}
