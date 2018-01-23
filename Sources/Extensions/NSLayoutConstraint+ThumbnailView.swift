//
//  NSLayoutConstraint.swift
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

extension NSLayoutConstraint {
    static func edges(item: UIView, to: UIView) -> [NSLayoutConstraint] {
        if #available(iOS 9.0, *) {
            return [
                item.leadingAnchor.constraint(equalTo: to.leadingAnchor),
                item.trailingAnchor.constraint(equalTo: to.trailingAnchor),
                item.topAnchor.constraint(equalTo: to.topAnchor),
                item.bottomAnchor.constraint(equalTo: to.bottomAnchor)
            ]
        } else {
            return [
                NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: to, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: item, attribute: .trailing, relatedBy: .equal, toItem: to, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: to, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: to, attribute: .bottom, multiplier: 1, constant: 0)
            ]
        }
    }
}
