//
//  YKImageCropperViewController.h
//  Copyright (c) 2013 yuyak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKImageCropperViewController : UIViewController

@property (nonatomic, copy) void (^doneHandler)();
@property (nonatomic, copy) void (^cancelHandler)();

- (id)initWithImage:(UIImage *)image;

@end