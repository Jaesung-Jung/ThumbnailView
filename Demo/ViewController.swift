//
//  ViewController.swift
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
import ThumbnailView

class ViewController: UIViewController {
    @IBOutlet weak var thumbnailView: ThumbnailView!

    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    let images = [#imageLiteral(resourceName: "img_01"), #imageLiteral(resourceName: "img_02"), #imageLiteral(resourceName: "img_03"), #imageLiteral(resourceName: "img_04"), #imageLiteral(resourceName: "img_05"), #imageLiteral(resourceName: "img_06")]

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(pageViewController)
        view.insertSubview(pageViewController.view, at: 0)

        pageViewController.setViewControllers([imageViewController(at: 0)!], direction: .forward, animated: false)

        pageViewController.dataSource = self
        pageViewController.delegate = self
        thumbnailView.dataSource = self
    }

    @IBAction func thumbnailViewValueChanged(_ sender: ThumbnailView) {
        guard let viewController = imageViewController(at: sender.selectedIndex) else {
            return
        }
        pageViewController.setViewControllers([viewController], direction: .forward, animated: false)
    }
}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return imageViewController(at: viewController.view.tag - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return imageViewController(at: viewController.view.tag + 1)
    }

    private func imageViewController(at index: Int) -> ImageViewController? {
        guard images.indices.contains(index) else {
            return nil
        }
        let viewController = ImageViewController(image: images[index])
        viewController.view.tag = index
        return viewController
    }
}

extension ViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let current = pageViewController.viewControllers?.first else {
            return
        }
        thumbnailView.selectedIndex = current.view.tag
    }
}

extension ViewController: ThumbnailViewDataSource {
    func numberOfItems(in thumbnailView: ThumbnailView) -> Int {
        return images.count
    }

    func thumbnailView(_ thumbnailView: ThumbnailView, thumbnailForItemAt index: Int, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        completion(images[index])
    }
}

class ImageViewController: UIViewController {
    let imageView = UIImageView()

    convenience init(image: UIImage) {
        self.init()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
