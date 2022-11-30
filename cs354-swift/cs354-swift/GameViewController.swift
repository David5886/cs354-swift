//
//  GameViewController.swift
//  cs354-swift
//
//  Created by David Adams on 10/20/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
/*
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let scene = GameScene(fileNamed: "MainMenu"){
            if let view = self.view as! SKView? {
                scene.size = view.bounds.size
                scene.scaleMode = .aspectFit
                view.presentScene(scene)
                // Load the SKScene from 'GameScene.sks'
                //            if let scene = SKScene(fileNamed: "GameScene") {
                //                // Set the scale mode to scale to fit the window
                //                scene.scaleMode = .aspectFill
                //
                //                // Present the scene
                //                view.presentScene(scene)
                //            }
                
                view.showsFPS = true
                view.showsNodeCount = true
                view.ignoresSiblingOrder = true
            }
            
        }
    }
*/
    var scene: MenuScene?
    
    override func loadView(){
        super.loadView()
        self.view = SKView()
        self.view.bounds = UIScreen.main.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadMainMenu()
    }
    
    
    func loadMainMenu(){
        if let view = self.view as? SKView, scene == nil{
            let scene = MenuScene(size: view.bounds.size)
            view.presentScene(scene)
            self.scene = scene
        }
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
//    private func setup() {
//        guard let skView = view as? SKView else {
//            return
//        }
//        
//        let scene = GameScene(size: view.bounds.size)
//        skView.showsFPS = true
//        sk
//    }
}
