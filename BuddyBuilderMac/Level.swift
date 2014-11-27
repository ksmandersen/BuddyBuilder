//
//  Level.swift
//  BuddyBuilderMac
//
//  Created by Kristian Andersen on 26/11/14.
//  Copyright (c) 2014 Robocat. All rights reserved.
//

import Foundation
import SpriteKit
let layout1: [(type: ObstacleType, position: CGPoint, angle: Double)] = [
    (type: .Sofa, position: CGPoint(x: 40, y: 320), angle: M_PI),
    (type: .Table, position: CGPoint(x: 150, y: 325), angle: 0),
    (type: .Plant, position: CGPoint(x: 200, y: 460), angle: 0),
    (type: .Plant, position: CGPoint(x: 430, y: 40), angle: 0),
    (type: .Desk, position: CGPoint(x: 430, y: 120), angle: 0),
    (type: .Plant, position: CGPoint(x: 430, y: 250), angle: 0),
    (type: .Stool, position: CGPoint(x: 440, y: 580), angle: 0),
    (type: .BloodyTable, position: CGPoint(x: 350, y: 630), angle: 0)
] 

class Level: SKSpriteNode {
    var player: Player!
    
    let maxNumberOfPatients = 10
    var patients: [Patient] = []
    
    convenience init(player: Player) {
        var floor: String
        switch player.playerType {
        case .Player1: floor = "floor_player1"
        case .Player2: floor = "floor_player2"
        }
        
        let color = NSColor.redColor()
        let texture = SKTexture(imageNamed: floor)
        let size = texture.size()        
        
        self.init(texture: texture, color: color, size: size)
        
        self.player = player
        self.zPosition = 1
        
        configureObstacles()
        configurePlayer()
        configureWall()
    }
    
    func configureWall() {
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = false
    }
    
    func configurePlayer() {
        player.position = CGPointMake((frame.size.width - player.size.width) / 2, (frame.size.height - player.size.height) / 2)
        player.zPosition = 3
        addChild(player)
    }
    
    override init(texture: SKTexture!, color: NSColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePhysics() {
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = false
    }
    
    func configureObstacles() {
        for obstacle in layout1 {
            let node = Obstacle(type: obstacle.type)
            let x = -(anchorPoint.x * size.width) + obstacle.position.x
            let y = -(anchorPoint.y * size.height) + obstacle.position.y
            node.position = CGPoint(x: x, y: y)
            node.zRotation = CGFloat(obstacle.angle)
            node.zPosition = 2
            
            addChild(node)
        }
    }
    
    func spawnPatients() {
        if patients.count <= maxNumberOfPatients {
            if (Float(arc4random()) / Float(UINT32_MAX)) < 0.01 {
                addPatient()
            }
        }
    }
    
    func addPatient() {
        let patient = Patient(level: self)
        
        var x = CGFloat(randomRange(400, min: 80))
        var y = CGFloat(randomRange(700, min: 80))
        
        // Check if position collides with obstacle
        
        patient.position = CGPoint(x: x, y: y)
        patient.zRotation = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        patient.moveRandom(0.6)
        
        addChild(patient)
        patients.append(patient)
    }
    
    private func randomRange(max: Int, min: Int) -> Float {
        return floorf(Float(arc4random()) / Float(UINT32_MAX) * (Float(max) - Float(min))) + Float(min)
    }
}
