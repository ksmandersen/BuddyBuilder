//
//  Player.swift
//  BuddyBuilderMac
//
//  Created by Kristian Andersen on 25/11/14.
//  Copyright (c) 2014 Robocat. All rights reserved.
//

import Foundation
import SpriteKit

enum PlayerType {
    case Player1
    case Player2
}

enum MoveDirection {
    case Up
    case Down
    case Left
    case Right
}

class Player: SKSpriteNode {
    private let movementSpeed: CGFloat = 200.0
    
    var playerType: PlayerType = .Player1
    
    var shouldSlash = false
    var shouldMove = false
    var nextMove = MoveDirection.Up
    
    lazy var walkAction: SKAction = {
        let textures = (1...8).map { SKTexture(imageNamed: "doctor_walk_\($0)") }
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.1)
        
        return SKAction.repeatActionForever(animation)
    }()
    let walkActionKey = "player.walk"
    
    lazy var slashAction: SKAction = {
        let texture = (1...8).map { SKTexture(imageNamed: "doctor_slash_\($0)") }
        let animation = SKAction.animateWithTextures(texture, timePerFrame: 0.05)
        
        let sound = SKAction.playSoundFileNamed("swing.mp3", waitForCompletion: false)
        let delayedSound = SKAction.sequence([SKAction.waitForDuration(0.1), sound])
        
        return SKAction.group([delayedSound, animation])
    }()
    let slashActionKey = "player.slash"
    
    let initialTexture = SKTexture(imageNamed: "doctor_walk_1")
    
    convenience init(name: String, type: PlayerType) {
        let color = NSColor.clearColor()
        let size = CGSizeMake(76, 76)
        self.init(texture: SKTexture(imageNamed: "doctor_walk_1"), color: color, size: size)
        
        self.playerType = type
        
        configurePhysics()
    }
    
    override init(texture: SKTexture!, color: NSColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePhysics() {
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody!.affectedByGravity = false
        physicsBody!.dynamic = true
    }
    
    func move(direction: MoveDirection, withTimeInterval timeInterval: NSTimeInterval) {
        var action: SKAction?
        
        let moveBy = movementSpeed * CGFloat(timeInterval)
        switch direction {
        case .Up:
            action = SKAction.moveByX(0, y: moveBy, duration: timeInterval)
        case .Down:
            action = SKAction.moveByX(0, y: -moveBy, duration: timeInterval)
        case .Left:
            action = SKAction.moveByX(-moveBy, y: 0, duration: timeInterval)
        case .Right:
            action = SKAction.moveByX(moveBy, y: 0, duration: timeInterval)
        }
        
        if let action = action {
            rotate(direction)
            runAction(action)
        }
    }
    
    func rotate(direction: MoveDirection) {
        switch direction {
        case .Up:
            zRotation = 0
        case .Down:
            zRotation = CGFloat(M_PI)
        case .Left:
            zRotation = CGFloat(M_PI_2)
        case .Right:
            zRotation = CGFloat(-M_PI_2)
        }
    }
}
