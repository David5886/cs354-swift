//
//  Snake.swift
//  cs354-swift
//
//  Created by David Adams on 11/15/22.
//

import Foundation
import SpriteKit

struct category {
    static var foodCat:UInt32 = 0x1
    static var frameCat:UInt32 = 0x1 << 1
    static var snakeCat:UInt32 = 0x1 << 2
}

struct Point {
    
    enum direction{case up, down, left, right}
    var node:SKSpriteNode
    var x:Int
    var y:Int
    
    func phys(_ category: UInt32, _ contactTest: UInt32, _ isDynamic: Bool) {
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width - 1, height: node.size.height - 1))
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = category
        node.physicsBody?.contactTestBitMask = contactTest
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = isDynamic
    }
    
    
    
    func createSnake() {
        
    }
    

}
