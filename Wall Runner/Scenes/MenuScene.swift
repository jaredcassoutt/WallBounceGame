//
//  MenuScene.swift
//  Wall Runner
//
//  Created by Jared Cassoutt on 12/9/20.
//
import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    var background: SKSpriteNode!
    var store: SKSpriteNode!
    var displayCoin: SKSpriteNode!
    let coinsLabel = SKLabelNode(text: "\(UserDefaults.standard.integer(forKey: ScoreData.coins))")
    var goingToStore = false
    var noNotchSubStore = 0
    var noNotchSub = 0
    
    
    override func didMove(to view: SKView) {
        if Screen.hasNotch == false {
            noNotchSubStore = 5
        }
        createBackground()
        addLogoAndShop()
        spawnCoinCounter()
        addLabels()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == Images.store {
                    goingToStore = true
                    goToStore()
                }
            }
        }
        if goingToStore == false {
            let tutorialScene = TutorialScene(size: view!.bounds.size)
            view!.presentScene(tutorialScene)
        }
    }

//MARK: - Background, Logo, Coins, and Shop Creation
    
    func createBackground() {
        background = SKSpriteNode(imageNamed: Images.background)
        background.zPosition = 0
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        addChild(self.background)
    }
    
    func addLogoAndShop() {
        let logo = SKSpriteNode(imageNamed: Images.logo)
        logo.size = CGSize(width: frame.size.width/2, height: frame.size.width/2)
        logo.position = CGPoint(x: frame.midX, y: frame.midY+frame.size.width/2.5)
        logo.zPosition = 1
        logo.addGlow(radius: 12.5)
        addChild(logo)
        
        let store = SKSpriteNode(imageNamed: Images.store)
        store.size = CGSize(width: 25, height: 25)
        store.position = CGPoint(x: frame.maxX-45+CGFloat(noNotchSubStore), y: frame.maxY-30)
        store.zPosition = 2
        store.addGlow(radius: 5)
        store.name = Images.store
        store.isUserInteractionEnabled = false
        
        addChild(store)
    }
    
    func spawnCoinCounter() {
        let displayCoin = SKSpriteNode(texture: SKTexture(imageNamed: Images.coin), size: CGSize(width: 15, height: 15))
        displayCoin.zPosition = 3
        displayCoin.position = CGPoint(x: frame.minX+35-CGFloat(noNotchSub), y: frame.maxY-25)
        addChild(displayCoin)
        
        coinsLabel.fontName = Fonts.main
        coinsLabel.fontSize = 20
        coinsLabel.zPosition = 3
        coinsLabel.color = UIColor.white
        let digits = CGFloat("\(UserDefaults.standard.integer(forKey: ScoreData.coins))".count)
        coinsLabel.position = CGPoint(x: frame.minX+50-CGFloat(noNotchSub)+digits*5, y: frame.maxY-32.5)
        
        addChild(coinsLabel)
    }
    
//MARK: - Menu Labels
    
    func addLabels() {
        let playLabel = SKLabelNode(text: "Tap to Play!")
        playLabel.fontName = Fonts.main
        playLabel.fontSize = 30
        playLabel.fontColor = UIColor.white
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        playLabel.zPosition = 1
        addChild(playLabel)
        animate(label: playLabel)
        
        let highscoreLabel = SKLabelNode(text: "Highscore: \(UserDefaults.standard.integer(forKey: ScoreData.highScore))")
        highscoreLabel.fontName = Fonts.main
        highscoreLabel.fontSize = 20
        highscoreLabel.fontColor = UIColor.white
        highscoreLabel.position = CGPoint(x: frame.midX, y: frame.midY-highscoreLabel.frame.size.height*5)
        highscoreLabel.zPosition = 1
        addChild(highscoreLabel)
        
        let recentScoreLabel = SKLabelNode(text: "Recent Score: \(UserDefaults.standard.integer(forKey: ScoreData.recentScore))")
        recentScoreLabel.fontName = Fonts.main
        recentScoreLabel.fontSize = 20
        recentScoreLabel.fontColor = UIColor.white
        recentScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY-recentScoreLabel.frame.size.height*4)
        recentScoreLabel.zPosition = 1
        addChild(recentScoreLabel)
        
        let averageScore = SKLabelNode(text: "Average Score: \(UserDefaults.standard.integer(forKey: ScoreData.averageScore))")
        averageScore.fontName = Fonts.main
        averageScore.fontSize = 20
        averageScore.fontColor = UIColor.white
        averageScore.position = CGPoint(x: frame.midX, y: frame.midY-averageScore.frame.size.height*7)
        averageScore.zPosition = 1
        addChild(averageScore)
    }
    
    func animate(label: SKLabelNode) {
        let scaleUp = SKAction.scale(by: 1.25, duration: 0.85)
        let scaleDown = SKAction.scale(by: 0.8, duration: 0.85)
        
        let sequence = SKAction.sequence([scaleUp,scaleDown])
        label.run(SKAction.repeatForever(sequence))
    }

//MARK: - Segues
    
    func goToStore() {
        print("store")
        let storeScene = StoreScene(size: view!.bounds.size)
        view!.presentScene(storeScene)
    }
    
    func goToTutorial() {
        let tutorialScene = TutorialScene(size: view!.bounds.size)
        view!.presentScene(tutorialScene)
    }
}

extension SKSpriteNode {
    func addGlow(radius: Float = 30) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        let filterNode = SKSpriteNode(texture: texture)
        filterNode.size = self.size
        effectNode.addChild(filterNode)
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":radius])
    }
}
