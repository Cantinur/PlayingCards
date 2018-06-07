//
//  CardBehavior.swift
//  PlayingCards
//
//  Created by Henrik Anthony Odden Sandberg on 6/7/18.
//  Copyright © 2018 Henrik Anthony Odden Sandberg. All rights reserved.
//
// Moved all animation of cards in to this class. Now its only two lines of code in the main ViewController

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    lazy var collitionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()
    
    private func push(_ item:UIDynamicItem){
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        
        //This pushes the cards towards the center
        if let refeneceBounds = dynamicAnimator?.referenceView?.bounds{
            let center = CGPoint(x: refeneceBounds.midX, y: refeneceBounds.midY)
            switch (item.center.x, item.center.y){
            case let (x, y) where x < center.x && y < center.y:
                push.angle = (CGFloat.pi/2).arc4Randum
            case let (x, y ) where x > center.x &&  y < center.y:
                push.angle = CGFloat.pi - (CGFloat.pi/2).arc4Randum
            case let (x, y ) where x < center.x &&  y > center.y:
                push.angle = (-CGFloat.pi/2).arc4Randum
            case let (x, y ) where x > center.x &&  y > center.y:
                push.angle = CGFloat.pi + (CGFloat.pi/2).arc4Randum
            default:
                push.angle = (CGFloat.pi*2).arc4Randum
            }
        }
        
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4Randum
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem){
        collitionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem){
        collitionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collitionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
