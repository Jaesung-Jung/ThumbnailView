# ThumbnailView
ThumbnailView object contains a set of thumbnails, each of which represents images.

![ThumbnailView Preview](https://raw.githubusercontent.com/Jaesung-Jung/ThumbnailView/master/Resources/preview.gif)

## Usage
### Implements ThumbnailViewDataSource
```swift
extension ViewController: ThumbnailViewDataSource {
    func numberOfItems(in thumbnailView: ThumbnailView) -> Int {
        return images.count
    }

    func thumbnailView(_ thumbnailView: ThumbnailView, thumbnailForItemAt index: Int, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        // load image
        completion(image)
    }
}
```

## Requirements
* Swift 4
* iOS 8

## Installation
* **Using [Carthage](https://github.com/Carthage/Carthage)**:
    ```
    github "Jaesung-Jung/ThumbnailView"
    ```
    ```
    $ carthage update
    ```

## License
ThumbnailView is under MIT license. See the [LICENSE](https://github.com/Jaesung-Jung/ThumbnailView/blob/master/LICENSE) for more info.
