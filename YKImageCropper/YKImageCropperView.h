//
//  YKImageCropperView.h
//  Copyright (c) 2013 yuyak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKImageCropperView : UIView

@property (nonatomic, strong) UIImage *image;

- (id)initWithImage:(UIImage *)image;
- (void)square;
- (void)reset;

@end