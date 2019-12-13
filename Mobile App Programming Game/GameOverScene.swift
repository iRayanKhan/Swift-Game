//
//  GameOverScene.swift
//  Mobile App Programming Game
//
//  Created by Hoang, Peter T on 12/13/19.
//  Copyright © 2019 Khan, Rayan A. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.white
        let message = "You died."
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 25
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() { [weak self] in
                guard let `self` = self else { return }
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                
                
            }
            ]))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
