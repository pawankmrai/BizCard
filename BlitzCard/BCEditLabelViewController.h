//
//  BCEditLabelViewController.h
//  BlitzCard
//
//  Created by Pawan Rai on 7/26/13.
//  Copyright (c) 2013 AppStudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCEditLabelDelegate <NSObject>

-(void)saveTextWith:(NSString*)text txtFont:(NSString*)fontName txtColor:(UIColor*)txtColor;

@end

@interface BCEditLabelViewController : UIViewController

@property(strong, nonatomic)NSString *textToEdit;
@property(nonatomic) id <BCEditLabelDelegate> delegate;
@end
