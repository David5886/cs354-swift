//
//  MainMenu.swift
//  cs354-swift
//
//  Created by Julia Larsen
//

import SpriteKit
import GameplayKit
import SwiftUI

// struct for any custom colors
struct customColor {
    static let titleBlue = Color("titleBlue")
    
}


struct MainMenu: View {
    
        var body: some View {
            
            VStack {
                Image("snakeTitle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                
                // difficulty buttons
                HStack{
                    
                    // easy
                    Button(action: {/*eventually link*/}){
                        HStack{
                            Text("Easy")
                                .fontWeight(.heavy)
                                .foregroundColor(customColor.titleBlue)
                                .font(.system(size: 30))
                        }
                    }
                    .padding(5)
                    Rectangle().frame(width:2, height:30).foregroundColor(.black)
                    
                    
                    // Medium
                    Button(action: {/*eventually link*/})
                    {
                        HStack{
                            Text("Normal")
                                .fontWeight(.heavy)
                                .foregroundColor(customColor.titleBlue)
                                .font(.system(size: 30))
                            
                        }
                    }
                    .padding(5)
                    Rectangle().frame(width:2, height:30).foregroundColor(.black)
                    
                    
                    // hard
                    Button(action: {/*eventually link*/}){
                        HStack{
                            Text("Hard")
                                .fontWeight(.heavy)
                                .foregroundColor(customColor.titleBlue)
                                .font(.system(size: 30))
                            
                        }
                    }
                }
                .padding(40)
                
                // play button
                Button(action: {/*eventually link*/}) {
                    HStack{
                        Text("Play")
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                }
                .frame(minWidth: 0, maxWidth: 120)
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [customColor.titleBlue, Color(.cyan)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(40)
            }
        }
    }
    

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}


class MenuScene:SKScene, SKPhysicsContactDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "launch_button" || touchedNode.name == "Play"{
                
                if let view = self.view {
                    let scene = GameScene(size: view.bounds.size)
                    view.presentScene(scene)
                }
                
            }
                
        }
    }

    
    override func didMove(to view:SKView){
        self.backgroundColor = .white
        
        // attributes for game title
        let title = SKSpriteNode(imageNamed: "snakeTitle")
        title.position = CGPoint(x:size.width / 2, y:size.height / 1.7)
        title.setScale(0.42)
        
        // attributes for button body
        let launch = SKShapeNode(rectOf: CGSize(width: 200, height: 70))
        launch.position = CGPoint(x:size.width / 2, y:size.height / 2.2)
        launch.fillColor = UIColor(red: 18/255, green: 75/255, blue: 121/255, alpha: 175)
        launch.path = UIBezierPath(roundedRect: CGRect(x: -100, y: -100, width: 200, height: 70), cornerRadius: 40).cgPath

    
        // attributes for button text
        let play = SKLabelNode(fontNamed: "Andale Mono")
        play.text = "Play"
        play.fontColor = SKColor.white
        play.position = CGPointMake(launch.frame.midX, launch.frame.midY-10)
        
        launch.name = "launch_button"
        play.name = "Play"
        
        addChild(title)
        addChild(launch)
        addChild(play)

    }
}
