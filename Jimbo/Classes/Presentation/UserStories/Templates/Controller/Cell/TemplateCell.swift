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

class TemplateCell: UICollectionViewCell, CellViewModelContainer, ReusableCell {

    struct Configurations {
        static let imageAspectRatio: CGFloat = 1.775
        static let nameLabelTopPadding: CGFloat = 5.0
        static let nameLabelHeight: CGFloat = 18.0
        static let animationScale: CGFloat = 0.95
    }
    
    var viewModel: TemplateCellViewModel?

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var reloadButton: UIButton!

    var previewImageAlpha: CGFloat = 1.0 {
        didSet {
            self.previewImageView.alpha = self.previewImageAlpha
            self.shadowView.alpha = self.previewImageAlpha
        }
    }
    
    var appearenceState: TemplatesAppearanceState = .preview

    override func awakeFromNib() {
        super.awakeFromNib()

        self.previewImageView.layer.borderColor = UIColor(white: 0.1, alpha: 0.2).cgColor
        self.previewImageView.layer.borderWidth = 1.0/UIScreen.main.scale
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

    private func setActivityIndicator(hidden: Bool) {
        if hidden {
            self.activityIndicator.stopAnimating()
        } else {
            self.activityIndicator.startAnimating()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            guard self.appearenceState == .preview else {
                return
            }
            UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                var scale: CGFloat = 1.0
                if self.isHighlighted {
                    scale = Configurations.animationScale
                }
                let transform = CGAffineTransform.init(scaleX: scale, y: scale)
                self.previewImageView.transform = transform
                self.shadowView.transform = transform
            }, completion: nil)
        }
    }

    // MARK: - Actions

    @IBAction func reloadButtonAction() {
        self.viewModel?.reloadAction()
    }

    // MARK: - Subviews framing logic

    private func refreshUI() {

        self.nameLabel.alpha = self.appearenceState == .preview ? 1.0 : 0
        self.refreshPreviewImageFrame()
        self.refreshNameLabelFrame()
        self.refreshShadowViewFrame()
        self.refreshReloadButtonFrame()
    }

    private func refreshPreviewImageFrame() {
        self.previewImageView.frame = TemplateCell.previewImageFrame(for: self.appearenceState, fittedIn: self.frame.size)
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


    private func refreshReloadButtonFrame() {
        self.reloadButton.center = self.previewImageView.center
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

        self.setActivityIndicator(hidden: !(self.viewModel?.isLoading ?? false))
        self.reloadButton.isHidden = !(self.viewModel?.shouldReload ?? false)

        if let urlString = self.viewModel?.imageURLString, let url = URL(string: urlString) {
            let scale = UIScreen.main.scale
            let size = CGSize(width: self.previewImageView.frame.size.width * scale, height: self.previewImageView.frame.size.height * scale)
            let pocessor = ResizingImageProcessor(referenceSize: size, mode: .aspectFit)
            let placeholder = self.previewImageView.image
            self.previewImageView.kf.setImage(with: url, placeholder: placeholder, options: [.processor(pocessor), .transition(.fade(0.2))])
        }
    }

}

extension TemplateCell  {

    class func previewImageFrame(for appearenceState: TemplatesAppearanceState, fittedIn size: CGSize) -> CGRect {
        let nameLabelTopPadding = appearenceState == .preview ? Configurations.nameLabelTopPadding : 0
        let imageHeight = size.height - Configurations.nameLabelHeight - nameLabelTopPadding
        let imageWidth = imageHeight / Configurations.imageAspectRatio
        let imageSize = CGSize(width: imageWidth, height: imageHeight)
        let imageOrigin = CGPoint(x: (size.width - imageWidth)/2, y: 0)
        return CGRect(origin: imageOrigin, size: imageSize)
    }

    func viewFromPreviewImage() -> UIView {
        let image = self.previewImageView.image
        let imageView = UIImageView(image: image)
        imageView.frame = self.previewImageView.bounds
        imageView.contentMode = self.previewImageView.contentMode
        imageView.layer.shadowPath = self.shadowView.layer.shadowPath
        imageView.layer.shadowColor = self.shadowView.layer.shadowColor
        imageView.layer.shadowOffset = self.shadowView.layer.shadowOffset
        imageView.layer.shadowRadius = self.shadowView.layer.shadowRadius
        imageView.layer.shadowOpacity = self.shadowView.layer.shadowOpacity
        imageView.layer.borderColor = self.previewImageView.layer.borderColor
        imageView.layer.borderWidth = self.previewImageView.layer.borderWidth
        return imageView
    }

}
