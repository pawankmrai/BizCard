//
//  BCTextViewController.m
//  BlitzCard
//
//  Created by Pawan Rai on 7/25/13.
//  Copyright (c) 2013 AppStudioz. All rights reserved.
//

#import "BCTextViewController.h"
#import "BCViewController.h"
@interface BCTextViewController ()


- (IBAction)showFont:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *fontScrollView;
@property (weak, nonatomic) IBOutlet UIView *FontView;
@end

@implementation BCTextViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    BCViewController *vc=(BCViewController*)segue.destinationViewController;
    vc.stringArray=[self enumerateMessageArray];
}
-(NSArray*)enumerateMessageArray{

    NSMutableArray *array=[[NSMutableArray alloc] init];
    
    for (UITextField *textField in self.txtFieldMessage) {
        
        [array addObject:textField.text];
    }
    return array;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self display:[self.txtFieldMessage count]];
    
}
- (IBAction)showFont:(id)sender {
    
    [self.fontScrollView setContentSize:CGSizeMake(500, 55)];
    [UIView animateWithDuration:0.5f animations:^{
        
        [self.FontView setFrame:CGRectMake(0, 200, 480, 55)];
        
    }];

    
    for(NSString* family in [UIFont familyNames]) {
        NSLog(@"%@", family);
        for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
            NSLog(@"  %@", name);
        }
    }
    
}
- (void)display:(NSInteger) i
{
    for (int j=0; j<i; j++) {
        
        [[_txtFieldMessage objectAtIndex:j] setText: @"test"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFontScrollView:nil];
    [self setFontView:nil];
    [super viewDidUnload];
}
@end
