//
//  Obstacle.swift
//  BuddyBuilderMac
//
//  Created by Kristian Andersen on 26/11/14.
//  Copyright (c) 2014 Robocat. All rights reserved.
//

import Foundation
import SpriteKit

enum ObstacleType: String {
    case Plant = "plant"
    case Table = "regular_table"
    case BloodyTable = "bloody_table"
    case Desk = "computer_table"
    case Sofa = "sofa"
    case Stool = "stool"
    
}

class Obstacle: SKSpriteNode {
    convenience init(type: ObstacleType) {
        let color = NSColor.clearColor()
        let texture = SKTexture(imageNamed: type.rawValue)
        let size = texture.size()
        self.init(texture: texture, color: color, size: size)
        
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
        physicsBody?.dynamic = false
    }
}