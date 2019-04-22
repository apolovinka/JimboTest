//
//  TemplatesCollectionViewFlowLayout.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/22/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import UIKit

class TemplatesCollectionViewFlowLayout : UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        if self.scrollDirection == .horizontal {

            // Page width used for estimating and calculating paging.
            let pageWidth = self.itemSize.width + self.minimumLineSpacing

            // Make an estimation of the current page position.
            let approximatePage = self.collectionView!.contentOffset.x/pageWidth

            // Determine the current page based on velocity.
            let currentPage = (velocity.x < 0.0) ? floor(approximatePage) : velocity.x == 0 ? round(approximatePage) : ceil(approximatePage)

            // Create custom flickVelocity.
            let flickVelocity = velocity.x * 0.3

            // Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
            let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)

            // Calculate newHorizontalOffset.
            let newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - self.collectionView!.contentInset.left

            return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)

        }

        return proposedContentOffset
    }

}
