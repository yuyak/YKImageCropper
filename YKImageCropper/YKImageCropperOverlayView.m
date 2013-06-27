//
//  YKImageCropperOverlayView.m
//  Copyright (c) 2013 yuyak. All rights reserved.
//

#import "YKImageCropperOverlayView.h"

#define SIZE 20.0f

@implementation YKImageCropperOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (CGRect)topLeftCorner {
    return CGRectMake(CGRectGetMinX(self.clearRect) - SIZE / 2,
                      CGRectGetMinY(self.clearRect) - SIZE / 2,
                      SIZE, SIZE);
}

- (CGRect)topRightCorner {
    return CGRectMake(CGRectGetMaxX(self.clearRect) - SIZE / 2,
                      CGRectGetMinY(self.clearRect) - SIZE / 2,
                      SIZE, SIZE);
}

- (CGRect)bottomLeftCorner {
    return CGRectMake(CGRectGetMinX(self.clearRect) - SIZE / 2,
                      CGRectGetMaxY(self.clearRect) - SIZE / 2,
                      SIZE, SIZE);
}

- (CGRect)bottomRightCorner {
    return CGRectMake(CGRectGetMaxX(self.clearRect) - SIZE / 2,
                      CGRectGetMaxY(self.clearRect) - SIZE / 2,
                      SIZE, SIZE);
}

- (BOOL)isCornerContainsPoint:(CGPoint)point {
    return CGRectContainsPoint([self topLeftCorner], point)
            || CGRectContainsPoint([self topRightCorner], point)
            || CGRectContainsPoint([self bottomLeftCorner], point)
            || CGRectContainsPoint([self bottomRightCorner], point);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(c, YES);

    // Fill black
    CGContextSetFillColorWithColor(c, [UIColor colorWithWhite:0 alpha:0.7].CGColor);
    CGContextAddRect(c, CGRectMake(0, 0, 320, 480));
    CGContextFillPath(c);

    // Clear inside
    CGContextClearRect(c, self.clearRect);
    CGContextFillPath(c);

    // Draw corners
    CGContextSetFillColorWithColor(c, [UIColor colorWithWhite:1 alpha:0.5].CGColor);

    CGFloat addition = SIZE / 4.0f;
    CGFloat borderWidth = SIZE / 2.4f;
    CGFloat borderLength = SIZE;

    // Top left
    CGContextAddRect(c, CGRectMake(self.topLeftCorner.origin.x + addition,
                                   self.topLeftCorner.origin.y + addition,
                                   borderWidth, borderLength));
    CGContextAddRect(c, CGRectMake(self.topLeftCorner.origin.x + addition,
                                   self.topLeftCorner.origin.y + addition,
                                   borderLength, borderWidth));

    // Top right
    CGContextAddRect(c, CGRectMake(self.topRightCorner.origin.x + addition,
                                   self.topRightCorner.origin.y + addition,
                                   borderWidth, borderLength));
    CGContextAddRect(c, CGRectMake(self.topRightCorner.origin.x - self.topRightCorner.size.width + addition + borderWidth,
                                   self.topRightCorner.origin.y + addition,
                                   borderLength, borderWidth));

    // Bottom left
    CGContextAddRect(c, CGRectMake(self.bottomLeftCorner.origin.x + addition,
                                   self.bottomLeftCorner.origin.y - self.topRightCorner.size.height + addition + borderWidth,
                                   borderWidth, borderLength));
    CGContextAddRect(c, CGRectMake(self.bottomLeftCorner.origin.x + addition,
                                   self.bottomLeftCorner.origin.y + addition,
                                   borderLength, borderWidth));

    // Bottom right
    CGContextAddRect(c, CGRectMake(self.bottomRightCorner.origin.x + addition,
                                   self.bottomRightCorner.origin.y - self.topRightCorner.size.height + addition + borderWidth,
                                   borderWidth, borderLength));
    CGContextAddRect(c, CGRectMake(self.bottomRightCorner.origin.x - self.topRightCorner.size.width + addition + borderWidth,
                                   self.bottomRightCorner.origin.y + addition,
                                   borderLength, borderWidth));
    
    CGContextFillPath(c);
    
    // Grid
    CGContextSetStrokeColorWithColor(c, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(c, 1);

    CGContextAddRect(c, self.clearRect);

    CGPoint from, to;

    // vline
    for (int i = 1; i <= 2; i++) {
        from = CGPointMake(self.clearRect.origin.x + self.clearRect.size.width / 3.0f * i, self.clearRect.origin.y);
        to = CGPointMake(from.x, CGRectGetMaxY(self.clearRect));
        CGContextMoveToPoint(c, from.x, from.y);
        CGContextAddLineToPoint(c, to.x, to.y);
    }

    // hline
    for (int i = 1; i <= 2; i++) {
        from = CGPointMake(self.clearRect.origin.x, self.clearRect.origin.y + self.clearRect.size.height / 3.0f * i);
        to = CGPointMake(CGRectGetMaxX(self.clearRect), from.y);
        CGContextMoveToPoint(c, from.x, from.y);
        CGContextAddLineToPoint(c, to.x, to.y);
    }

    CGContextStrokePath(c);
}

@end
