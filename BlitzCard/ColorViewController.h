/*
 By: Justin Meiners
 
 Copyright (c) 2013 Inline Studios
 Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 */
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
