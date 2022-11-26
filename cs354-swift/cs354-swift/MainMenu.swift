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
    override func didMove(to view:SKView){
        self.backgroundColor = .white
        
        let title = SKSpriteNode(imageNamed: "snakeTitle")
        title.position = CGPoint(x:size.width / 2, y:size.height / 1.7)
        title.setScale(0.42)
        
        let rect = CGRect(
            origin: CGPoint(x:size.width,y:size.height),
            size: UIScreen.main.bounds.size
        )
        
        let launch = SKShapeNode(rect: rect, cornerRadius: 40)
        
        
        addChild(title)
        addChild(launch)

    }
}
