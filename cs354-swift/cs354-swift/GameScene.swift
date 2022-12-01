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
    var food: [Point] = []
    var snake: [Point] = []
    var frames: [Point] = []
    var pauseButton: SKSpriteNode = SKSpriteNode();
    let foodSprite = SKSpriteNode(imageNamed: "apple")

    private static let POINT_SIZE = 10 //site of the nodes that make up our game scene
    
    override func didMove(to view: SKView) {
        createScene()
        addPlayPauseButton()
    }
    
    /**
     Start the game, initializing the game board and game peices.
     */
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
        self.pauseButton.texture = SKTexture(imageNamed: "PauseButton")
        self.pauseButton.name = "PAUSE"
        self.pauseButton.zPosition = 5
        self.pauseButton.size = CGSize(width: 50, height: 50)
        self.pauseButton.position = CGPointMake(CGRectGetMaxX(self.frame) - pauseButton.frame.width / 2 - 10, CGRectGetMaxY(self.frame) - pauseButton.frame.height / 2 - 20)
        self.addChild(pauseButton)
    }
    
    /**
     Create a new fruit and add it to the game board.
     */
    func newFruit() {
        let xFood = Int.random(in:15...Int(self.frame.maxX - 15)) //Set a random coordinate the spawn the fruit at
        let yFood = Int.random(in:25...Int(self.frame.maxY - 100))
        let foodColor = UIColor.green //set the color of the fruit
        let point = createPoint(x: xFood/10*10, y: yFood/10*10) //create the fruit.
        point.node.color = foodColor //set the color of the node
        foodSprite.setScale(0.06)
        foodSprite.position = CGPoint(x:xFood/10*10, y: yFood/10*10)
        addChild(point.node)
        addChild(foodSprite)
        food.removeAll() //clear the food array, this makes sure only 1 fruit is on the board at a time
        food.append(point) //add the fruit to the game board
        frames.append(point)
        print("Fruit generated at the following points:")
        print(xFood)
        print(yFood)
        print("")
    }
    
    /**
     When the snake has ate the fruit, clear the node from the board, gnerate a new fruit, and grow the snake by 1 node.
     */
    func ateFruit() {
        foodSprite.removeFromParent()
        print("Food ate")
        food[0].node.removeFromParent()
        food[0].node.removeAllChildren()
        //food = []
        newFruit()
        growSnake()
    }
    
    /**
     Resets the game to initial state
     */
    func resetGame() {
        createScene()
    }
    
    /**
     Increases the size of the snake by a single point
     */
    func growSnake() {
        let snakePoint = createPoint(x: 0, y: 0)
        addChild(snakePoint.node)
        snake.append(snakePoint)
    }
    
    /**
     Creates the area of the screen that the snake and fruit will appear on.
     */
    func createFrames() {
        for f in frames {
            f.node.removeFromParent()
        }
        frames = []
        let width = Int(frame.width)
        let height = Int(frame.height)
        createHorzFrame(y: height-75, minX: 0, maxX: width+50)
        createHorzFrame(y: 0, minX: 0, maxX: width+50)
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
        let node = SKSpriteNode(color: UIColor(red:15/255,green:233/255,blue:255/255,alpha:1), size: CGSize(width: GameScene.POINT_SIZE/10*10, height: GameScene.POINT_SIZE/10*10))
        node.position = CGPoint(x:x/10*10,y:y/10*10)
        let point = Point(node: node, x:x/10*10,y:y/10*10)
        point.phys(category.snakeCat, category.foodCat | category.frameCat | category.snakeCat, true)
        point.node.physicsBody?.usesPreciseCollisionDetection = true
        return point
    }
    
    /**
     Creates the gameboard, and sets default starting direction. It then calls functions to create fruit, frames, and spawn the snake onto the game board.
     */
    func createScene() {
        backgroundColor = UIColor(red: 6/255, green: 18/255, blue: 82/255, alpha: 1)
        dirX = GameScene.POINT_SIZE/10*10
        dirY = 0
        //newFruit()
        createFrames()
        spawnSnake()
        newFruit()
    }

    /**
     Spawns the snake onto the game board.
     */
    func spawnSnake() {
        for s in snake {
            s.node.removeFromParent()
        }
        snake = []
        createSnake(x: Int(frame.midX)/10*10, y: Int(frame.midY)/10*10)
        //createSnake(x: 100, y: 100)
    }
    
    /**
     Create the initial snake head and adds it to the scene.
     */
    func createSnake(x:Int,y:Int) {
        for i in 0...2 {
            let point = createPoint(x:x - GameScene.POINT_SIZE*i/10*10, y:y/10*10)
            if i == 0 {
                point.node.color = UIColor(red:15/255,green:233/255,blue:255/255,alpha:1)
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
            SKAction.move(by: CGVector(dx: dirX/10*10, dy: dirY/10*10), duration: 0) :
            SKAction.move(to: CGPoint(x: x/10*10, y: y/10*10), duration: 0)
            if(head == true) {
                headX = Double(position.node.position.x)/10*10
                headY = Double(position.node.position.y)/10*10
            }
            x = Double(position.node.position.x)/10*10
            y = Double(position.node.position.y)/10*10
            position.node.run(a)
            head = false
        }
        print(Int(headX))
        print(Int(headY))
        print("")
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
        
        //check to see if the snake has ate the fruit
        var foodX = Int(food[0].node.position.x)
        var foodY = Int(food[0].node.position.y)
        let IntX = Int(headX)
        let IntY = Int(headY)

        if((foodX % 10 == 0) && foodX > 0) {
            foodX = foodX - 1
        }
        if((foodY % 10 == 0) && foodY > 0) {
            foodY = foodY - 1
        }
        if(((foodX == IntX) && (foodY == IntY)) || ((foodX == IntX-1) && (foodY == IntY)) || ((foodX == IntX + 1) && (foodY == IntY)) || ((foodX == IntX) && (foodY == IntY + 1)) || ((foodX == IntX) && (foodY == IntY - 1)) || ((foodX == IntX + 1) && (foodY == IntY + 1)) || ((foodX == IntX - 1) && (foodY == IntY - 1)) || ((foodX == IntX + 1) && (foodY == IntY - 1)) || ((foodX == IntX - 1) && (foodY == IntY + 1))) {
            ateFruit()
        }
    }
    
    var dirX = GameScene.POINT_SIZE
    var dirY = 0
    /**
     When a touch is detected, depending on where the touch was detected, change the position the snake is moving in
     */
    func touchDown(atPoint pos : CGPoint) {
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

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    func pauseGame() {

        if (scene?.view?.isPaused == true) {
            self.pauseButton.texture = SKTexture(imageNamed: "PauseButton")
            scene?.view?.isPaused = false

        } else {
            self.pauseButton.texture = SKTexture(imageNamed: "PlayButton")
            scene?.view?.isPaused = true

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

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
    
    /**
     This function controls how fast the game board updates. 
     */
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
