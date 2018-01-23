//
//  ThumbnailView.swift
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

public final class ThumbnailView: UIControl {
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ThumbnailViewLayout()
    )

    private let selectionView = UIImageView()

    private var layout: ThumbnailViewLayout {
        return collectionView.collectionViewLayout as! ThumbnailViewLayout
    }

    private var selectionBegin: CGPoint?
    private var trackingBegin: CGPoint?

    var selectionSize: CGSize {
        let multiplier: CGFloat = 1.3
        return CGSize(
            width: (itemSize.width * multiplier).rounded(.toNearestOrAwayFromZero),
            height: (itemSize.height * multiplier).rounded(.toNearestOrAwayFromZero)
        )
    }

    public var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex != oldValue {
                updateSelectionView()
            }
        }
    }

    @IBInspectable
    public var itemSize: CGSize {
        get { return layout.itemSize }
        set { layout.itemSize = newValue }
    }

    @IBInspectable
    public var itemSpacing: CGFloat {
        get { return layout.itemSpacing }
        set { layout.itemSpacing = newValue }
    }

    public var insets: UIEdgeInsets {
        get { return layout.insets }
        set { layout.insets = newValue }
    }

    public weak var dataSource: ThumbnailViewDataSource?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

extension ThumbnailView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(in: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let attributes = layout.layoutAttributes[indexPath.item]
        let item = dequeueThumbnailViewItem(collectionView, indexPath: indexPath)
        item.tag = attributes.index
        dataSource?.thumbnailView(self, thumbnailForItemAt: attributes.index, size: .zero) { image in
            if item.tag == attributes.index {
                item.imageView.image = image
            }
        }
        return item
    }
}

extension ThumbnailView {
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        let rect = CGRect(
            x: point.x,
            y: point.y,
            width: itemSpacing * 2,
            height: itemSpacing * 2
        )
        guard let attributes = layout.layoutAttributes.first(where: { $0.frame.intersects(rect) }) else {
            return false
        }
        if attributes.index != selectedIndex {
            selectedIndex = attributes.index
            sendActions(for: .valueChanged)
        }
        selectionBegin = attributes.frame.origin
        trackingBegin = point
        return true
    }

    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard let selectionBegin = selectionBegin, let trackingBegin = trackingBegin else {
            return false
        }
        let point = touch.location(in: self)
        let moved = CGPoint(x: point.x - trackingBegin.x, y: point.y - trackingBegin.y)
        let index = selectedIndex(of: CGPoint(x: selectionBegin.x + moved.x, y: selectionBegin.y + moved.y))
        if selectedIndex != index {
            selectedIndex = index
            sendActions(for: .valueChanged)
        }
        return true
    }

    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        selectionBegin = nil
        trackingBegin = nil
    }
}

extension ThumbnailView {
    private func setup() {
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.isUserInteractionEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ThumbnailViewItem.self, forCellWithReuseIdentifier: ThumbnailViewItem.identifier)
        addSubview(collectionView)
        NSLayoutConstraint.activate(NSLayoutConstraint.edges(item: collectionView, to: self))

        selectionView.contentMode = .scaleAspectFit
        addSubview(selectionView)

        layout.didFinishPrepareLayout = { [weak self] in
            self?.updateSelectionView()
        }
    }

    private func dequeueThumbnailViewItem(_ collectionView: UICollectionView, indexPath: IndexPath) -> ThumbnailViewItem {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailViewItem.identifier, for: indexPath) as! ThumbnailViewItem
    }

    private func selectionRect(at index: Int) -> CGRect {
        let nx = (selectionSize.width - itemSize.width) * 0.5
        let ny = (selectionSize.height - itemSize.height) * 0.5
        let left = layout.layoutAttributes
            .filter { $0.index <= index }
            .max { $0.index < $1.index }
            .unsafelyUnwrapped
        let right = layout.layoutAttributes
            .filter { $0.index >= index }
            .min { $0.index < $1.index }
            .unsafelyUnwrapped
        guard left.index != right.index else {
            return CGRect(
                x: left.frame.minX - nx,
                y: left.frame.minY - ny,
                width: selectionSize.width,
                height: selectionSize.height
            )
        }
        let stride = (right.frame.minX - left.frame.minX) / CGFloat(right.index - left.index)
        return CGRect(
            x: (left.frame.minX + CGFloat(index - left.index) * stride) - nx,
            y: left.frame.minY - ny,
            width: selectionSize.width,
            height: selectionSize.height
        )
    }

    private func updateSelectionView() {
        let index = selectedIndex
        selectionView.frame = selectionRect(at: index)
        selectionView.tag = index
        dataSource?.thumbnailView(self, thumbnailForItemAt: index, size: selectionSize) { [weak selectionView] image in
            if selectionView?.tag == index {
                selectionView?.image = image
            }
        }
    }

    private func selectedIndex(of point: CGPoint) -> Int {
        guard let first = layout.layoutAttributes.first, let last = layout.layoutAttributes.last else {
            return 0
        }
        guard point.x >= first.frame.minX else {
            return 0
        }
        guard point.x <= last.frame.minX else {
            return last.index
        }

        let left = layout.layoutAttributes
            .filter { $0.frame.minX <= point.x }
            .max { $0.index < $1.index }
            .unsafelyUnwrapped

        let right = layout.layoutAttributes
            .filter { $0.frame.minX >= point.x }
            .min { $0.index < $1.index }
            .unsafelyUnwrapped

        guard left.index != right.index else {
            return left.index
        }
        let stride = (right.frame.minX - left.frame.minX) / CGFloat(right.index - left.index)
        return left.index + Int((point.x - left.frame.minX) / stride)
    }
}
