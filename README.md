# YKImageCropper

![Screenshot](https://raw.github.com/yuyak/YKImageCropper/master/Example/screenshot.png)

## Installation

```ruby
pod 'YKImageCropper', '~> 0.0.3'
```

## Usage

```objective-c
UIImage *image = [UIImage imageNamed:@"Sample.jpg"];
YKImageCropperViewController *vc = [[YKImageCropperViewController alloc] initWithImage:image];
vc.cancelHandler = ^() {
    // When cancel is tapped
};
vc.doneHandler = ^(UIImage *editedImage) {
    // When done is tapped
};
```

## Contact

yuyak

- http://github.com/yuyak
- http://twitter.com/yuyak

## License

YKImageCropper is available under the MIT license. See the LICENSE file for more info.
