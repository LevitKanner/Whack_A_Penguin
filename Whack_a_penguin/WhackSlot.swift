//
//  WhackSlot.swift
//  Whack_a_penguin
//
//  Created by Levit Kanner on 01/01/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false
    
    
    
    
    
    func configure(at position: CGPoint){
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        
        let cropNode = SKCropNode()
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    
    
    
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        addMudEffect()
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        let action = SKAction.moveBy(x: 0, y: 80, duration: 0.05)
        charNode.run(action)
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        }else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {[weak self] in
            self?.hide()
        }
    }
    
    
    
    
    func hide() {
        if !isVisible { return }
        
        addMudEffect()
        let hideAction = SKAction.moveBy(x: 0, y: -80, duration: 0.05)
        charNode.run(hideAction)
        isVisible = false
    }
    
    
    
    
    func hit() {
        isHit = true
        if let smoke = SKEmitterNode(fileNamed: "smoke"){
            smoke.position = charNode.position
            addChild(smoke)
        }
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run {[unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([delay , hide , notVisible]))
    }
    
    func addMudEffect(){
        if let mud = SKEmitterNode(fileNamed: "mud"){
            mud.position = charNode.position
            addChild(mud)
        }
    }
}
