//
//  TemplateCell.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/16/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import PureLayout

class TemplateCell: UICollectionViewCell, CellViewModelContainer, ReusableCell {

    struct Configurations {
        static let imageAspectRatio: CGFloat = 1.775
        static let nameLabelTopPadding: CGFloat = 5.0
        static let nameLabelHeight: CGFloat = 18.0
    }
    
    var viewModel: TemplateCellViewModel?

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!

    var appearenceState: TemplatesAppearanceState = .preview

    override func awakeFromNib() {
        super.awakeFromNib()

        self.previewImageView.layer.borderColor = UIColor(white: 0.1, alpha: 0.2).cgColor
        self.previewImageView.layer.borderWidth = 1.0/UIScreen.main.scale
        self.previewImageView.layer.cornerRadius = 2.0
        self.previewImageView.backgroundColor = UIColor(white: 0.95, alpha: 1)

        self.shadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowView.layer.shadowRadius = 6.0
        self.shadowView.layer.shadowOpacity = 0.6

        self.clipsToBounds = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.nameLabel.text = ""
        self.previewImageView.image = nil
        self.activityIndicator.stopAnimating()
        self.refreshUI()
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.layoutIfNeeded()
    }

    override func didTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
        super.didTransition(from: oldLayout, to: newLayout)
        self.refresh()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.refreshUI()
    }

    // MARK: - Subviews framing logic

    private func refreshUI() {

        self.nameLabel.alpha = self.appearenceState == .preview ? 1.0 : 0
        self.refreshPreviewImageFrame()
        self.refreshNameLabelFrame()
        self.refreshShadowViewFrame()
    }

    private func refreshPreviewImageFrame() {

        let nameLabelTopPadding = self.appearenceState == .preview ? Configurations.nameLabelTopPadding : 0
        let imageHeight = self.frame.height - Configurations.nameLabelHeight - nameLabelTopPadding
        let imageWidth = imageHeight / Configurations.imageAspectRatio
        let imageSize = CGSize(width: imageWidth, height: imageHeight)
        let imageOrigin = CGPoint(x: (self.frame.width-imageWidth)/2, y: 0)
        var frame = self.previewImageView.frame
        frame.size = imageSize
        frame.origin = imageOrigin
        self.previewImageView.frame = frame

        var activityFrame = self.activityIndicator.frame
        activityFrame.origin = CGPoint(x: frame.midX-activityFrame.width/2, y: frame.midY-activityFrame.height/2)
        self.activityIndicator.frame = activityFrame
    }

    private func refreshNameLabelFrame() {
        var nameLabelFrame = self.nameLabel.frame
        nameLabelFrame.origin = CGPoint(x: (self.bounds.width - nameLabelFrame.width)/2, y: self.previewImageView.frame.height + Configurations.nameLabelTopPadding)
        nameLabelFrame.size = CGSize(width: nameLabelFrame.width, height: Configurations.nameLabelHeight)
        self.nameLabel.frame = nameLabelFrame
    }

    private func refreshShadowViewFrame() {
        self.shadowView.frame = self.previewImageView.frame

        // An animation required for setting the shadowPath, otherwise the shadow frame changes choppy
        let animation = CABasicAnimation(keyPath: "shadowPath")
        animation.duration = UIView.inheritedAnimationDuration
        animation.fromValue = self.shadowView.layer.shadowPath
        animation.toValue = UIBezierPath(rect: self.previewImageView.bounds.insetBy(dx: -1.0, dy: -1.0)).cgPath
        self.shadowView.layer.add(animation, forKey: "shadow")
    }

    // MARK: - View Model Output

    func refresh() {
        
        self.nameLabel.text = self.viewModel?.name
        self.nameLabel.sizeToFit()
        self.refreshNameLabelFrame()

        if self.viewModel?.isLoading ?? false {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }

        if let urlString = self.viewModel?.imageURLString, let url = URL(string: urlString) {
            let scale = UIScreen.main.scale
            let size = CGSize(width: self.previewImageView.frame.size.width * scale, height: self.previewImageView.frame.size.height * scale)
            let pocessor = ResizingImageProcessor(referenceSize: size, mode: .aspectFit)
            let placeholder = self.previewImageView.image
            self.previewImageView.kf.setImage(with: url, placeholder: placeholder, options: [.processor(pocessor), .transition(.fade(0.2))])
        }
    }

}
