//
//  Patient.swift
//  BuddyBuilderMac
//
//  Created by Kristian Andersen on 27/11/14.
//  Copyright (c) 2014 Robocat. All rights reserved.
//

import Foundation
import SpriteKit

enum PatientState {
    case Walking
    case Running
    case Standing
    
    var movementSpeed: CGFloat {
        switch self {
        case .Running: return 250
        case .Walking: return 125
        case .Standing: return 0
        }
    }
}

private let initialTexture = SKTexture(imageNamed: "patient_walk_1")

class Patient: SKSpriteNode {
    weak var level: Level?
    
    lazy var walkAction: SKAction = {
        let textures = (1...6).map { SKTexture(imageNamed: "patient_walk_\($0)") }
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.1)
        
        return SKAction.repeatActionForever(animation)
    }()
    let walkActionKey = "patient.walk"
    
    lazy var runningAction: SKAction = {
        let textures = (1...4).map { SKTexture(imageNamed: "patient_run_\($0)") }
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.08)
        
        return SKAction.repeatActionForever(animation)
        }()
    let runningActionKey = "patient.run"
    
    var state = PatientState.Standing
    
    convenience init(level: Level) {
        let color = NSColor.clearColor()
        self.init(texture: initialTexture, color: color, size: initialTexture.size())
        
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
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
    }
    
    func moveRandom(timeInterval: NSTimeInterval) {
        let action = SKAction.moveTo(nextRandomPoint(), duration: timeInterval)
//        let withAnimation = SKAction.group([action, walkAction])
        
        runAction(action) {
            self.moveRandom(timeInterval)
        }
    }
    
    func nextRandomPoint() -> CGPoint {
        return CGPoint(x: Int(CGRectGetMinX(frame)) + Int(arc4random()) % Int(CGRectGetWidth(frame)), y: Int(CGRectGetMinY(frame)) + Int(arc4random()) % Int(CGRectGetHeight(frame)))
    }
}
