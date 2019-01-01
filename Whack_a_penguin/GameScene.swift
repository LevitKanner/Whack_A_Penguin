//
//  GameScene.swift
//  Whack_a_penguin
//
//  Created by Levit Kanner on 01/01/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameScore: SKLabelNode!
    var slots = [WhackSlot]()
    var popupTime = 0.85
    var score: Int = 0 {
        didSet{
            gameScore.text = "Score: \(score)"
        }
    }
    var numRounds = 0
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.zPosition = -1
        background.blendMode = .replace
        background.position = CGPoint(x: 512, y: 384)
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: \(score)"
        gameScore.position = CGPoint(x: 10, y: 10)
        gameScore.fontSize = 48
        gameScore.horizontalAlignmentMode = .left
        addChild(gameScore)
        
        
        
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
            self?.createEnemy()
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let allNodes = nodes(at: touch.location(in: self))
        
        for node in allNodes {
            
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            
            if node.name == "charFriend"{
                //Hit the wrong penguin
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                
                
            }else if node.name == "charEnemy" {
                //Hit the right penguin
                
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false))
            }
        }
        
    }
    
    
    
    
    
    func createSlot(at position: CGPoint){
        let slot = WhackSlot()
        slot.configure(at: position)
        slots.append(slot)
        addChild(slot)
    }
    
    
    
    
    
    
    func createEnemy(){
        numRounds += 1
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            
            addChild(gameOver)
            
            let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
            scoreLabel.position = CGPoint(x: 512, y: 300)
            scoreLabel.text = "Final Score: \(score)"
            scoreLabel.fontSize = 46
            scoreLabel.zPosition = 1
            addChild(scoreLabel)
            
            let voice = SKAction.playSoundFileNamed("GameOverVoice.m4a", waitForCompletion: false)
            let dadaAwu = SKAction.playSoundFileNamed("dadawu.m4a", waitForCompletion: false)
            run(SKAction.sequence([dadaAwu , voice]))
            
            return
        }
        
        
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 {  slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline:.now() + delay) {[weak self] in
            self?.createEnemy()
        }
    }
    
}
