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
    var pauseButton: SKSpriteNode = SKSpriteNode(imageNamed: "PLAY-PAUSE");
    private static let POINT_SIZE = 10
    
    override func didMove(to view: SKView) {
        createScene()
        addPlayPauseButton()
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
    
    func addPlayPauseButton() {
        self.pauseButton.name = "PAUSE"
        self.pauseButton.zPosition = 3
        self.pauseButton.position = CGPointMake(CGRectGetMaxX(self.frame) - pauseButton.frame.width / 2, CGRectGetMaxY(self.frame) - pauseButton.frame.height / 2)
        self.addChild(pauseButton)
    }
    
    func stop() {
        
    }
    
    func setup() {
        
    }
    
    func newFruit() {
        
    }
    
    /**
     Resets the game to initial state
     */
    func resetGame() {
        //spawnSnake()
        createScene()
        ughtest = 2
        if(ughtest == 2) { //for testing purposes only
            growSnake()
            growSnake()
            growSnake()
            growSnake()
        }
    }
    
    /**
     Increases the size of the snake by a single point
     */
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
    
    /**
     Creates the top horizontal frame at the top of the game board.
     */
    func createHorzFrame(y:Int, minX:Int, maxX:Int) {
        for i in stride(from: minX, to: maxX, by: GameScene.POINT_SIZE){
            let point = createPoint(x: i, y: y)
            addChild(point.node)
            frames.append(point)
        }
    }
    
    /**
     Point is used for game elements. Such as the snake, top boarder, and fruit
     */
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
    
    /**
     Creates the gameboard, and sets default starting direction. It then calls functions to create fruit, frames, and spawn the snake onto the game board.
     */
    func createScene() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        dirX = GameScene.POINT_SIZE
        dirY = 0
        //newFruit()
        createFrames()
        spawnSnake()
    }
    
    /**
     Spawns the snake onto the game board.
     */
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
                    //print("head")
                }
                addChild(point.node)
                snake.append(point)
            }
        }
    }
    
    /**
        Handles the movement of the snake. Also checks to see if the snake is still within the bounds of the game board. If the head of the snake hits the edge of the board, the game resets.
     */
    func move() {
        var x = 0.0
        var y = 0.0
        var headX = 0.0 //used to track the position of the head snake node (Both headX and headY)
        var headY = 0.0
        var head = true
        //set positioning variables
        for position in snake {
            let a = head ?
            SKAction.move(by: CGVector(dx: dirX, dy: dirY), duration: 0) :
            SKAction.move(to: CGPoint(x: x, y: y), duration: 0)
            if(head == true) {
                headX = Double(position.node.position.x)
                headY = Double(position.node.position.y)
            }
            x = Double(position.node.position.x)
            y = Double(position.node.position.y)
            position.node.run(a)
            head = false
        }
        print(headX)
        print(headY)
        //Check to see if the snake is within bounds of boardgame. If not, reset the game.
        if(headX >= self.frame.maxX - 15 || headX <= self.frame.minX - 15 || headY >= self.frame.maxY - 90 || headY <= self.frame.minY - 15) {
            print("OUT OF BOUNDS!")
            resetGame()
        }
        //check to see if the snake has ran into itself. If so, reset the game.
        if(snake.count > 2) {
            for i in 1..<snake.count {
                if((Int(snake[0].node.position.x) == Int(snake[i].node.position.x)) && (Int(snake[0].node.position.y) == Int(snake[i].node.position.y))) {
                    print("collision detected!")
                    resetGame()
                    return
                }
            }
        }
    }
    
    var dirX = GameScene.POINT_SIZE
    var dirY = 0
    /**
     When a touch is detected, depending on where the touch was detected, change the position the snake is moving in
     */
    func touchDown(atPoint pos : CGPoint) {
        growSnake()

//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
        let position = (Double(pos.x - self.frame.midX), Double(pos.y - frame.midY))
        switch position {
        case let (x,y) where y > 0 && y > abs(x): //Set snake to move up
            if(dirY == -10 && snake.count > 1) { //check to see if the snake is bigger than 1 point, if so, if the requested move is opposite of what the snake is moving, don't change direction.
                print("ILLEGAL MOVE!");
                return
            }
            dirX = 0
            dirY = GameScene.POINT_SIZE
            print("snake up")
            print(position);
        case let (x,y) where y < 0 && abs(y) > abs(x): //Set snake to move down
            if(dirY == 10 && snake.count > 1) { //check to see if the snake is bigger than 1 point, if so, if the requested move is opposite of what the snake is moving, don't change direction.
                print("ILLEGAL MOVE!")
                return
            }
            dirX = 0
            dirY = -GameScene.POINT_SIZE
            print("snake down")
            print(position);
        case let (x,y) where x > 0 && x > abs(y): //set snake to move to the right
            if(dirX == -10 && snake.count > 1) { //check to see if the snake is bigger than 1 point, if so, if the requested move is opposite of what the snake is moving, don't change direction.
                print("ILLEGAL MOVE!")
                return
            }
            dirX = GameScene.POINT_SIZE
            dirY = 0
            print("snake right")
            print(position);
        case let (x,y) where x < 0 && abs(x) > abs(y): //set snake to move to the left
            if(dirX == 10 && snake.count > 1) { //check to see if the snake is bigger than 1 point, if so, if the requested move is opposite of what the snake is moving, don't change direction.
                print("ILLEGAL MOVE!");
                return
            }
            dirX = -GameScene.POINT_SIZE
            dirY = 0
            print("snake left")
            print(position);
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
    
    func pauseGame() {
        if (scene?.view?.isPaused == true) {
            scene?.view?.isPaused = false
        } else {
            scene?.view?.isPaused = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        
        for t in touches {
            let location = t.location(in: self)
            
            if (pauseButton.contains(location)) {
                print("Game is paused")
                pauseGame()
            }
            self.touchDown(atPoint: t.location(in: self))
            
        }
        
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
