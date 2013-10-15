//
//  BCNavigationController.m
//  digiBiz Card
//
//  Created by PAWAN RAI on 10/3/13.
//  Copyright (c) 2013 AppStudioz. All rights reserved.
//

#import "BCNavigationController.h"

@interface BCNavigationController ()

@end

@implementation BCNavigationController


- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
