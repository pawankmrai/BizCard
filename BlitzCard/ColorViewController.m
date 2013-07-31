/*
 By: Justin Meiners
 
 Copyright (c) 2013 Inline Studios
 Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 */

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
    [doneButton setFrame:CGRectMake(10, 5, 70, 40)];
    [doneButton setTintColor:[UIColor grayColor]];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(colorSelectionDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
}
-(void)colorSelectionDone:(id)sender
{

    [self.delegate finishWithColorSelection:_colorWheel.currentColor];
    
    [self dismissModalViewControllerAnimated:YES];
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


@end