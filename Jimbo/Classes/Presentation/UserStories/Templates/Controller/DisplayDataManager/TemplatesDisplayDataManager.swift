//
//  TemplatesDisplayDataManager.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/16/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Swinject

fileprivate extension UpdateAction {
    var isInitial: Bool {
        switch self {
        case .initial:
            return true
        default:
            return false
        }
    }
}

class TemplatesDisplayDataManager : NSObject  {

    enum Action {
        case didSelect(index: Int)
        case didStartScrolling
        case didEndScrolling(index: Int)
    }

    let cellIdentifier = "TemplateCell"

    let cellViewModelFactory: CellViewModelConfigurator

    private (set) var collectionView: UICollectionView!
    private (set) var listHandler: ListHandler<TemplateRM>!
    let actions = PublishRelay<Action>()
    var selectedIndex : Int? {
        let rect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: rect.midX, y: rect.midY)
        if let indexPath = self.collectionView.indexPathForItem(at: visiblePoint), self.appearanceState == .full {
            return indexPath.item
        }
        return nil
    }

    private var appearanceState: TemplatesAppearanceState = .preview

    init(cellViewModelFactory: CellViewModelConfigurator) {
        self.cellViewModelFactory = cellViewModelFactory
        super.init()
    }

    func setup(collectionView: UICollectionView, listHandler: ListHandler<TemplateRM>) {
        self.collectionView = collectionView
        self.listHandler = listHandler
        self.setup()
    }

    private func setup() {

        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        let cellIdentifier = TemplateCell.cellIdentifier
        self.collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)

        self.listHandler.updateHandler = {
            [unowned self] action in
            if action.isInitial {
                self.collectionView.reloadData()
            } else {
                self.collectionView.performBatchUpdates({
                    switch action {
                    case .deletions(let indexes):
                        self.collectionView.deleteItems(at: indexes.map{IndexPath(item: $0, section: 0)})
                    case .insertions(let indexes):
                        self.collectionView.insertItems(at: indexes.map{IndexPath(item: $0, section: 0)})
                    case .modifications(let indexes):
                        self.collectionView.reloadItems(at: indexes.map{IndexPath(item: $0, section: 0)})
                    default: break
                    }
                }, completion: nil)
            }
        }
        self.collectionView.reloadData()
    }

    func set(appearanceState: TemplatesAppearanceState) {
        self.appearanceState = appearanceState
        guard let visibleCells = self.collectionView.visibleCells as? [TemplateCell] else {
            return
        }
        for cell in visibleCells {
            cell.appearenceState = appearanceState
        }
    }
}

extension TemplatesDisplayDataManager : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.actions.accept(.didSelect(index: indexPath.item))
    }

    // Cell appearance state fix
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? TemplateCell)?.appearenceState = self.appearanceState
        cell.setNeedsLayout()
    }

}

extension TemplatesDisplayDataManager : UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listHandler.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.listHandler.items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! TemplateCell
        self.cellViewModelFactory.resolveViewModel(for: cell, item: item)
        cell.appearenceState = self.appearanceState
        return cell
    }
}

extension TemplatesDisplayDataManager : UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard self.appearanceState == .full else {
            return
        }
        self.actions.accept(.didStartScrolling)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard self.appearanceState == .full else {
            return
        }
        self.actions.accept(.didEndScrolling(index: self.selectedIndex ?? 0))
    }

    // scrollViewDidEndDecelerating fix
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }

}
