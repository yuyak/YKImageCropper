//
//  YKImageCropperView.m
//  Copyright (c) 2013 yuyak. All rights reserved.
//

#import "YKImageCropperView.h"

#import "YKImageCropperOverlayView.h"

enum {
    TopLeftCorner = 0,
    TopRightCorner,
    BottomLeftCorner,
    BottomRightCorner
};

static CGSize minSize = {40, 40};

@interface YKImageCropperView ()

@property (nonatomic, assign) CGPoint firstTouchedPoint;

@property (nonatomic, assign) NSUInteger panningCorner;

@property (nonatomic, assign) BOOL isPanningCorner;

// Current scale (1 <= currentScale)
@property (nonatomic, assign) CGFloat currentScale;

// Image view
@property (nonatomic, strong) UIImageView *imageView;

// Minimum size for image, maximum size for overlay
@property (nonatomic, assign) CGRect baseRect;

// Overlay view
@property (nonatomic, strong) YKImageCropperOverlayView *overlayView;

@end

@implementation YKImageCropperView

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.image = image;
        self.frame = CGRectMake(0, 0,
                                [UIScreen mainScreen].applicationFrame.size.width,
                                [UIScreen mainScreen].applicationFrame.size.height - 88);
        self.backgroundColor = [UIColor blackColor];

        self.imageView = [[UIImageView alloc] init];
        self.imageView.image = image;

        // Pinch
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                                     action:@selector(pinchGesture:)];
        [self addGestureRecognizer:pinchGestureRecognizer];

        // Pan
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(panGesture:)];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:panGestureRecognizer];

        CGRect frame;
        frame.size = [self getImageSizeForPreview:image];
        self.imageView.frame = frame;
        self.imageView.center = self.center;
        self.baseRect = self.imageView.frame;
        [self addSubview:self.imageView];

        // Overlay
        self.overlayView = [[YKImageCropperOverlayView alloc] initWithFrame:self.frame];
        self.overlayView.maxSize = self.baseRect.size;
        [self addSubview:self.overlayView];

        [self reset];
    }

    return self;
}

- (UIImage *)editedImage {
    CGFloat scale = self.image.size.width / self.imageView.frame.size.width;
    CGRect rect = self.overlayView.clearRect;
    rect.origin.x = (rect.origin.x - self.imageView.frame.origin.x) * scale;
    rect.origin.y = (rect.origin.y - self.imageView.frame.origin.y) * scale;
    rect.size.width *= scale;
    rect.size.height *= scale;

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextClipToRect(c, CGRectMake(0, 0, rect.size.width, rect.size.height));
    [self.image drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, self.image.size.width, self.image.size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

- (void)reset {
    self.currentScale = 1.0;
    self.imageView.frame = self.baseRect;
    CGRect clearRect = self.baseRect;
    clearRect.origin = CGPointMake((self.frame.size.width - self.baseRect.size.width) / 2.0f,
                                   (self.frame.size.height - self.baseRect.size.height) / 2.0f);
    self.overlayView.clearRect = clearRect;
    [self.overlayView setNeedsDisplay];
}

- (void)square {
    [self setConstrain:CGSizeMake(1, 1)];
}

- (void)setConstrain:(CGSize)size {
    CGFloat constrainRatio = size.width / size.height;
    CGFloat currentRatio = self.overlayView.clearRect.size.width / self.overlayView.clearRect.size.height;
    CGSize newSize = self.overlayView.clearRect.size;

    if (currentRatio > constrainRatio) {
        newSize.width = newSize.height * constrainRatio;
    } else {
        newSize.height = newSize.width * (size.height / size.width);
    }

    // New size should be bigger than min size
    if (newSize.width < minSize.width || newSize.height < minSize.height) {
        if (size.height / size.width > 1) {
            newSize.width = minSize.width;
            newSize.height = minSize.width * size.height / size.width;
        } else {
            newSize.width = minSize.width * size.width / size.height;
            newSize.height = minSize.height;
        }
    }

    CGRect frame = self.overlayView.clearRect;
    frame.size = newSize;
    self.overlayView.clearRect = frame;

    [self.overlayView setNeedsDisplay];
}

- (CGSize)getImageSizeForPreview:(UIImage *)image {
    CGFloat maxWidth = self.frame.size.width - 40, maxHeight = self.frame.size.height - 40;

    CGSize size = image.size;

    if (size.width > maxWidth) {
        size.height *= (maxWidth / size.width);
        size.width = maxWidth;
    }

    if (size.height > maxHeight) {
        size.width *= (maxHeight / size.height);
        size.height = maxHeight;
    }

    if (size.width < minSize.width) {
        size.height *= (minSize.width / size.width);
        size.width = minSize.width;
    }

    if (size.height < minSize.height) {
        size.width *= (minSize.height / size.height);
        size.height = minSize.height;
    }

    return size;
}

- (void)setCurrentScale:(CGFloat)currentScale {
    _currentScale = MAX(1.0f, currentScale);
}

- (BOOL)shouldRevertX {
    CGRect clearRect = self.overlayView.clearRect;
    CGRect imageRect = self.imageView.frame;

    if (CGRectGetMinX(imageRect) > CGRectGetMinX(clearRect)
        || CGRectGetMaxX(imageRect) < CGRectGetMaxX(clearRect)) {
        return YES;
    }

    if (CGRectGetMinX(clearRect) < CGRectGetMinX(self.baseRect)
        || CGRectGetMaxX(clearRect) > CGRectGetMaxX(self.baseRect)) {
        return YES;
    }

    if (clearRect.size.width < minSize.width) {
        return YES;
    }

    return NO;
}

- (BOOL)shouldRevertY {
    CGRect clearRect = self.overlayView.clearRect;
    CGRect imageRect = self.imageView.frame;

    if (CGRectGetMinY(imageRect) > CGRectGetMinY(clearRect)
        || CGRectGetMaxY(imageRect) < CGRectGetMaxY(clearRect)) {
        return YES;
    }

    if (CGRectGetMinY(clearRect) < CGRectGetMinY(self.baseRect)
        || CGRectGetMaxY(clearRect) > CGRectGetMaxY(self.baseRect)) {
        return YES;
    }

    if (clearRect.size.height < minSize.height) {
        return YES;
    }

    return NO;
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)sender {
    CGFloat newScale = self.currentScale * sender.scale;
    CGRect oldImageFrame = self.imageView.frame;
    CGSize newSize = CGSizeMake(newScale * self.baseRect.size.width,
                                newScale * self.baseRect.size.height);

    // Update frame
    CGRect newFrame = self.imageView.frame;
    newFrame.size = newSize;
    self.imageView.frame = newFrame;

    // Move center
    CGPoint d = CGPointMake((oldImageFrame.size.width - newFrame.size.width) / 2.0f,
                            (oldImageFrame.size.height - newFrame.size.height) / 2.0f);
    self.imageView.center = CGPointMake(self.imageView.center.x + d.x,
                                        self.imageView.center.y + d.y);

    if (([self shouldRevertX] || [self shouldRevertY])) {
        self.imageView.frame = oldImageFrame;
    } else {
        self.currentScale = newScale;
    }

    // Reset scale
    sender.scale = 1;
}

- (NSUInteger)getCornerByPoint:(CGPoint)point {
    if (CGRectContainsPoint(self.overlayView.topLeftCorner, point)) {
        return TopLeftCorner;
    } else if (CGRectContainsPoint(self.overlayView.topRightCorner, point)) {
        return TopRightCorner;
    } else if (CGRectContainsPoint(self.overlayView.bottomLeftCorner, point)) {
        return BottomLeftCorner;
    } else {
        return BottomRightCorner;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    if ([touches count] == 1) {
        self.firstTouchedPoint = [(UITouch*)[touches anyObject] locationInView:self];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = self.firstTouchedPoint;
        
        self.isPanningCorner = ([self.overlayView isCornerContainsPoint:point]);
        if (self.isPanningCorner) {
            self.panningCorner = [self getCornerByPoint:point];
        }
    }

    if (self.isPanningCorner) {
        [self panCorner:sender];
    } else {
        [self panImage:sender];
    }

    // Reset points
    [sender setTranslation:CGPointZero inView:self];
}

- (void)panCorner:(UIPanGestureRecognizer *)sender {
    CGPoint d = [sender translationInView:self];
    CGRect oldClearRect = self.overlayView.clearRect;
    CGRect newClearRect = self.overlayView.clearRect;

    BOOL isLeft = (self.panningCorner == TopLeftCorner || self.panningCorner == BottomLeftCorner);
    BOOL isTop = (self.panningCorner == TopLeftCorner || self.panningCorner == TopRightCorner);

    if (isLeft) {
        newClearRect.origin.x += d.x;
        newClearRect.size.width -= d.x;
    } else {
        newClearRect.size.width += d.x;
    }

    if (isTop) {
        newClearRect.origin.y += d.y;
        newClearRect.size.height -= d.y;
    } else {
        newClearRect.size.height += d.y;
    }

    self.overlayView.clearRect = newClearRect;

    // Check x
    if ([self shouldRevertX]) {
        newClearRect.origin.x = oldClearRect.origin.x;
        newClearRect.size.width = oldClearRect.size.width;
    }

    // Check y
    if ([self shouldRevertY]) {
        newClearRect.origin.y = oldClearRect.origin.y;
        newClearRect.size.height = oldClearRect.size.height;
    }

    self.overlayView.clearRect = newClearRect;
    [self.overlayView setNeedsDisplay];
}

- (void)panImage:(UIPanGestureRecognizer *)sender {
    CGPoint d = [sender translationInView:self];
    CGPoint newCenter = CGPointMake(self.imageView.center.x + d.x,
                                    self.imageView.center.y + d.y);
    self.imageView.center = newCenter;

    // Check x
    if ([self shouldRevertX]) {
        newCenter.x -= d.x;
    }

    // Check y
    if ([self shouldRevertY]) {
        newCenter.y -= d.y;
    }

    self.imageView.center = newCenter;
}

@end