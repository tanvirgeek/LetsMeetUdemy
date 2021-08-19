//
//  CardViewController.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 17/8/21.
//

import UIKit
import Shuffle_iOS

class CardViewController: UIViewController,SwipeCardStackDataSource,SwipeCardStackDelegate {
    
    
    let cardStack = SwipeCardStack()
    
    let cardImages = [
        UIImage(named: "user1"),
        UIImage(named: "user2"),
        UIImage(named: "user3")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cardStack)
        cardStack.frame = view.safeAreaLayoutGuide.layoutFrame
        cardStack.dataSource = self
    }
    
    //MARK:- CardFunction
    func card(fromImage image: UIImage) -> SwipeCard {
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
        card.content = UIImageView(image: image)
        
        let leftOverlay = UIView()
        leftOverlay.backgroundColor = .green
        
        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .red
        
        card.setOverlays([.left: leftOverlay, .right: rightOverlay])
        
        return card
    }
    
    //MARK:- swipe card data source
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        return card(fromImage: cardImages[index]!)
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return cardImages.count
    }
    
}
