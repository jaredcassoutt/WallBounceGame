//
//  TutorialScene.swift
//  Wall Runner
//
//  Created by Jared Cassoutt on 12/11/20.
//

import SpriteKit
import AudioToolbox

class TutorialScene: SKScene {
    
    var runner: SKSpriteNode!
    var rightWall: SKShapeNode!
    var leftWall: SKShapeNode!
    var obstacle: SKShapeNode!
    var coin: SKSpriteNode!
    var obstacles = [SKShapeNode]()
    var coins = [SKSpriteNode]()
    var displayCoin: SKSpriteNode!
    var topBar: SKShapeNode!
    var pauseShape: SKShapeNode!
    var pauseButton: SKSpriteNode!
    
    var tutorialView: SKShapeNode!
    let tutorialText = SKLabelNode(text: "Tap to Switch Sides")
    var tutorialRunner: SKSpriteNode!
    var tutorialTap1: SKShapeNode!
    var tutorialTap2: SKShapeNode!
    var tutorialTimer: Timer!
    let tutorialAnimationTime = 1.5
    var tutorialRunnerOnRight = true
    var tutorialClick = SKSpriteNode(imageNamed: Images.click)
    
    let scoreLabel = SKLabelNode(text: "0")
    let coinsLabel = SKLabelNode(text: "\(UserDefaults.standard.integer(forKey: ScoreData.coins))")
    var background = SKSpriteNode(imageNamed: Images.background)
    
    var score = 0
    var noNotchSubStore:CGFloat = 0
    var noNotchSub:CGFloat = 0
    
    override func didMove(to view: SKView) {
        if Screen.hasNotch == false {
            noNotchSubStore = 8
        }
        showTutorial()
        spawnView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: view!.frame.size)
        view!.presentScene(gameScene)
    }
    
    
//MARK: - Game Tutorial
    
    func showTutorial() {
        //create tutorial view
        tutorialView = SKShapeNode(rectOf: CGSize(width: 200, height: 140), cornerRadius: 15)
        tutorialView.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        tutorialView.zPosition = 2
        tutorialView.position = CGPoint(x: frame.midX, y: frame.midY+30)
        addChild(tutorialView)
        
        //add tutorial runner
        let textureIndex = UserDefaults.standard.integer(forKey: Customizations.texture)
        let runnerTexture = Runners.runnerStyle[textureIndex]
        tutorialRunner = SKSpriteNode(texture: SKTexture(imageNamed: runnerTexture), size: CGSize(width: 20, height: 20))
        tutorialRunner.position = CGPoint(x: tutorialView.frame.maxX-20, y: tutorialView.frame.midY)
        tutorialRunner.zPosition = 3
        addChild(tutorialRunner)
        
        //add tutorial text
        tutorialText.position = CGPoint(x: tutorialView.frame.midX, y: tutorialView.frame.maxY-30)
        tutorialText.fontName = Fonts.main
        tutorialText.fontSize = 17
        tutorialText.zPosition = 3
        tutorialText.color = UIColor.white
        addChild(tutorialText)
        
        tutorialTap1 = SKShapeNode(circleOfRadius: 6)
        tutorialTap2 = SKShapeNode(circleOfRadius: 9)
        tutorialTap1.fillColor = UIColor.clear
        tutorialTap2.fillColor = UIColor.clear
        tutorialTap1.strokeColor = UIColor.white
        tutorialTap2.strokeColor = UIColor.white
        tutorialTap1.position = CGPoint(x: tutorialView.frame.midX, y: tutorialView.frame.minY+35)
        tutorialTap2.position = CGPoint(x: tutorialView.frame.midX, y: tutorialView.frame.minY+35)
        tutorialTap1.zPosition = 3
        tutorialTap2.zPosition = 3
        addChild(tutorialTap1)
        addChild(tutorialTap2)
        
        tutorialClick.zRotation = 0.5
        tutorialClick.size = CGSize(width: 30, height: 30)
        tutorialClick.position = CGPoint(x: tutorialView.frame.midX+9, y: tutorialView.frame.minY+25)
        tutorialClick.zPosition = 4
        addChild(tutorialClick)
        
        tutorialTapAnimation()
    }
    
    @objc func tutorialAnimation() {
        tutorialTapAnimation()
        tutorialTimer.invalidate()
    }
    
    func tutorialTapAnimation() {
        tutorialTimer = Timer.scheduledTimer(timeInterval: tutorialAnimationTime, target: self, selector: #selector(tutorialAnimation), userInfo: nil, repeats: true)
        increaseTapSize()
        decreaseTapSize()
        tutorialSwitchSides()
    }
    
    func increaseTapSize() {
        let rippleSizeIncrease = SKAction.scale(by: 2.5, duration: 0.2)
        let clickSizeIncrease = SKAction.scale(by: 1.6, duration: 0.2)
        tutorialTap1.run(rippleSizeIncrease)
        tutorialTap2.run(rippleSizeIncrease)
        tutorialClick.run(clickSizeIncrease)
    }
    
    func decreaseTapSize() {
        let rippleSizeDecrease = SKAction.scale(by: 0.4, duration: 0.2)
        let clickSizeDecrease = SKAction.scale(by: 0.625, duration: 0.2)
        tutorialTap1.run(rippleSizeDecrease)
        tutorialTap2.run(rippleSizeDecrease)
        tutorialClick.run(clickSizeDecrease)
    }
    
    func tutorialSwitchSides() {
        if tutorialRunner.hasActions() == false {
            let animationTime = 0.5
            if tutorialRunnerOnRight == true {
                tutorialRunnerOnRight = false
                let rotate = SKAction.rotate(byAngle: .pi, duration: animationTime)
                let move = SKAction.move(to: CGPoint(x: tutorialView.frame.minX+20, y: tutorialView.frame.midY), duration: animationTime)
                let group = SKAction.group([rotate, move])
                tutorialRunner.run(group)
            }
            else {
                tutorialRunnerOnRight = true
                let rotate = SKAction.rotate(byAngle: -.pi, duration: animationTime)
                let move = SKAction.move(to: CGPoint(x: tutorialView.frame.maxX-20, y: tutorialView.frame.midY), duration: animationTime)
                let group = SKAction.group([rotate, move])
                tutorialRunner.run(group)
            }
        }
    }
    
//MARK: - Game Background Setup
    
    func createBackground() {
        background.zPosition = 0
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        addChild(self.background)
    }
    
    func spawnView() {
        createBackground()
        spawnScore()
        spawnCoinCounter()
        spawnRunner()
        spawnWalls()
        spawnPauseButton()
    }
    
    func spawnScore() {
        scoreLabel.fontName = Fonts.main
        scoreLabel.fontSize = 60
        scoreLabel.zPosition = 1
        scoreLabel.color = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY-120)
        addChild(scoreLabel)
    }
    
    func spawnRunner() {
        let textureIndex = UserDefaults.standard.integer(forKey: Customizations.texture)
        let runnerTexture = Runners.runnerStyle[textureIndex]
        runner = SKSpriteNode(texture: SKTexture(imageNamed: runnerTexture), size: CGSize(width: 30, height: 30))
        runner.zPosition = 1
        
        runner.name = "runnner"
        runner.position = CGPoint(x: frame.width-25, y: frame.midY-200)
        runner.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))
        runner.physicsBody?.categoryBitMask = PhysicsCategories.runnerCategory

        runner.physicsBody?.contactTestBitMask = PhysicsCategories.obstacleCategory
        runner.physicsBody?.collisionBitMask = PhysicsCategories.none
        runner.physicsBody?.affectedByGravity = false
        addChild(runner)
    }
    
    func spawnPauseButton() {
        pauseShape = SKShapeNode(rectOf: CGSize(width: 30, height: 30), cornerRadius: 15)
        pauseShape.position = CGPoint(x: frame.maxX-45+noNotchSubStore, y: frame.maxY-30)
        pauseShape.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        pauseShape.zPosition = 3
        pauseShape.name = Images.pause
        pauseShape.isUserInteractionEnabled = false
        pauseShape.physicsBody?.affectedByGravity = false
        addChild(pauseShape)
        
        pauseButton = SKSpriteNode(texture: SKTexture(imageNamed: Images.pause), size: CGSize(width: 15, height: 15))
        pauseButton.zPosition = 4
        pauseButton.position = CGPoint(x: pauseShape.frame.midX, y: pauseShape.frame.midY)
        pauseButton.name = Images.pause
        pauseButton.isUserInteractionEnabled = false
        pauseButton.physicsBody?.affectedByGravity = false
        addChild(pauseButton)
    }
    
    func addCoinShape() {
        let digits = CGFloat("\(UserDefaults.standard.integer(forKey: ScoreData.coins))".count)
        topBar = SKShapeNode(rectOf: CGSize(width: 40+digits*10, height: 30), cornerRadius: 15)
        topBar.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        topBar.position = CGPoint(x: frame.minX+40+digits*5, y: frame.maxY-25)
        topBar.zPosition = 2
        addChild(topBar)
    }
    
    func spawnCoinCounter() {
        addCoinShape()
        
        let displayCoin = SKSpriteNode(texture: SKTexture(imageNamed: Images.coin), size: CGSize(width: 15, height: 15))
        displayCoin.zPosition = 3
        displayCoin.position = CGPoint(x: frame.minX+35, y: frame.maxY-25)
        addChild(displayCoin)
        
        coinsLabel.fontName = Fonts.main
        coinsLabel.fontSize = 20
        coinsLabel.zPosition = 3
        coinsLabel.color = UIColor.white
        let digits = CGFloat("\(UserDefaults.standard.integer(forKey: ScoreData.coins))".count)
        coinsLabel.position = CGPoint(x: frame.minX+50+digits*5, y: frame.maxY-32.5)
        addChild(coinsLabel)
    }
    
    func spawnWalls() {
        rightWall = SKShapeNode(rectOf: CGSize(width: 14, height: frame.size.height+60), cornerRadius: 5)
        rightWall.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        rightWall.position = CGPoint(x: frame.width-3, y: frame.midY)
        rightWall.zPosition = 1
        addChild(rightWall)
        
        leftWall = SKShapeNode(rectOf: CGSize(width: 14, height: frame.size.height+60), cornerRadius: 5)
        leftWall.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        leftWall.position = CGPoint(x: 3, y: frame.midY)
        leftWall.zPosition = 1
        addChild(leftWall)
    }
}
