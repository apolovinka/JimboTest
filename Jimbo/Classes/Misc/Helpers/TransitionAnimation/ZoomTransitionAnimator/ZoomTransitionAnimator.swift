//
//  ZoomTransitionAnimator.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/24/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

protocol ZoomTransitionAnimatorDataSource {
    var transitionView: UIView { get }
    var transitionFrame: CGRect { get }
    var backgroundColor: UIColor? { get }
    func willStartZoomAnimation(isPresenting: Bool)
    func willFinishZoomAnimation(isPresenting: Bool)
}

extension ZoomTransitionAnimatorDataSource {
    var backgroundColor: UIColor? {
        return nil
    }
}

class ZoomTransitionAnimator: NSObject, TransitionAnimator {

    var isPresenting: Bool = false

    struct AnimatorConfiguration {
        let duration: TimeInterval
    }

    let configuration: AnimatorConfiguration

    init(configuration: AnimatorConfiguration) {
        self.configuration = configuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let container = transitionContext.containerView

        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to),
            let fromDataProvider = transitionContext.viewController(forKey: .from) as? ZoomTransitionAnimatorDataSource,
            let toDataProvider = transitionContext.viewController(forKey: .to) as? ZoomTransitionAnimatorDataSource
        else {
            return
        }

        toDataProvider.willStartZoomAnimation(isPresenting: self.isPresenting)
        fromDataProvider.willStartZoomAnimation(isPresenting: self.isPresenting)

        toView.alpha = self.isPresenting ? 0 : 1.0

        if self.isPresenting {
            container.addSubview(toView)
        } else {
            container.addSubview(toView)
            container.addSubview(fromView)
        }

        var backgroundView: UIView?

        if let color = toDataProvider.backgroundColor ?? fromDataProvider.backgroundColor, self.isPresenting {
            let view = UIView(frame: container.bounds)
            view.backgroundColor = color
            view.alpha = 0
            container.addSubview(view)
            backgroundView = view
        }

        let fromFrame = fromDataProvider.transitionFrame
        let toFrame = toDataProvider.transitionFrame

        let transitionView = fromDataProvider.transitionView
        transitionView.frame = fromFrame
        container.addSubview(transitionView)

        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = toDataProvider.backgroundColor ?? fromDataProvider.backgroundColor
        container.addSubview(statusBarView)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            transitionView.frame = toFrame
            if !self.isPresenting {
                fromView.alpha = 0
            }
            backgroundView?.alpha = self.isPresenting ? 1.0 : 0
        }) { _ in
            toDataProvider.willFinishZoomAnimation(isPresenting: self.isPresenting)
            fromDataProvider.willFinishZoomAnimation(isPresenting: self.isPresenting)

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionView.removeFromSuperview()
            backgroundView?.removeFromSuperview()

            toView.alpha = 1
        }

//        UIView.animate(withDuration: transitionDuration(using: transitionContext),
//                       delay: 0,
//                       options: [.allowUserInteraction, .allowAnimatedContent, .beginFromCurrentState, .curveEaseInOut],
//                       animations: {
//                        transitionView.frame = toFrame
//                        if !self.isPresenting {
//                            fromView.alpha = 0
//                        }
//                        backgroundView?.alpha = self.isPresenting ? 1.0 : 0
//
//        }, completion: {
//            finished in
//
//            toDataProvider.willFinishZoomAnimation(isPresenting: self.isPresenting)
//            fromDataProvider.willFinishZoomAnimation(isPresenting: self.isPresenting)
//
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            transitionView.removeFromSuperview()
//            backgroundView?.removeFromSuperview()
//
//            toView.alpha = 1
//        })

    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.configuration.duration
    }

}
