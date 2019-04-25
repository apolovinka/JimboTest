//  
//  MainViewController.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 3/13/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum TemplatesAppearanceState {
    case preview
    case full
}

fileprivate let inAnimationDuration: TimeInterval = 0.3
fileprivate let outAnimationDuration: TimeInterval = 0.1

class TemplatesViewController<T:TemplatesViewModelProtocol>: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var themesPickerView: ThemesPickerView?
    @IBOutlet weak var closeButton: UIButton!
    let disposeBag = DisposeBag()

    var viewModel: T!
    var displayDataManager: TemplatesDisplayDataManager!

    private var appearanceState: TemplatesAppearanceState = .preview
    private(set) var collectionViewLayoutConfigurator = CollectionViewLayoutConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.setup()

        self.setupUI()
        self.setupBindings()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateCollectionViewLayout()
    }

    internal func setupUI() {
        self.displayDataManager.setup(collectionView: self.collectionView, listHandler: self.viewModel.listHandler)
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .always
        }
        self.themesPickerView?.delegate = self
        self.themesPickerView?.reloadData()
    }

    internal func setupBindings() {
        
        self.displayDataManager.actions.subscribe(onNext: {
            [unowned self] action in
            self.displayDataManagerActionsHandler(action: action)
        }).disposed(by: self.disposeBag)

        self.viewModel.isActive.bind(to: self.collectionView.rx.isHidden).disposed(by: self.disposeBag)

        Observable.combineLatest(self.viewModel.selectedTemplateVariations, self.viewModel.selectedTemplateName)
            .asObservable()
            .subscribe(onNext: {
            [unowned self] _ in
            self.themesPickerView?.reloadData()
        }).disposed(by: self.disposeBag)

        self.viewModel.error.subscribe(onNext: {
            [unowned self] error in
            ErrorsHandlerHelper.showAlert(withError: error, inViewController: self)
        }).disposed(by: self.disposeBag)
    }

    internal func set(appearanceState: TemplatesAppearanceState, animated: Bool = false) {

        var config: ListCollectionCalculationItem!
        let layout = TemplatesCollectionViewFlowLayout()
        var isThemePickerHidden = true

        switch appearanceState {
        case .preview:
            config = PreviewListCollectionConfiguration()
            layout.scrollDirection = .vertical
            self.collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        case .full:
            config = FullListCollectionConfiguration()
            layout.scrollDirection = .horizontal
            self.collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
            isThemePickerHidden = false
        }

        self.displayDataManager.set(appearanceState: appearanceState)
        self.collectionViewLayoutConfigurator.set(item: config)
        self.collectionViewLayoutConfigurator.calculate(with: UIScreen.main.bounds.size, layout: layout)
        self.collectionView.setCollectionViewLayout(layout, animated: animated)

        self.setThemePicker(hidden: isThemePickerHidden, animated: animated)

        self.appearanceState = appearanceState

    }

    internal func setThemePicker(hidden: Bool, animated: Bool) {
        if !hidden {
            self.themesPickerView?.alpha = 0
            self.themesPickerView?.isHidden = false
            self.themesPickerView?.set(enabled: true)
        }
        let duration = hidden ? outAnimationDuration : inAnimationDuration
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
            self.themesPickerView?.alpha = hidden ? 0 : 1.0
        }, completion: {
            finished in
            if finished {
                self.themesPickerView?.isHidden = hidden
            }
        })

    }

    internal func updateCollectionViewLayout() {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        self.collectionViewLayoutConfigurator.calculate(with: UIScreen.main.bounds.size, layout: layout)
    }

    // MARK: - Actions

    @IBAction func previewButtonAction(_ sender: Any) {
        self.set(appearanceState: .preview, animated: true)
    }

    internal func displayDataManagerActionsHandler(action: TemplatesDisplayDataManager.Action) {
        switch action {
        case .didSelect(index: let index):
            if self.appearanceState == .preview {
                self.viewModel.didSelectItemAction(index: index)
            }
        case .didStartScrolling:
            self.themesPickerView?.set(enabled: false, animated: true)
        case .didEndScrolling(index: let index):
            self.viewModel.didSelectItemAction(index: index)
            self.themesPickerView?.set(enabled: true, animated: true)
        }
    }
}

extension TemplatesViewController : ThemesPickerViewDelegate {

    func items(in themesPickerView: ThemesPickerView) -> [ThemesPickerViewItem] {
        let values = self.viewModel.selectedTemplateVariations.value
        let selectedIndex = values.1
        let items = values.0.map{ThemesPickerViewItem(color: $0.color)}
        themesPickerView.selectedIndex = selectedIndex
        return items
    }

    func nameTitle(in themesPickerView: ThemesPickerView) -> String? {
        return self.viewModel.selectedTemplateName.value
    }

    func didSelectItem(in themesPickerView: ThemesPickerView, at index: Int) {
        guard let itemIndex = self.displayDataManager.selectedIndex else {
            return
        }
        self.viewModel.didSelectVariationAction(index: index, in: itemIndex)
    }

}

