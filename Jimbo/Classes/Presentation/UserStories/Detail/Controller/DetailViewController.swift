//  
//  DetailViewController.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/23/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: TemplatesViewController<DetailViewModel> {

    private var contentOffsetCache = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        self.collectionView.showsHorizontalScrollIndicator = false
        self.set(appearanceState: .full)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if animated {
            self.closeButton.alpha = 0
            self.themesPickerView?.alpha = 0
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.closeButton.alpha = 1
            self.themesPickerView?.alpha = 1
        }, completion: nil)

    }

    override func setupBindings() {
        super.setupBindings()
        
        self.viewModel.selectedIndex.take(1).subscribe(onNext: {
            [unowned self] index in
            let indexPath = IndexPath(item: index, section: 0)
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                self.themesPickerView?.reloadData()
            }
        }).disposed(by: self.disposeBag)
        
    }

    /// Fetch currently visible indexPath from the center of a collection view
    private func currentIndexPath() -> IndexPath? {

        let spaceBetweenCells: CGFloat = (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0
        let contentOffset = CGPoint(x: self.collectionView.contentOffset.x + self.collectionView.center.x, y: self.collectionView.center.y)

        func indexPathAt(point: CGPoint) -> IndexPath? {
            return self.collectionView.indexPathForItem(at: point)
        }

        let offsets: [CGFloat] = spaceBetweenCells != 0 ? [0, -spaceBetweenCells, spaceBetweenCells] : [0]

        var result: IndexPath?
        for (_, offset) in offsets.enumerated() {
            let point = CGPoint(x: contentOffset.x + offset, y: contentOffset.y)
            if let indexPath = indexPathAt(point: point) {
                result = indexPath
                break
            }
        }
        return result
    }

    @IBAction func closeButtonAction(_ sender: Any) {

        // Force to stop animating
        self.collectionView.setContentOffset(self.collectionView.contentOffset, animated: false)

        DispatchQueue.main.async {
            self.contentOffsetCache = self.collectionView.contentOffset
            if let indexPath = self.currentIndexPath() {
                self.viewModel.didSelectItemAction(index: indexPath.item)
            }
            self.viewModel.closeAction()
        }
    }
}

extension DetailViewController : AnimatableTransitionViewController {

    var transitionAnimator: TransitionAnimator {
        let config = ZoomTransitionAnimator.AnimatorConfiguration(duration: 0.3)
        return ZoomTransitionAnimator(configuration: config)
    }

}

extension DetailViewController : ZoomTransitionAnimatorDataSource {

    var transitionView: UIView {
        let index = self.viewModel.selectedIndex.value
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? TemplateCell else {
            return UIView()
        }
        return cell.viewFromPreviewImage()
    }

    var transitionFrame: CGRect {

        let itemSize = self.collectionViewLayoutConfigurator.item.itemSize
        let imageViewFrame = TemplateCell.previewImageFrame(for: .full, fittedIn: itemSize)
        var topPadding: CGFloat = 1.0

        if self.collectionView.contentOffset.y != 0 {
            topPadding = self.collectionView.frame.minY + self.collectionView.contentOffset.y
        }

        var x: CGFloat = 0

        let contentOffset = self.collectionView.contentOffset
        if let indexPath = self.currentIndexPath(),
            let attributes = self.collectionView.layoutAttributesForItem(at: indexPath) {
            let convertedOrigin = CGPoint(x: attributes.frame.minX - contentOffset.x, y: attributes.frame.minY)
            let origin = CGPoint(x: convertedOrigin.x + imageViewFrame.minX, y: convertedOrigin.y + imageViewFrame.minY)
            x = origin.x
        } else {
            x = (self.view.frame.width - imageViewFrame.width)/2
        }
        let y: CGFloat = ((self.view.frame.height - imageViewFrame.height) / 2 - self.collectionView.frame.minY/2) + topPadding
        let origin = CGPoint(x: x, y: y)
        return CGRect(origin: origin, size: imageViewFrame.size)
    }

    var backgroundColor: UIColor? {
        return self.collectionView.backgroundColor
    }

    func willStartZoomAnimation(isPresenting: Bool) {
        guard !isPresenting else {
            return
        }
        DispatchQueue.main.async {
            let index = self.viewModel.selectedIndex.value
            let indexPath = IndexPath(item: index, section: 0)
            let cell = (self.collectionView.cellForItem(at: indexPath) as? TemplateCell)
            cell?.previewImageAlpha = 0
        }
    }

    func willFinishZoomAnimation(isPresenting: Bool) { }
}
