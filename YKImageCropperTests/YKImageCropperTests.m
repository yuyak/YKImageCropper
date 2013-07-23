//
//  YKImageCropperTests.m
//  YKImageCropperTests
//
//  Created by Z3 on 7/23/13.
//
//

#import "YKImageCropperTests.h"

#import "YKImageCropperView.h"

@interface YKImageCropperTests ()

@property (nonatomic, strong) YKImageCropperView *view;
@property (nonatomic, strong) UIImage *image;

@end

@implementation YKImageCropperTests

- (void)setUp {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"Test1" ofType:@"jpg"];
    self.image = [UIImage imageWithContentsOfFile:imagePath];
    self.view = [[YKImageCropperView alloc] initWithImage:self.image];
}

- (void)testEditedImageSize
{
    STAssertEquals(self.view.editedImage.size, CGSizeMake(642, 964), nil);

    [self.view square];
    STAssertEquals(self.view.editedImage.size, CGSizeMake(642, 642), nil);

    [self.view reset];
    STAssertEquals(self.view.editedImage.size, CGSizeMake(642, 964), nil);
}

@end
