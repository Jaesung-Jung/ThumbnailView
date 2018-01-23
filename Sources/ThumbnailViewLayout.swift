//
//  ThumbnailViewLayout.swift
//
//  Copyright (c) 2018 Jaesung Jung.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

final class ThumbnailViewLayout: UICollectionViewLayout {
    private(set) var layoutAttributes: [ThumbnailViewLayoutAttributes] = []

    var insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12) {
        didSet {
            guard oldValue != insets else {
                return
            }
            invalidateLayout()
        }
    }

    var itemSize = CGSize(width: 32, height: 32) {
        didSet {
            guard oldValue != itemSize else {
                return
            }
            invalidateLayout()
        }
    }

    var itemSpacing: CGFloat = 2 {
        didSet {
            guard oldValue != itemSpacing else {
                return
            }
            invalidateLayout()
        }
    }

    var itemBounds: CGRect {
        guard let first = layoutAttributes.first?.frame, let last = layoutAttributes.last?.frame else {
            return .zero
        }
        return CGRect(
            x: first.minX,
            y: first.minY,
            width: last.maxX - first.minX,
            height: last.maxY - first.minY
        )
    }

    var itemsCount: Int {
        return layoutAttributes.count
    }

    var didFinishPrepareLayout: (() -> Void)?
}

extension ThumbnailViewLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        let numberOfItems = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) ?? 0
        guard numberOfItems > 0 else {
            return
        }

        let bounds = CGRect(
            origin: CGPoint(x: insets.left, y: 0),
            size: collectionViewContentSize
        )
        let maximumItemCount = Int((bounds.width + itemSpacing) / (itemSize.width + itemSpacing))
        let itemsCount = min(maximumItemCount, numberOfItems)
        let estimatedWidth = (CGFloat(itemsCount) * itemSize.width) + (CGFloat(itemsCount) - 1) * itemSpacing
        let contentsSize = CGSize(
            width: min(bounds.width, estimatedWidth),
            height: itemSize.height
        )
        let p = CGPoint(
            x: bounds.minX + (bounds.width - contentsSize.width) * 0.5,
            y: bounds.minY + (bounds.height - contentsSize.height) * 0.5
        )
        layoutAttributes = (0..<itemsCount).map { index in
            let indexPath = IndexPath(item: index, section: 0)
            let thumbnailIndex = Double(numberOfItems - 1)
                / Double(itemsCount - 1)
                * Double(index)
            let attributes = ThumbnailViewLayoutAttributes(forCellWith: indexPath)
            attributes.index = Int(thumbnailIndex)
            attributes.frame = CGRect(
                x: p.x + (CGFloat(index) * itemSize.width) + (CGFloat(index) * itemSpacing),
                y: p.y,
                width: itemSize.width,
                height: itemSize.height
            )
            return attributes
        }

        didFinishPrepareLayout?()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes.first {
            $0.indexPath == indexPath
        }
    }

    override var collectionViewContentSize: CGSize {
        guard var size = collectionView?.bounds.size else {
            return .zero
        }
        size.width = size.width - (insets.left + insets.right)
        return size
    }
}
