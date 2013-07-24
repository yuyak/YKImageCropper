//
//  AppDelegate.m
//  Copyright (c) 2013 yuyak. All rights reserved.
//

#import "AppDelegate.h"

#import "YKImageCropperViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // Add root view controller
    UIImage *image = [UIImage imageNamed:@"Sample.jpg"];
    YKImageCropperViewController *vc = [[YKImageCropperViewController alloc] initWithImage:image];
    vc.cancelHandler = ^() {
        NSLog(@"* Cancel");
    };
    vc.doneHandler = ^(UIImage *editedImage) {
        NSLog(@"* Done");
        NSLog(@"Original: %@, Edited: %@", NSStringFromCGSize(image.size), NSStringFromCGSize(editedImage.size));
    };

    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBar.barStyle = UIBarStyleBlack;
    nvc.toolbar.barStyle = UIBarStyleBlack;
    self.window.rootViewController = nvc;
    [self.window addSubview:nvc.view];

    return YES;
}

@end