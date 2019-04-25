//
//  BaseNavigationController.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/24/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

class BaseNavigationController : UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

extension BaseNavigationController : UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        guard let transitionAnimatorProvider = fromVC as? AnimatableTransitionViewController else {
            return nil
        }

        let transitionAnimator = transitionAnimatorProvider.transitionAnimator
        transitionAnimator.isPresenting = operation == .push ? true : false
        
        return transitionAnimator
    }

}
