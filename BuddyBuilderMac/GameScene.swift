//
//  GameScene.swift
//  BuddyBuilderMac
//
//  Created by Kristian Andersen on 25/11/14.
//  Copyright (c) 2014 Robocat. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    var player: Player!
    var player2: Player!
    var level1: Level!
    var level2: Level!
    var lastUpdated: CFTimeInterval = 0
    
    var audioPlayer: AVAudioPlayer!
    
    override func didMoveToView(view: SKView) {
        player = Player(name: "Player 1", type: .Player1)
        player2 = Player(name: "Player 2", type: .Player2)
        
        configureLevel()
        playMusic()
    }
    
    func playMusic() {
        let loopURL = NSBundle.mainBundle().URLForResource("loop", withExtension: "mp3")
        var error: NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: loopURL, error: &error)
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }
    
    func configureLevel() {
        level1 = Level(player: player)
        level1.position = CGPoint(x: 256, y: 411)
        addChild(level1)
        
        level2 = Level(player: player2)
        level2.position = CGPoint(x: 768, y: 411)
        addChild(level2)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        let location = theEvent.locationInNode(self)
        player.position = location
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        var timeSinceLast = currentTime - lastUpdated
        lastUpdated = currentTime
        if (timeSinceLast > 1) { // more than a second since last update
            timeSinceLast = 1.0 / 60.0
            lastUpdated = currentTime;
        }
        
        if player.shouldMove {
            player.move(player.nextMove, withTimeInterval: timeSinceLast)
            
            if player.actionForKey(player.walkActionKey) == nil {
                player.runAction(player.walkAction, withKey: player.walkActionKey)
            }
        } else {
            player.removeActionForKey(player.walkActionKey)
            player.texture = player.initialTexture
        }
        
        if player.shouldSlash {
            player.shouldSlash = false
            player.runAction(player.slashAction, withKey: player.slashActionKey)
        }
    }
    
    override func keyDown(theEvent: NSEvent) {
        handleKeyEvent(theEvent, isDown: true)
    }
    
    override func keyUp(theEvent: NSEvent) {
        handleKeyEvent(theEvent, isDown: false)
    }
    
    private func handleKeyEvent(event: NSEvent, isDown: Bool) {
        if let key = event.charactersIgnoringModifiers?.utf16[0] {
            let hasCommand = (event.modifierFlags & NSEventModifierFlags.CommandKeyMask).rawValue != 0
            
            var direction: MoveDirection?
            switch Int(key) {
            case NSUpArrowFunctionKey:
                direction = .Up
            case NSDownArrowFunctionKey:
                direction = .Down
            case NSLeftArrowFunctionKey:
                direction = .Left
            case NSRightArrowFunctionKey:
                direction = .Right
            case 32:
                if isDown {
                    player.shouldSlash = true
                }
            default: break
            }
            
            if let direction = direction {
                player.shouldMove = isDown
                player.nextMove = direction
            }
        }
    }
}
