//
//  YKImageCropperOverlayView.h
//  Copyright (c) 2013 yuyak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKImageCropperOverlayView : UIView

@property (nonatomic, assign) CGRect clearRect;
@property (nonatomic, assign) CGSize maxSize;
@property (readonly) CGRect topLeftCorner;
@property (readonly) CGRect topRightCorner;
@property (readonly) CGRect bottomLeftCorner;
@property (readonly) CGRect bottomRightCorner;

- (BOOL)isCornerContainsPoint:(CGPoint)point;

@end