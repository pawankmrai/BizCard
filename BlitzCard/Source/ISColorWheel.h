//  digiBiz Card
//
//  Created by PAWAN RAI on 9/20/13.
//  Copyright (c) 2013 AppStudioz. All rights reserved.


#import <UIKit/UIKit.h>

@class ISColorWheel;

@protocol ISColorWheelDelegate <NSObject>
@required
- (void)colorWheelDidChangeColor:(ISColorWheel*)colorWheel;
@end


@interface ISColorWheel : UIView

@property(nonatomic, retain)UIView* knobView;
@property(nonatomic, assign)CGSize knobSize;
@property(nonatomic, assign)float brightness;
@property(nonatomic, assign)BOOL continuous;
@property(nonatomic, assign)id <ISColorWheelDelegate> delegate;

- (void)updateImage;

- (void)setTouchPoint:(CGPoint)point;

- (void)setCurrentColor:(UIColor*)color;
- (UIColor*)currentColor;
@end
