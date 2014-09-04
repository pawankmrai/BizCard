
//  digiBiz Card
//
//  Created by PAWAN RAI on 9/20/13.
//  Copyright (c) 2013 AppStudioz. All rights reserved.

#import "ColorViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ColorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize size = self.view.bounds.size;
    
    CGSize wheelSize = CGSizeMake(size.width * .9, size.width * .9);
    
    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(size.width / 2 - wheelSize.width / 2,
                                                                 size.height * .1,
                                                                 wheelSize.width,
                                                                 wheelSize.height)];
    /////////update colorwheel frame
    CGRect wheelFrame=CGRectMake(200, 20, wheelSize.width, wheelSize.height);
    [_colorWheel setFrame:wheelFrame];
    
    
    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    [self.view addSubview:_colorWheel];
    
    _brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(size.width * .4,
                                                                   size.height * .8,
                                                                   size.width * .5,
                                                                   size.height * .1)];
    
     /////////update brightness slider frame
    CGRect sliderFrame=CGRectMake(10, 200, size.width * .5, size.height * .1);
    [_brightnessSlider setFrame:sliderFrame];
    
    _brightnessSlider.minimumValue = 0.0;
    _brightnessSlider.maximumValue = 1.0;
    _brightnessSlider.value = 1.0;
    _brightnessSlider.continuous = true;
    [_brightnessSlider addTarget:self action:@selector(changeBrightness:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_brightnessSlider];
    
    _wellView = [[UIView alloc] initWithFrame:CGRectMake(size.width * .1,
                                                         size.height * .8,
                                                         size.width * .2,
                                                         size.height * .1)];
    
    /////////update brightness slider frame
    CGRect wellViewFrame=CGRectMake(10, 100, size.width * .2, size.height * .1);
    [_wellView setFrame:wellViewFrame];
    
    _wellView.layer.borderColor = [UIColor blackColor].CGColor;
    _wellView.layer.borderWidth = 1.0;
    [self.view addSubview:_wellView];
    
    /////////add a done button
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneButton setFrame:CGRectMake(5, 15, 70, 40)];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.layer.borderWidth = 1.0;
    doneButton.layer.borderColor =[UIColor blackColor].CGColor;
    [doneButton addTarget:self action:@selector(colorSelectionDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
}
-(void)colorSelectionDone:(id)sender
{

    [self.delegate finishWithColorSelection:_colorWheel.currentColor];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeBrightness:(UISlider*)sender
{
    [_colorWheel setBrightness:_brightnessSlider.value];
    [_colorWheel updateImage];
    [_wellView setBackgroundColor:_colorWheel.currentColor];
}

- (void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel
{
    [_wellView setBackgroundColor:_colorWheel.currentColor];
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
