//  
//  MainViewController.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/23/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: TemplatesViewController<MainViewModel> {

    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        self.set(appearanceState: .preview)
    }

    override func setupBindings() {
        super.setupBindings()

        self.viewModel.isActive.bind(to: self.activityIndicator.rx.isAnimating).disposed(by: self.disposeBag)
        self.viewModel.isActive.map{!$0}.bind(to: self.activityLabel.rx.isHidden).disposed(by: self.disposeBag)

        self.viewModel.indexUpdate.skip(1).subscribe(onNext: {
            [unowned self] index in
            if self.collectionView.indexPathsForVisibleItems.first(where: {$0.item == index}) == nil {
                let indexPath = IndexPath(item: index, section: 0)
                let position = index > self.viewModel.selectedIndex.value ? UICollectionView.ScrollPosition.bottom : UICollectionView.ScrollPosition.top
                self.collectionView.scrollToItem(at: indexPath, at: position, animated: false)
            }
        }).disposed(by: self.disposeBag)
    }

}

extension MainViewController : AnimatableTransitionViewController {

    var transitionAnimator: TransitionAnimator {
        let config = ZoomTransitionAnimator.AnimatorConfiguration(duration: 0.4)
        return ZoomTransitionAnimator(configuration: config)
    }

}

extension MainViewController : ZoomTransitionAnimatorDataSource {

    var transitionView: UIView {
        let index = self.viewModel.selectedIndex.value
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? TemplateCell else {
            return UIView()
        }
        return cell.viewFromPreviewImage()
    }

    var transitionFrame: CGRect {
        let index = self.viewModel.selectedIndex.value
        let indexPath = IndexPath(item: index, section: 0)
        guard let attributes = self.collectionView.layoutAttributesForItem(at: indexPath) else {
            return CGRect.zero
        }
        let previewImageFrame = TemplateCell.previewImageFrame(for: .preview, fittedIn: attributes.frame.size)
        let convertedFrame = self.collectionView.convert(attributes.frame, to: self.view)
        let origin = CGPoint(x: convertedFrame.origin.x + previewImageFrame.minX, y: convertedFrame.origin.y + previewImageFrame.minY)
        let frame = CGRect(origin: origin, size: previewImageFrame.size)
        return frame
    }

    func willStartZoomAnimation(isPresenting: Bool) {
        DispatchQueue.main.async {
            let index = self.viewModel.selectedIndex.value
            let indexPath = IndexPath(item: index, section: 0)
            (self.collectionView.cellForItem(at: indexPath) as? TemplateCell)?.previewImageAlpha = 0
        }
    }

    func willFinishZoomAnimation(isPresenting: Bool) {
        let index = self.viewModel.selectedIndex.value
        let indexPath = IndexPath(item: index, section: 0)
        (self.collectionView.cellForItem(at: indexPath) as? TemplateCell)?.previewImageAlpha = 1
    }

}
