//
//  ThumbnailViewTests.swift
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

import XCTest
@testable import ThumbnailView

class ThumbnailViewTests: XCTestCase {
    let thumbnailView = ThumbnailView(frame: .zero)

    func testProperties() {
        let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        thumbnailView.insets = insets
        XCTAssertEqual(thumbnailView.insets, insets)

        let itemSize = CGSize(width: 50, height: 50)
        thumbnailView.itemSize = itemSize
        XCTAssertEqual(thumbnailView.itemSize, itemSize)
        XCTAssertEqual(thumbnailView.selectionSize, CGSize(width: itemSize.width * 1.2, height: itemSize.height * 1.2))

        let itemSpacing: CGFloat = 5
        thumbnailView.itemSpacing = itemSpacing
        XCTAssertEqual(thumbnailView.itemSpacing, itemSpacing)
    }
}
