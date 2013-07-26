//
//  BCTextViewController.h
//  BlitzCard
//
//  Created by Pawan Rai on 7/25/13.
//  Copyright (c) 2013 AppStudioz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BCTextViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *txtFieldMessage;
@end
