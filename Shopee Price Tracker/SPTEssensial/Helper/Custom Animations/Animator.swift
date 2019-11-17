//
//  Animator.swift
//  Shopee Prices Analystic
//
//  Created by Minh Pham on 7/19/19.
//  Copyright © 2019 SAPO. All rights reserved.
//

import UIKit

typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void

final class Animator {
    private var hasAnimatedAllCells = false
    private var animation: Animation
    
    init(animation: @escaping Animation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }
        
        animation(cell, indexPath, tableView)
        if tableView.visibleCells.last == tableView.cellForRow(at: indexPath) {
            hasAnimatedAllCells = true
        }
    }
    
}

enum AnimationFactory {
    static func makeFadeAnimation(duration: TimeInterval, delayFactor: Double) -> Animation {
        return {(cell, indexPath, _) in
            cell.alpha = 0
            
            UIView.animate(withDuration: duration, delay: delayFactor * Double(indexPath.row), animations: {
                            cell.alpha = 1
            })
            
        }
    }
    
    static func makeMoveUpWithFade(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
        return { cell, indexPath, _ in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight / 2)
            cell.alpha = 0
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: .curveEaseInOut,
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1
            })
        }
    }
}
