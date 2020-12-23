//
//  StoreScene.swift
//  Wall Runner
//
//  Created by Jared Cassoutt on 12/12/20.
//
import UIKit
import SpriteKit

class StoreScene: SKScene, Alertable {
    
    var background: SKSpriteNode!
    var store: SKSpriteNode!
    var displayCoin: SKSpriteNode!
    let coinsLabel = SKLabelNode(text: "\(UserDefaults.standard.integer(forKey: ScoreData.coins))")
    
    
    var storeBackground: SKShapeNode!
    var storeRightArrow: SKSpriteNode!
    var storeLeftArrow: SKSpriteNode!
    
    var previousItem: SKShapeNode!
    var previousItemImage: SKSpriteNode!
    var previousItemPriceShape: SKShapeNode!
    var previousItemPriceLabel: SKLabelNode!
    var previousItemCoin: SKSpriteNode!
    var item: SKShapeNode!
    var itemImage: SKSpriteNode!
    var itemPriceShape: SKShapeNode!
    var itemPriceLabel: SKLabelNode!
    var itemCoin: SKSpriteNode!
    var nextItem: SKShapeNode!
    var nextItemImage: SKSpriteNode!
    var nextItemPriceShape: SKShapeNode!
    var nextItemPriceLabel: SKLabelNode!
    var nextItemCoin: SKSpriteNode!
    var noNotchSub = 0
    var noNotchSubStore = 0
    
    var itemIndex = UserDefaults.standard.integer(forKey: Customizations.texture)
    
    
    override func didMove(to view: SKView) {
        if Screen.hasNotch == false {
            noNotchSubStore = 8
        }
        createBackground()
        addLogoAndShop()
        spawnCoinCounter()
        addLabels()
        createStore()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if location.y > frame.midY+105 || location.y < frame.midY-45 {
                    backToMenu()
                }
                if node.name == Images.leftArrow {
                    if item.hasActions() == false {
                        leftPressed()
                    }
                }
                else if node.name == Images.rightArrow {
                    if item.hasActions() == false {
                        rightPressed()
                    }
                }
                if node.name == "buy" || node.name == "coin" {
                    purchase()
                }
            }
        }
    }
    
    
//MARK: - Store Creation
    
    func createStore() {
        createStoreBackground()
        createArrows()
        createAllItems()
    }
    
    func createArrows() {
        if itemIndex < Runners.runnerStyle.count-1 {
            storeRightArrow = SKSpriteNode(texture: SKTexture(imageNamed: Images.rightArrow), size: CGSize(width: 30, height: 30))
            storeRightArrow.addGlow(radius: 5)
            storeRightArrow.name = Images.rightArrow
            storeRightArrow.position = CGPoint(x: storeBackground.frame.maxX-50, y: storeBackground.frame.midY)
            storeRightArrow.zPosition = 7
            addChild(storeRightArrow)
        }
        
        if itemIndex > 0 {
            storeLeftArrow = SKSpriteNode(texture: SKTexture(imageNamed: Images.leftArrow), size: CGSize(width: 30, height: 30))
            storeLeftArrow.addGlow(radius: 5)
            storeLeftArrow.name = Images.leftArrow
            storeLeftArrow.position = CGPoint(x: storeBackground.frame.minX+50, y: storeBackground.frame.midY)
            storeLeftArrow.zPosition = 7
            addChild(storeLeftArrow)
        }
    }
    
    func createStoreBackground() {
        storeBackground = SKShapeNode(rectOf: CGSize(width: size.width+25, height: 150))
        storeBackground.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        storeBackground.zPosition = 3
        storeBackground.name = "background"
        storeBackground.position = CGPoint(x: frame.midX, y: frame.midY+30)
        addChild(storeBackground)
    }
    
    func createPreviousItem() {
        previousItem = SKShapeNode(rectOf: CGSize(width: 0.8*100, height: 0.8*125), cornerRadius: 15)
        previousItem.fillColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
        previousItem.zPosition = 4
        previousItem.name = "previous item"
        previousItem.position = CGPoint(x: storeBackground.frame.minX-75, y: storeBackground.frame.midY)
        addChild(previousItem)
        
        let runnerTexture = Runners.runnerStyle[itemIndex-1]
        previousItemImage = SKSpriteNode(texture: SKTexture(imageNamed: runnerTexture), size: CGSize(width: 0.8*45, height: 0.8*45))
        previousItemImage.position = CGPoint(x: previousItem.frame.midX, y: previousItem.frame.midY+15)
        previousItemImage.zPosition = 5
        addChild(previousItemImage)
        
        previousItemPriceShape = SKShapeNode(rectOf: CGSize(width: 0.8*65, height: 0.8*30), cornerRadius: 15)
        previousItemPriceShape.fillColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.8)
        previousItemPriceShape.position = CGPoint(x: previousItem.frame.midX, y: previousItem.frame.minY+25)
        previousItemPriceShape.zPosition = 5
        addChild(previousItemPriceShape)
        
        if UserDefaults.standard.array(forKey: Customizations.bought)?[itemIndex-1] as! Bool == false {
            previousItemPriceLabel = SKLabelNode(text: "\(Customizations.price)")
            previousItemPriceLabel.position = CGPoint(x: previousItemPriceShape.frame.midX+10, y: previousItemPriceShape.frame.midY-8)
        }
        else {
            previousItemPriceLabel = SKLabelNode(text: "Use")
            previousItemPriceLabel.position = CGPoint(x: previousItemPriceShape.frame.midX, y: previousItemPriceShape.frame.midY-8)
        }
        previousItemPriceLabel.fontSize = 0.8*20
        previousItemPriceLabel.fontName = Fonts.main
        previousItemPriceLabel.zPosition = 6
        addChild(previousItemPriceLabel)
        
        if UserDefaults.standard.array(forKey: Customizations.bought)?[itemIndex-1] as! Bool == false {
            previousItemCoin = SKSpriteNode(texture: SKTexture(imageNamed: Images.coin), size: CGSize(width: 0.8*20, height: 0.8*20))
            previousItemCoin.zPosition = 6
            previousItemCoin.name = "previous coin"
            previousItemCoin.position = CGPoint(x: previousItemPriceShape.frame.minX+15, y: previousItemPriceShape.frame.midY)
            addChild(previousItemCoin)
        }
    }
    
        
    func createItem() {
        item = SKShapeNode(rectOf: CGSize(width: 100, height: 125), cornerRadius: 15)
        item.fillColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
        item.zPosition = 4
        item.name = "buy"
        item.position = CGPoint(x: storeBackground.frame.midX, y: storeBackground.frame.midY)
        addChild(item)
        
        let runnerTexture = Runners.runnerStyle[itemIndex]
        itemImage = SKSpriteNode(texture: SKTexture(imageNamed: runnerTexture), size: CGSize(width: 45, height: 45))
        itemImage.position = CGPoint(x: item.frame.midX, y: item.frame.midY+15)
        itemImage.name = "buy"
        itemImage.zPosition = 5
        addChild(itemImage)
        
        itemPriceShape = SKShapeNode(rectOf: CGSize(width: 65, height: 30), cornerRadius: 15)
        itemPriceShape.fillColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.8)
        itemPriceShape.position = CGPoint(x: item.frame.midX, y: item.frame.minY+25)
        itemPriceShape.zPosition = 5
        itemPriceShape.name = "buy"
        addChild(itemPriceShape)
        
        if UserDefaults.standard.array(forKey: Customizations.bought)?[itemIndex] as! Bool == false {
            itemPriceLabel = SKLabelNode(text: "\(Customizations.price)")
            itemPriceLabel.position = CGPoint(x: itemPriceShape.frame.midX+10, y: itemPriceShape.frame.midY-8)
        }
        else {
            itemPriceLabel = SKLabelNode(text: "Use")
            itemPriceLabel.position = CGPoint(x: itemPriceShape.frame.midX, y: itemPriceShape.frame.midY-8)
        }
        itemPriceLabel.fontSize = 20
        itemPriceLabel.fontName = Fonts.main
        itemPriceLabel.zPosition = 6
        itemPriceLabel.name = "buy"
        addChild(itemPriceLabel)
        
        if UserDefaults.standard.array(forKey: Customizations.bought)?[itemIndex] as! Bool == false {
            itemCoin = SKSpriteNode(texture: SKTexture(imageNamed: Images.coin), size: CGSize(width: 20, height: 20))
            itemCoin.zPosition = 6
            itemCoin.name = "coin"
            itemCoin.position = CGPoint(x: itemPriceShape.frame.minX+15, y: itemPriceShape.frame.midY)
            addChild(itemCoin)
        }
    }
    
    
    func createNextItem() {
        nextItem = SKShapeNode(rectOf: CGSize(width: 0.8*100, height: 0.8*125), cornerRadius: 15)
        nextItem.fillColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
        nextItem.zPosition = 4
        nextItem.name = "next item"
        nextItem.position = CGPoint(x: storeBackground.frame.maxX+75, y: storeBackground.frame.midY)
        addChild(nextItem)
        
        let runnerTexture = Runners.runnerStyle[itemIndex+1]
        nextItemImage = SKSpriteNode(texture: SKTexture(imageNamed: runnerTexture), size: CGSize(width: 0.8*45, height: 0.8*45))
        nextItemImage.position = CGPoint(x: nextItem.frame.midX, y: nextItem.frame.midY+15)
        nextItemImage.zPosition = 5
        addChild(nextItemImage)
        
        nextItemPriceShape = SKShapeNode(rectOf: CGSize(width: 0.8*65, height: 0.8*30), cornerRadius: 15)
        nextItemPriceShape.fillColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.8)
        nextItemPriceShape.position = CGPoint(x: nextItem.frame.midX, y: nextItem.frame.minY+25)
        nextItemPriceShape.zPosition = 5
        addChild(nextItemPriceShape)
        
        if UserDefaults.standard.array(forKey: Customizations.bought)?[itemIndex+1] as! Bool == false {
            nextItemPriceLabel = SKLabelNode(text: "\(Customizations.price)")
            nextItemPriceLabel.position = CGPoint(x: nextItemPriceShape.frame.midX+10, y: nextItemPriceShape.frame.midY-8)
        }
        else {
            nextItemPriceLabel = SKLabelNode(text: "Use")
            nextItemPriceLabel.position = CGPoint(x: nextItemPriceShape.frame.midX, y: nextItemPriceShape.frame.midY-8)
        }
        nextItemPriceLabel.fontSize = 0.8*20
        nextItemPriceLabel.fontName = Fonts.main
        nextItemPriceLabel.zPosition = 6
        addChild(nextItemPriceLabel)
        
        if UserDefaults.standard.array(forKey: Customizations.bought)?[itemIndex+1] as! Bool == false {
            nextItemCoin = SKSpriteNode(texture: SKTexture(imageNamed: Images.coin), size: CGSize(width: 0.8*20, height: 0.8*20))
            nextItemCoin.zPosition = 6
            nextItemCoin.position = CGPoint(x: nextItemPriceShape.frame.minX+15, y: nextItemPriceShape.frame.midY)
            nextItemCoin.name = "next coin"
            addChild(nextItemCoin)
        }
    }
    
    func rightPressed() {
        let duration = 0.5
        let moveItem = SKAction.move(to: CGPoint(x: storeBackground.frame.minX-75, y: storeBackground.frame.midY), duration: duration)
        let shrink = SKAction.scale(by: 1, duration: duration)
        let otherShrink = SKAction.scale(by: 1, duration: duration)
        let itemGroup = SKAction.group([moveItem,shrink])
        
        let moveItemImage = SKAction.move(to: CGPoint(x: storeBackground.frame.minX-75, y: itemImage.position.y), duration: duration)
        let itemImageGroup = SKAction.group([moveItemImage,otherShrink])
        
        let moveItemCoin = SKAction.move(to: CGPoint(x: storeBackground.frame.minX-95, y: itemPriceShape.position.y), duration: duration)
        let itemCoinGroup = SKAction.group([moveItemCoin,otherShrink])
        
        let moveLabelImage = SKAction.move(to: CGPoint(x: storeBackground.frame.minX-72, y: itemPriceLabel.position.y), duration: duration)
        let itemLabelGroup = SKAction.group([moveLabelImage,otherShrink])
        
        let moveItemOther = SKAction.move(to: CGPoint(x: storeBackground.frame.minX-75, y: itemPriceShape.position.y), duration: duration)
        let itemOtherGroup = SKAction.group([moveItemOther,otherShrink])
        
        
        let moveNextItem = SKAction.move(to: CGPoint(x: storeBackground.frame.midX, y: storeBackground.frame.midY), duration: duration)
        let grow = SKAction.scale(by: 1.25, duration: duration)
        let nextItemGroup = SKAction.group([moveNextItem,grow])
        
        let moveImage = SKAction.move(to: itemImage.position, duration: duration)
        let imageGroup = SKAction.group([moveImage,grow])
        
        let moveShape = SKAction.move(to: itemPriceShape.position, duration: duration)
        let shapeGroup = SKAction.group([moveShape,grow])
        
        
        let moveLabel1 = SKAction.move(to: CGPoint(x: itemPriceShape.frame.midX+10, y: itemPriceShape.frame.midY-8), duration: duration)
        let labelGroup1 = SKAction.group([moveLabel1,grow])
        
        let moveCoin1 = SKAction.move(to: CGPoint(x: itemPriceShape.frame.minX+15, y: itemPriceShape.frame.midY), duration: duration)
        let coinGroup1 = SKAction.group([moveCoin1,grow])
        
        let moveLabel2 = SKAction.move(to: CGPoint(x: itemPriceShape.frame.midX, y: itemPriceShape.frame.midY-8), duration: duration)
        let labelGroup2 = SKAction.group([moveLabel2,grow])
        
        
        
        item.run(itemGroup)
        itemImage.run(itemImageGroup)
        if (childNode(withName: "coin") != nil) {
            itemCoin.run(itemCoinGroup)
        }
        itemPriceLabel.run(itemLabelGroup)
        itemPriceShape.run(itemOtherGroup)
        nextItem.run(nextItemGroup) {
            self.itemIndex+=1
            self.removeShopChildren()
            print(self.itemIndex)
            self.createArrows()
            self.createAllItems()
        }
        nextItemImage.run(imageGroup)
        nextItemPriceShape.run(shapeGroup)
        if (childNode(withName: "next coin") != nil) {
            nextItemCoin.run(coinGroup1)
            nextItemPriceLabel.run(labelGroup1)
        }
        else if (childNode(withName: "next coin") == nil){
            nextItemPriceLabel.run(labelGroup2)
        }
        
    }
    
    func leftPressed() {
        let duration = 0.5
        let moveItem = SKAction.move(to: CGPoint(x: storeBackground.frame.maxX+75, y: storeBackground.frame.midY), duration: duration)
        let shrink = SKAction.scale(by: 1, duration: duration)
        let otherShrink = SKAction.scale(by: 1, duration: duration)
        let itemGroup = SKAction.group([moveItem,shrink])
        
        let moveItemImage = SKAction.move(to: CGPoint(x: storeBackground.frame.maxX+75, y: itemImage.position.y), duration: duration)
        let itemImageGroup = SKAction.group([moveItemImage,otherShrink])
        
        let moveLabelImage = SKAction.move(to: CGPoint(x: storeBackground.frame.maxX+82.5, y: itemPriceLabel.position.y), duration: duration)
        let itemLabelGroup = SKAction.group([moveLabelImage,otherShrink])
        
        let moveItemCoin = SKAction.move(to: CGPoint(x: storeBackground.frame.maxX+60, y: itemPriceShape.position.y), duration: duration)
        let itemCoinGroup = SKAction.group([moveItemCoin,otherShrink])
        
        let moveItemOther = SKAction.move(to: CGPoint(x: storeBackground.frame.maxX+75, y: itemPriceShape.position.y), duration: duration)
        let itemOtherGroup = SKAction.group([moveItemOther,otherShrink])
        
        
        let movePreviousItem = SKAction.move(to: CGPoint(x: storeBackground.frame.midX, y: storeBackground.frame.midY), duration: duration)
        let grow = SKAction.scale(by: 1.25, duration: duration)
        let previousItemGroup = SKAction.group([movePreviousItem,grow])
        
        let moveImage = SKAction.move(to: itemImage.position, duration: duration)
        let imageGroup = SKAction.group([moveImage,grow])
        
        let moveShape = SKAction.move(to: itemPriceShape.position, duration: duration)
        let shapeGroup = SKAction.group([moveShape,grow])
        
        
        
        let moveLabel1 = SKAction.move(to: CGPoint(x: itemPriceShape.frame.midX+10, y: itemPriceShape.frame.midY-8), duration: duration)
        let labelGroup1 = SKAction.group([moveLabel1,grow])
        
        let moveCoin1 = SKAction.move(to: CGPoint(x: itemPriceShape.frame.minX+15, y: itemPriceShape.frame.midY), duration: duration)
        let coinGroup1 = SKAction.group([moveCoin1,grow])
        
        let moveLabel2 = SKAction.move(to: CGPoint(x: itemPriceShape.frame.midX, y: itemPriceShape.frame.midY-8), duration: duration)
        let labelGroup2 = SKAction.group([moveLabel2,grow])
        
        
        item.run(itemGroup)
        itemImage.run(itemImageGroup)
        if (childNode(withName: "coin") != nil) {
            itemCoin.run(itemCoinGroup)
        }
        itemPriceLabel.run(itemLabelGroup)
        itemPriceShape.run(itemOtherGroup)
        previousItem.run(previousItemGroup) {
            self.itemIndex-=1
            self.removeShopChildren()
            print(self.itemIndex)
            self.createArrows()
            self.createAllItems()
        }
        previousItemImage.run(imageGroup)
        previousItemPriceShape.run(shapeGroup)
        if (childNode(withName: "previous coin") != nil) {
            previousItemCoin.run(coinGroup1)
            previousItemPriceLabel.run(labelGroup1)
        }
        else if (childNode(withName: "previous coin") == nil){
            previousItemPriceLabel.run(labelGroup2)
        }
    }
    
    func createAllItems() {
        createItem()
        if itemIndex > 0 {
            createPreviousItem()
        }
        if itemIndex < Runners.runnerStyle.count-1 {
            createNextItem()
        }
    }
    
    func removeShopChildren() {
        item.removeFromParent()
        itemImage.removeFromParent()
        itemPriceShape.removeFromParent()
        itemPriceLabel.removeFromParent()
        if (childNode(withName: "coin") != nil) {
            itemCoin.removeFromParent()
        }
        if (childNode(withName: "previous item") != nil) {
            previousItem.removeFromParent()
            previousItemImage.removeFromParent()
            previousItemPriceShape.removeFromParent()
            previousItemPriceLabel.removeFromParent()
            if (childNode(withName: "previous coin") != nil) {
                previousItemCoin.removeFromParent()
            }
        }
        if (childNode(withName: "next item") != nil) {
            nextItem.removeFromParent()
            nextItemImage.removeFromParent()
            nextItemPriceShape.removeFromParent()
            nextItemPriceLabel.removeFromParent()
            if (childNode(withName: "next coin") != nil) {
                nextItemCoin.removeFromParent()
            }
        }
        if (childNode(withName: Images.rightArrow) != nil) {
            storeRightArrow.removeFromParent()
        }
        if (childNode(withName: Images.leftArrow) != nil) {
            storeLeftArrow.removeFromParent()
        }
    }
    
    func purchase() {
        let numCoins = UserDefaults.standard.integer(forKey: ScoreData.coins)-Customizations.price
        var isBought = UserDefaults.standard.array(forKey: Customizations.bought)
        
        if isBought![itemIndex] as! Bool == true {
            UserDefaults.standard.setValue(itemIndex, forKey: Customizations.texture)
            backToMenu()
        }
        else if numCoins > -1 && isBought![itemIndex] as! Bool == false {
            UserDefaults.standard.setValue(itemIndex, forKey: Customizations.texture)
            isBought?[itemIndex] = true
            UserDefaults.standard.setValue(isBought, forKey: Customizations.bought)
            UserDefaults.standard.setValue(numCoins, forKey: ScoreData.coins)
            backToMenu()
        }
        else {
            showAlert(withTitle: "Insufficient Funds", message: "Earn more coins to unlock this runner")
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
    
    func backToMenu() {
        if let view = self.view {
            let menuScene = MenuScene(size: view.bounds.size)
            view.presentScene(menuScene)
        }
    }
}

