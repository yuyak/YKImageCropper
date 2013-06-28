//
//  YKImageCropperViewController.m
//  Copyright (c) 2013 yuyak. All rights reserved.
//

#import "YKImageCropperViewController.h"

#import "YKImageCropperView.h"

@interface YKImageCropperViewController ()

@property (nonatomic, strong) YKImageCropperView *imageCropperView;

@end

@implementation YKImageCropperViewController

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.imageCropperView = [[YKImageCropperView alloc] initWithImage:image];
        [self.view addSubview:self.imageCropperView];

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(cancelAction)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(doneAction)];

        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
        UIBarButtonItem *constrainButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Square", @"")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self.imageCropperView
                                                                           action:@selector(square)];
        UIBarButtonItem *revertButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset", @"")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self.imageCropperView
                                                                           action:@selector(reset)];

        self.toolbarItems = @[space, constrainButton, space, revertButton, space];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)cancelAction {
    if (self.cancelHandler)
        self.cancelHandler();
}

- (void)doneAction {
    if (self.doneHandler)
        self.doneHandler([self.imageCropperView editedImage]);
}

@end