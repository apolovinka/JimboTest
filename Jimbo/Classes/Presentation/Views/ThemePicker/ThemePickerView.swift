//
//  ThemePickerView.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/22/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

protocol ThemesPickerViewDelegate : class {
    func nameTitle(in themesPickerView: ThemesPickerView) -> String?
    func items(in themesPickerView: ThemesPickerView) -> [ThemesPickerViewItem]
    func didSelectItem(in themesPickerView: ThemesPickerView, at index: Int)
}

struct ThemesPickerViewItem {
    let color: UIColor
}

private struct Configuration {
    static let pickerItemWidth: CGFloat = 35.0
    static let pickerItemMaxSpace: CGFloat = 8.0
    static let selectionIndicatorWidth: CGFloat = 3.0
    static let selectionIndicatorTopPadding: CGFloat = 6.0
}

class ThemesPickerView: UIView {

    enum Action {
        case didSelect(index: String)
    }

    @IBOutlet weak var nameLabel: UILabel!

    weak var delegate: ThemesPickerViewDelegate?
    var selectedIndex: Int = 0

    private var buttonImages : (normal: UIImage, selected: UIImage)!
    private var buttons = [UIButton]()
    private var selectionIndicatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    private func setupUI () {

        let size = CGSize(width: Configuration.pickerItemWidth, height: Configuration.pickerItemWidth)
        let selectedConfig = Drawings.CircleImageConfiguration(size: size,
                                                               inset: 6.0,
                                                               outterCircleWidth: 0,
                                                               outterCirclePaddingWidth: 0,
                                                               color: UIColor.gray)
        let selectedImage = Drawings.circleImage(with: selectedConfig)?.withRenderingMode(.alwaysTemplate)

        let normalConfig = Drawings.CircleImageConfiguration(size: size,
                                                             inset: 25.0,
                                                             outterCircleWidth: 0,
                                                             outterCirclePaddingWidth: 0,
                                                             color: UIColor.gray)
        let normalImage = Drawings.circleImage(with: normalConfig)?.withRenderingMode(.alwaysTemplate)

        if let normalImage = normalImage, let selectedImage = selectedImage {
            self.buttonImages = (normalImage, selectedImage)
        }

        self.selectionIndicatorView = UIView()
        self.selectionIndicatorView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        self.selectionIndicatorView.layer.cornerRadius = Configuration.selectionIndicatorWidth/2
        self.selectionIndicatorView.frame = CGRect(origin: CGPoint.zero,
                                                   size: CGSize(width: Configuration.selectionIndicatorWidth,
                                                                height: Configuration.selectionIndicatorWidth))
        self.selectionIndicatorView.isHidden = true
        self.selectionIndicatorView.isUserInteractionEnabled = false
        self.addSubview(self.selectionIndicatorView)

    }

    private func buildItems() {

        let items = self.delegate?.items(in: self) ?? []

        for (idx, item) in items.enumerated() {

            var button : UIButton
            if idx >= self.buttons.count {

                button = UIButton(type: .custom)
                button.setImage(self.buttonImages.normal, for: .normal)
                button.setImage(self.buttonImages.selected, for: .selected)
                button.setImage(self.buttonImages.selected, for: [.highlighted, .selected])
                button.adjustsImageWhenHighlighted = false
                button.backgroundColor = UIColor.black.withAlphaComponent(0.05)
                button.tag = idx
                button.addTarget(self, action: #selector(self.pickerButtonAction(sender:)), for: .touchUpInside)
                button.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
                button.layer.shadowOffset = CGSize(width: 0, height: 0)
                button.layer.shadowRadius = 5.0
                button.layer.shadowOpacity = 1.0

                self.addSubview(button)
                self.buttons.append(button)
            } else {
                button = self.buttons[idx]
                button.isHidden = false
            }

            button.tintColor = item.color
        }

        if self.buttons.count > items.count {
            for i in (items.count)..<self.buttons.count {
                self.buttons[i].isHidden = true
            }
        }

        if let button = self.buttons.filter({$0.tag == self.selectedIndex}).first {
            self.select(button: button)
        }

        self.selectionIndicatorView.isHidden = items.isEmpty
        
        self.setNeedsLayout()
    }

    private func select(button: UIButton) {
        for btn in self.buttons {
            if btn.isHidden {
                continue
            }
            if btn != button {
                btn.isSelected = false
            }
        }
        button.isSelected = true
        self.updateSelectionIndicator(for: button)
    }

    private func updateSelectionIndicator(for button: UIButton) {
        self.selectionIndicatorView.center = CGPoint(x: button.center.x, y: button.frame.maxY + Configuration.selectionIndicatorTopPadding)
        self.selectionIndicatorView.isHidden = false
    }

    private func layoutButtons() {

        let yOffset: CGFloat = ((self.frame.height - self.nameLabel.frame.maxY) - Configuration.pickerItemWidth)/2 + self.nameLabel.frame.maxY
        let width = self.frame.width

        let buttons = self.buttons.enumerated().filter{!$1.isHidden}.map{$1}
        let buttonsWidth = CGFloat(buttons.count) * (Configuration.pickerItemWidth + Configuration.pickerItemMaxSpace) - Configuration.pickerItemMaxSpace
        let rightInset = (width - buttonsWidth)/2

        for (idx, button) in self.buttons.enumerated() {
            if button.isHidden {
                continue
            }
            let size = CGSize(width: Configuration.pickerItemWidth, height: Configuration.pickerItemWidth)
            let xOffset = rightInset + CGFloat(idx) * (size.width + Configuration.pickerItemMaxSpace)
            let origin = CGPoint(x: xOffset, y: yOffset)
            button.layer.cornerRadius = size.width/2
            button.frame = CGRect(origin: origin, size: size)
            if button.isSelected {
                self.updateSelectionIndicator(for: button)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutButtons()
    }

    // MARK: - Actions

    @objc private func pickerButtonAction(sender: UIButton) {
        self.select(button: sender)
        self.delegate?.didSelectItem(in: self, at: sender.tag)
    }

    // MARK: - Input

    func reloadData() {
        self.buildItems()
        self.nameLabel.text = self.delegate?.nameTitle(in: self)
    }

    func set(enabled: Bool, animated: Bool = false) {
        let subviews = self.subviews
        let duration = animated ? 0.3 : 0
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut, .allowUserInteraction], animations: {
            for view in subviews {
                view.alpha = enabled ? 1.0 : 0.2
                view.isUserInteractionEnabled = enabled
            }
        }, completion: nil)
    }
}
