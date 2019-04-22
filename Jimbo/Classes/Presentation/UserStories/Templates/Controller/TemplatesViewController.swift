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

class TemplatesViewController: UIViewController {

    static let inAnimationDuration: TimeInterval = 0.3
    static let outAnimationDuration: TimeInterval = 0.1

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var themesPickerView: ThemesPickerView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var closeButtonTopConstraint: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()

    var viewModel: TemplatesViewModel!
    var displayDataManager: TemplatesDisplayDataManager!

    private var appearanceState: TemplatesAppearanceState = .preview

    private var collectionViewLayoutConfigurator = CollectionViewLayoutConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.setup()

        self.setupUI()
        self.setupBindings()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateCollectionViewLayout()

        if #available(iOS 11.0, *), self.view.safeAreaInsets.top != 0 {
            self.closeButtonTopConstraint.constant = 10.0
        }
    }

    private func setupUI() {
        self.displayDataManager.setup(collectionView: self.collectionView, listHandler: self.viewModel.listHandler)
        self.set(appearanceState: .preview)
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .always
        }
        self.collectionView.showsHorizontalScrollIndicator = false
        self.themesPickerView.delegate = self
        self.themesPickerView.reloadData()
    }

    private func setupBindings() {
        
        self.displayDataManager.actions.subscribe(onNext: {
            [unowned self] action in
            self.displayDataManagerActionsHandler(action: action)
        }).disposed(by: self.disposeBag)

        self.viewModel.isActive.bind(to: self.collectionView.rx.isHidden).disposed(by: self.disposeBag)
        self.viewModel.isActive.bind(to: self.activityIndicator.rx.isAnimating).disposed(by: self.disposeBag)
        self.viewModel.isActive.map{!$0}.bind(to: self.activityLabel.rx.isHidden).disposed(by: self.disposeBag)

        Observable.combineLatest(self.viewModel.selectedTemplateVariations, self.viewModel.selectedTemplateName)
            .asObservable()
            .subscribe(onNext: {
            [unowned self] _ in
            self.themesPickerView.reloadData()
        }).disposed(by: self.disposeBag)

        self.viewModel.error.subscribe(onNext: {
            [unowned self] error in
            ErrorsHandlerHelper.showAlert(withError: error, inViewController: self)
        }).disposed(by: self.disposeBag)
    }

    private func fixCellsZIndex(topIndex: Int) {
        let topCell = self.collectionView.cellForItem(at: IndexPath(item: topIndex, section: 0))
        topCell?.layer.zPosition = CGFloat(self.collectionView.numberOfItems(inSection: 0))
    }

    private func set(appearanceState: TemplatesAppearanceState, animated: Bool = false) {

        var config: ListCollectionCalculationItem!
        let layout = TemplatesCollectionViewFlowLayout()
        var isPreviewButtonHidden = true
        var isThemePickerHidden = true

        switch appearanceState {
        case .preview:
            config = PreviewListCollectionConfiguration()
            layout.scrollDirection = .vertical
            self.collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        case .full:
            config = FullListCollectionConfiguration()
            layout.scrollDirection = .horizontal
            self.collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
            isPreviewButtonHidden = false
            isThemePickerHidden = false
        }

        self.displayDataManager.set(appearanceState: appearanceState)
        self.collectionViewLayoutConfigurator.set(item: config)
        self.collectionViewLayoutConfigurator.calculate(with: UIScreen.main.bounds.size, layout: layout)
        self.collectionView.setCollectionViewLayout(layout, animated: animated)

        self.setPreviewButton(hidden: isPreviewButtonHidden, animated: animated)
        self.setThemePicker(hidden: isThemePickerHidden, animated: animated)

        self.appearanceState = appearanceState

    }

    private func setPreviewButton(hidden: Bool, animated: Bool = false) {

        if !hidden {
            self.previewButton.alpha = 0
            self.previewButton.isHidden = false
        }
        let duration = hidden ? TemplatesViewController.outAnimationDuration : TemplatesViewController.inAnimationDuration
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
            self.previewButton.alpha = hidden ? 0 : 1.0
        }, completion: {
            finished in
            if finished {
                self.previewButton.isHidden = hidden
            }
        })
    }

    private func setThemePicker(hidden: Bool, animated: Bool) {
        if !hidden {
            self.themesPickerView.alpha = 0
            self.themesPickerView.isHidden = false
            self.themesPickerView.set(enabled: true)
        }
        let duration = hidden ? TemplatesViewController.outAnimationDuration : TemplatesViewController.inAnimationDuration
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
            self.themesPickerView.alpha = hidden ? 0 : 1.0
        }, completion: {
            finished in
            if finished {
                self.themesPickerView.isHidden = hidden
            }
        })

    }

    private func updateCollectionViewLayout() {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        self.collectionViewLayoutConfigurator.calculate(with: UIScreen.main.bounds.size, layout: layout)
    }

    // MARK: - Actions

    @IBAction func previewButtonAction(_ sender: Any) {
        self.set(appearanceState: .preview, animated: true)
    }

    private func displayDataManagerActionsHandler(action: TemplatesDisplayDataManager.Action) {
        switch action {
        case .didSelect(index: let index):
            self.fixCellsZIndex(topIndex: index)
            if self.appearanceState == .preview {
                self.set(appearanceState: .full, animated: true)
                self.viewModel.didSelectItemAction(index: index)
            }
        case .didStartScrolling:
            self.themesPickerView.set(enabled: false, animated: true)
        case .didEndScrolling(index: let index):
            self.viewModel.didSelectItemAction(index: index)
            self.themesPickerView.set(enabled: true, animated: true)
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

