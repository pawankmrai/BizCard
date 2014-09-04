//
//  BCEditLabelViewController.h
//  BlitzCard
//
//  Created by Pawan Rai on 7/26/13.
//  Copyright (c) 2013 AppStudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCEditLabelDelegate <NSObject>

-(void)saveTextWith:(NSString*)text txtFont:(UIFont*)font txtColor:(UIColor*)txtColor;
//-(void)saveLabelTextWith:(NSString *)text txtFont:(UIFont *)font txtColor:(UIColor *)textColor;
@end

@interface BCEditLabelViewController : UIViewController

@property(strong, nonatomic)NSString *textToEdit;
@property(strong, nonatomic)UIColor *textToColor;
@property(strong, nonatomic)UIFont *textToFont;
@property(nonatomic) id <BCEditLabelDelegate> delegate;
@end
