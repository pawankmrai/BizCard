//  digiBiz Card
//
//  Created by PAWAN RAI on 9/20/13.
//  Copyright (c) 2013 AppStudioz. All rights reserved.

#import <UIKit/UIKit.h>
#import "ISColorWheel.h"

@protocol BSColorSelectionDelegate <NSObject>

@required
-(void)finishWithColorSelection:(UIColor*)selectedColor;

@end

@interface ColorViewController : UIViewController <ISColorWheelDelegate>
{
    ISColorWheel* _colorWheel;
    UISlider* _brightnessSlider;
    UIView* _wellView;
}
@property(nonatomic, retain) id <BSColorSelectionDelegate> delegate;

@end
