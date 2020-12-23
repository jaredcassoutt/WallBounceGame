//
//  GameScene.swift
//  Wall Runner
//
//  Created by Jared Cassoutt on 12/8/20.
//

import SpriteKit
import AudioToolbox

class GameScene: SKScene {
    
    let worldNode = SKNode()
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
    
    let scoreLabel = SKLabelNode(text: "0")
    let coinsLabel = SKLabelNode(text: "\(UserDefaults.standard.integer(forKey: ScoreData.coins))")
    
    var background = SKSpriteNode(imageNamed: Images.background)
    var noNotchSubStore:CGFloat = 0
    var noNotchSub:CGFloat = 0
    
    var timer: Timer?
    var didTouch = false
    
    var runnerOnRight = true
    var gravity = 1.0
    var obstaclesToCoin = 8
    var score = 0
    var nCoins = UserDefaults.standard.integer(forKey: ScoreData.coins)
    var timers = [Timer?]()
    
    override func didMove(to view: SKView) {
        if Screen.hasNotch == false {
            noNotchSubStore = 8
        }
        addChild(worldNode)
        setUpPhysics()
        spawnView()
        switchSides()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == Images.pause {
                    if worldNode.isPaused == false {
                        DispatchQueue.main.async {
                            self.pause()
                        }
                        break
                    }
                    else if worldNode.isPaused == true {
                        DispatchQueue.main.async {
                            self.play()
                        }
                        break
                    }
                }
                else {
                    if runner.hasActions() == false {
                        if runner.physicsBody?.affectedByGravity == false {
                            switchSides()
                        }
                    }
                }
            }
        }
    }
    
//MARK: - Game Setup
    
    func setUpPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -gravity)
        physicsWorld.contactDelegate = self
    }
    
    func createBackground() {
        background.zPosition = 0
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        worldNode.addChild(self.background)
    }
    
    func spawnView() {
        createBackground()
        spawnScore()
        spawnCoinCounter()
        spawnRunner()
        spawnWalls()
        newObject()
        spawnPauseButton()
    }
    
    func spawnScore() {
        scoreLabel.fontName = Fonts.main
        scoreLabel.fontSize = 60
        scoreLabel.zPosition = 1
        scoreLabel.color = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY-120)
        worldNode.addChild(scoreLabel)
    }
    
    func spawnPauseButton() {
        pauseShape = SKShapeNode(rectOf: CGSize(width: 30, height: 30), cornerRadius: 15)
        pauseShape.position = CGPoint(x: frame.maxX-45+noNotchSubStore, y: frame.maxY-30)
        pauseShape.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        pauseShape.zPosition = 3
        pauseShape.name = Images.pause
        pauseShape.isUserInteractionEnabled = false
        pauseShape.physicsBody?.affectedByGravity = false
        worldNode.addChild(pauseShape)
        
        if worldNode.isPaused == false {
            pauseButton = SKSpriteNode(texture: SKTexture(imageNamed: Images.pause), size: CGSize(width: 15, height: 15))
        }
        if worldNode.isPaused == true {
            pauseButton = SKSpriteNode(texture: SKTexture(imageNamed: Images.rightArrow), size: CGSize(width: 15, height: 15))
        }
        pauseButton.zPosition = 4
        pauseButton.position = CGPoint(x: pauseShape.frame.midX, y: pauseShape.frame.midY)
        pauseButton.name = Images.pause
        pauseButton.isUserInteractionEnabled = false
        pauseButton.physicsBody?.affectedByGravity = false
        worldNode.addChild(pauseButton)
    }
    
    func forgetPauseButton() {
        pauseShape.removeFromParent()
        pauseButton.removeFromParent()
    }
    
    func pause() {
        DispatchQueue.main.async {
            self.clearTimers()
        }
        worldNode.isPaused = true
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.speed = 0
        stopTimer()
        forgetPauseButton()
        spawnPauseButton()
    }
    
    func play() {
        worldNode.isPaused = false
        physicsWorld.gravity = CGVector(dx: 0, dy: -gravity)
        physicsWorld.speed = 1
        forgetPauseButton()
        spawnPauseButton()
        newObject()
    }
    
    func addCoinShape() {
        let digits = CGFloat("\(UserDefaults.standard.integer(forKey: ScoreData.coins))".count)
        topBar = SKShapeNode(rectOf: CGSize(width: 40+digits*10, height: 30), cornerRadius: 15)
        topBar.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        topBar.position = CGPoint(x: frame.minX+40+digits*5, y: frame.maxY-25)
        topBar.zPosition = 2
        worldNode.addChild(topBar)
    }
    
    func spawnCoinCounter() {
        addCoinShape()
        
        let displayCoin = SKSpriteNode(texture: SKTexture(imageNamed: Images.coin), size: CGSize(width: 15, height: 15))
        displayCoin.zPosition = 3
        displayCoin.position = CGPoint(x: frame.minX+35, y: frame.maxY-25)
        worldNode.addChild(displayCoin)
        
        coinsLabel.fontName = Fonts.main
        coinsLabel.fontSize = 20
        coinsLabel.zPosition = 3
        coinsLabel.color = UIColor.white
        let digits = CGFloat("\(UserDefaults.standard.integer(forKey: ScoreData.coins))".count)
        coinsLabel.position = CGPoint(x: frame.minX+50+digits*5, y: frame.maxY-32.5)
        worldNode.addChild(coinsLabel)
    }

    func spawnRunner() {
        let textureIndex = UserDefaults.standard.integer(forKey: Customizations.texture)
        let runnerTexture = Runners.runnerStyle[textureIndex]
        runner = SKSpriteNode(texture: SKTexture(imageNamed: runnerTexture), size: CGSize(width: 30, height: 30))
        runner.zPosition = 3
        
        runner.name = ObjectNames.runner
        runner.position = CGPoint(x: frame.width-25, y: frame.midY-200)
        runner.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))
        runner.physicsBody?.categoryBitMask = PhysicsCategories.runnerCategory

        runner.physicsBody?.contactTestBitMask = PhysicsCategories.obstacleCategory
        runner.physicsBody?.collisionBitMask = PhysicsCategories.none
        runner.physicsBody?.affectedByGravity = false
        worldNode.addChild(runner)
    }
    
    func spawnWalls() {
        rightWall = SKShapeNode(rectOf: CGSize(width: 14, height: frame.size.height+60), cornerRadius: 5)
        rightWall.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        rightWall.position = CGPoint(x: frame.width-3, y: frame.midY)
        rightWall.zPosition = 1
        worldNode.addChild(rightWall)
        
        leftWall = SKShapeNode(rectOf: CGSize(width: 14, height: frame.size.height+60), cornerRadius: 5)
        leftWall.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        leftWall.position = CGPoint(x: 3, y: frame.midY)
        leftWall.zPosition = 1
        worldNode.addChild(leftWall)
    }

//MARK: - Game Play
    
    @objc func timerAction() {
        newObject()
        if gravity<17 {
            gravity+=0.3
        }
        physicsWorld.gravity = CGVector(dx: 0, dy: -gravity)
        stopTimer()
    }
    
    func createCoinSelection() -> [Bool] {
        var isCoinArray = [Bool]()
        for _ in 0...obstaclesToCoin-2 {
            isCoinArray.append(false)
        }
        isCoinArray.append(true)
        return isCoinArray
    }
    
    func newObject() {
        if worldNode.isPaused == false {
            let isCoin = createCoinSelection()
            if isCoin.randomElement() == true {
                newCoin()
            }
            else {
                newObstacle()
            }
        }
    }
    
    func newCoin() {
        startTimer()
        
        let side = [30,frame.width-30].randomElement() as! CGFloat
        coin = SKSpriteNode(texture: SKTexture(imageNamed: Images.coin), size: CGSize(width: 30, height: 30))
        coin.position = CGPoint(x: side, y: frame.maxY+15)
        coin.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        coin.physicsBody?.affectedByGravity = true
        coin.zPosition = 1
        
        coin.physicsBody?.categoryBitMask = PhysicsCategories.coinCategory
        coin.name = ObjectNames.coin
        coin.addGlow(radius: 5)
        worldNode.addChild(coin)
        
        let fadeIn = SKAction.colorize(with: UIColor.black, colorBlendFactor: 0.8, duration: 0.25)
        let fadeOut = SKAction.colorize(with: UIColor.white, colorBlendFactor: 0.8, duration: 0.25)
        let sequence = SKAction.sequence([fadeIn,fadeOut])
        coin.run(SKAction.repeatForever(sequence))
        deallocateCoin()
    }
    
    func newObstacle() {
        score+=1
        updateScoreLabel()
        startTimer()
        
        let side = [25,frame.width-25].randomElement() as! CGFloat
        let color = [UIColor.red,UIColor.cyan,UIColor.green,UIColor.yellow,UIColor.orange,UIColor.systemPink].randomElement() as! UIColor
        obstacle = SKShapeNode(rectOf: CGSize(width: 20, height: 20), cornerRadius: 3)
        obstacle.fillColor = color
        obstacle.strokeColor = color
        obstacle.position = CGPoint(x: side, y: frame.maxY+15)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
        obstacle.physicsBody?.affectedByGravity = true
        obstacle.zPosition = 1
        
        obstacle.physicsBody?.categoryBitMask = PhysicsCategories.obstacleCategory
        obstacle.name = ObjectNames.obstacle
        worldNode.addChild(obstacle)
        deallocateObstacle()
    }
    
    func startTimer() {
        if score<10 {
            timer = Timer.scheduledTimer(timeInterval: 0.5*gravity, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
        else {
            timer = Timer.scheduledTimer(timeInterval: [0.2,0.3,0.1,0.2,0.3,0.1,0.05].randomElement() as! TimeInterval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
        timers.append(timer!)
    }

    func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        clearTimers()
    }
    
    func clearTimers() {
        for i in timers.indices {
            if i > 1 {
                timers[i]?.invalidate()
                timers[i] = nil
            }
        }
    }
    
    func switchSides() {
        let animationTime = 0.15
        if runnerOnRight == true {
            runnerOnRight = false
            let rotate = SKAction.rotate(byAngle: .pi, duration: animationTime)
            let move = SKAction.move(to: CGPoint(x: 25, y: frame.midY-200), duration: animationTime)
            let group = SKAction.group([rotate, move])
            runner.run(group)
        }
        else {
            runnerOnRight = true
            let rotate = SKAction.rotate(byAngle: -.pi, duration: animationTime)
            let move = SKAction.move(to: CGPoint(x: frame.width-25, y: frame.midY-200), duration: animationTime)
            let group = SKAction.group([rotate, move])
            runner.run(group)
        }
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "\(score)"
    }
    
    func updateCoinLabel() {
        let numCoins = UserDefaults.standard.integer(forKey: ScoreData.coins)+1
        UserDefaults.standard.setValue(numCoins, forKey: ScoreData.coins)
        let digits = CGFloat("\(UserDefaults.standard.integer(forKey: ScoreData.coins))".count)
        coinsLabel.position = CGPoint(x: frame.minX+50+digits*5, y: frame.maxY-32.5)
        coinsLabel.text = "\(UserDefaults.standard.integer(forKey: ScoreData.coins))"
        addCoinShape()
    }
    
//MARK: - Memory Management
    func deallocateObstacle() {
        obstacles.append(obstacle)
        if obstacles.count>10 {
            obstacles[0].removeFromParent()
            obstacles.remove(at: 0)
        }
    }
    
    func deallocateCoin() {
        coins.append(coin)
        if coins.count>10 {
            coins[0].removeAllActions()
            coins[0].removeFromParent()
            coins.remove(at: 0)
        }
    }
    
//MARK: - Game Over
    
    func gameOver() {
        findAverageScore()
        UIDevice.vibrate()
        UserDefaults.standard.setValue(score, forKey: ScoreData.recentScore)
        let scoreCompare = [UserDefaults.standard.integer(forKey: ScoreData.highScore),score]
        UserDefaults.standard.setValue(scoreCompare.max(), forKey: ScoreData.highScore)
        
        let rotation = SKAction.rotate(byAngle: .pi, duration: 0.5)
        var translation = SKAction.move(by: CGVector(dx: 30, dy: -100), duration: 0.5)
        if runnerOnRight == true {
            translation = SKAction.move(by: CGVector(dx: -30, dy: -100), duration: 0.5)
        }
        runner.run(SKAction.group([rotation,translation]))
        runner.run(SKAction.group([rotation,translation])) {
            let menuScene = MenuScene(size: self.view!.frame.size)
            self.view!.presentScene(menuScene)
        }
    }
    
    func findAverageScore() {
        let totalPoints = UserDefaults.standard.integer(forKey: ScoreData.totalPoints) + score
        let gamesPlayed = UserDefaults.standard.integer(forKey: ScoreData.gamesPlayed) + 1
        let averageScore = Int(totalPoints/gamesPlayed)
        UserDefaults.standard.setValue(totalPoints, forKey: ScoreData.totalPoints)
        UserDefaults.standard.setValue(gamesPlayed, forKey: ScoreData.gamesPlayed)
        UserDefaults.standard.setValue(averageScore, forKey: ScoreData.averageScore)
    }
    
}

//MARK: - Contact Delegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contacts = [contact.bodyA.node?.name,contact.bodyB.node?.name]
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.obstacleCategory | PhysicsCategories.runnerCategory {
            if contacts.contains(ObjectNames.coin) && contacts.contains(ObjectNames.runner){
                updateCoinLabel()
                if contacts[0] == ObjectNames.coin {
                    contact.bodyA.node?.removeFromParent()
                }
                else {
                    contact.bodyB.node?.removeFromParent()
                }
            }
            if contacts.contains(ObjectNames.obstacle) && contacts.contains(ObjectNames.runner){
                gameOver()
            }
        }
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
