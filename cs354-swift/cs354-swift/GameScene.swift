//
//  GameScene.swift
//  cs354-swift
//
//  Created by David Adams on 10/20/22.
//

import SpriteKit
import GameplayKit
import SwiftUI
import Darwin

class GameScene: SKScene {
    
    var ughtest = 0
    var food:Point!
    var snake: [Point] = []
    var frames: [Point] = []
    private static let POINT_SIZE = 10
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    func start(_ contact: SKPhysicsContact) {
        let snakeFood = category.foodCat | category.snakeCat
        let snakeFrame = category.snakeCat | category.frameCat
        switch contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask {
        case snakeFood:
            newFruit()
            growSnake()
        case snakeFrame:
            createScene()
        case category.snakeCat:
            createScene()
        default:
            print("test")
        }
    }
    
    func stop() {
        
    }
    
    func setup() {
        
    }
    
    func newFruit() {
        
    }
    
    func resetGame() {
        spawnSnake()
        ughtest = 2
        if(ughtest == 2) { //for testing purposes only
            growSnake()
            growSnake()
            growSnake()
            growSnake()
        }
    }
    
    func growSnake() {
        let snakePoint = createPoint(x: 0, y: 0)
        addChild(snakePoint.node)
        snake.append(snakePoint)
    }
    
    func createFrames() {
        for f in frames {
            f.node.removeFromParent()
        }
        frames = []
        let width = Int(frame.width)
        let height = Int(frame.height)
        createHorzFrame(y: height-75, minX: 0, maxX: width)
    }
    
    func createHorzFrame(y:Int, minX:Int, maxX:Int) {
        for i in stride(from: minX, to: maxX, by: GameScene.POINT_SIZE){
            let point = createPoint(x: i, y: y)
            addChild(point.node)
            frames.append(point)
        }
    }
    
    func createPoint(x:Int,y:Int) -> Point {
        let node = SKSpriteNode(color: UIColor(red:1,green:1,blue:0,alpha:1), size: CGSize(width: GameScene.POINT_SIZE, height: GameScene.POINT_SIZE))
        node.position = CGPoint(x:x,y:y)
        let point = Point(node: node, x:x,y:y)
        point.phys(category.snakeCat, category.foodCat | category.frameCat | category.snakeCat, true)
        point.node.physicsBody?.usesPreciseCollisionDetection = true
        return point
    }
    
//    func createSnakePoint(x:Int,y:Int) {
//        return 0
//    }
    
    func createScene() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        dirX = GameScene.POINT_SIZE
        dirY = 0
        //newFruit()
        createFrames()
        spawnSnake()
    }
    
    func spawnSnake() {
        for s in snake {
            s.node.removeFromParent()
        }
        snake = []
        createSnake(x: Int(frame.midX), y: Int(frame.midY))
    }
    
    func createSnake(x:Int,y:Int) {
        for i in 0...2 {
            let point = createPoint(x:x - GameScene.POINT_SIZE*i, y:y)
            if i == 0 {
                point.node.color = UIColor(red:1,green:1,blue:0,alpha:1)
                if i == 0 {
                    print("head")
                }
                addChild(point.node)
                snake.append(point)
            }
        }
    }
    
    func move() {
        var x = 0.0
        var y = 0.0
        var head = true
        for position in snake {
            let a = head ?
            SKAction.move(by: CGVector(dx: dirX, dy: dirY), duration: 0) :
            SKAction.move(to: CGPoint(x: x, y: y), duration: 0)
            x = Double(position.node.position.x)
            y = Double(position.node.position.y)
            position.node.run(a)
            head = false
        }
        print(x)
        print(y)
        if(x >= self.frame.maxX - 15 || x <= self.frame.minX - 15 || y >= self.frame.maxY - 90 || y <= self.frame.minY - 15) {
            print("OUT OF BOUNDS")
            resetGame()
        }
    }
    
    var dirX = GameScene.POINT_SIZE
    var dirY = 0
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
        let position = (Double(pos.x - self.frame.midX), Double(pos.y - frame.midY))
        switch position {
        case let (x,y) where y > 0 && y > abs(x):
            dirX = 0
            dirY = GameScene.POINT_SIZE
            print("snake up")
        case let (x,y) where y < 0 && abs(y) > abs(x):
            dirX = 0
            dirY = -GameScene.POINT_SIZE
            print("snake down")
        case let (x,y) where x > 0 && x > abs(y):
            dirX = GameScene.POINT_SIZE
            dirY = 0
            print("snake right")
        case let (x,y) where x < 0 && abs(x) > abs(y):
            dirX = -GameScene.POINT_SIZE
            dirY = 0
            print("snake left")
        default:
            print("Center of screne")
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    var timeD:TimeInterval=0
    var oldTime:TimeInterval=0
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        timeD = timeD + (currentTime - oldTime)
        oldTime = currentTime
        if timeD > 0.15 { //This number controls the speed of our "snake"
            move()
            timeD = 0
        }
        // Called before each frame is rendered
    }
}
