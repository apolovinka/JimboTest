//
//  AnimatableTransitionViewController.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/24/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

protocol TransitionAnimator: class, UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool { get set }
}

protocol AnimatableTransitionViewController {
    var transitionAnimator: TransitionAnimator { get }
}
