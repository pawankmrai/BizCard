//
//  BCEditLabelViewController.m
//  BlitzCard
//
//  Created by Pawan Rai on 7/26/13.
//  Copyright (c) 2013 AppStudioz. All rights reserved.
//

#import "BCEditLabelViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BCEditLabelViewController () <UITextFieldDelegate>
{

    UIColor *txtColor;
    NSString *txtFont;
}

@property (weak, nonatomic) IBOutlet UIScrollView *fontScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *colorScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property(nonatomic, strong) NSMutableArray *colorArray;
@property(nonatomic, strong) NSMutableArray *fontArray;
- (IBAction)txtSaveAction:(id)sender;
@end

@implementation BCEditLabelViewController
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.txtField.text=self.textToEdit;
    
    if (self.fontArray==nil) {
        _fontArray=[[NSMutableArray alloc] init];
    }
    if (self.colorArray==nil) {
        _colorArray=[[NSMutableArray alloc] init];
    }
    
    [self.colorArray addObject:[UIColor redColor]];
    [self.colorArray addObject:[UIColor greenColor]];
    [self.colorArray addObject:[UIColor blueColor]];
    [self.colorArray addObject:[UIColor grayColor]];
    [self.colorArray addObject:[UIColor orangeColor]];
    [self.colorArray addObject:[UIColor blackColor]];
    [self.colorArray addObject:[UIColor darkGrayColor]];
    [self.colorArray addObject:[UIColor lightGrayColor]];
    [self.colorArray addObject:[UIColor cyanColor]];
    [self.colorArray addObject:[UIColor yellowColor]];
    [self.colorArray addObject:[UIColor magentaColor]];
    [self.colorArray addObject:[UIColor purpleColor]];
    [self.colorArray addObject:[UIColor brownColor]];
    
	for(NSString* family in [UIFont familyNames]) {
        for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
            
            //NSLog(@"  %@", name);
            [self.fontArray addObject:name];
            
        }
    }
    [self createScrollforFont:self.fontArray];
    [self createScrollforColor:self.colorArray];
    
}
-(void)createScrollforFont:(NSArray*)fontArray{

    int xOffset= 2;
    int tag =0;
    for (NSString *fontName in fontArray) {
        
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor=[UIColor blackColor];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(xOffset+2, 65, 60, 35)];
            lbl.font=[UIFont systemFontOfSize:12];
            lbl.lineBreakMode=UILineBreakModeWordWrap;
            lbl.text=fontName;
            lbl.numberOfLines=0;
            lbl.backgroundColor=[UIColor clearColor];
            lbl.textColor=[UIColor whiteColor];
            lbl.textAlignment=UITextAlignmentCenter;
            [btn setTitle:@"AaBb" forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont fontWithName:fontName size:16];
            btn.tag=tag;
            CALayer *layer1 = [btn layer];
            [layer1 setMasksToBounds:YES];
            [layer1 setCornerRadius:7.0];
            [layer1 setBorderWidth:0.0];
            [layer1 setBorderColor:[[UIColor whiteColor] CGColor]];
            
            btn.frame = CGRectMake(xOffset, 5, 60, 55);
            [btn addTarget:self action:@selector(performFontEffect:) forControlEvents:UIControlEventTouchUpInside];
            [self.fontScrollView addSubview:btn];
            [self.fontScrollView addSubview:lbl];
            xOffset+=70;
            tag++;        
    }
    xOffset+=70;
    
    self.fontScrollView.contentSize=CGSizeMake(xOffset, 65);
}
-(void)performFontEffect:(UIButton*)sender{

    NSString *fontName=[self.fontArray objectAtIndex:[sender tag]];
    txtFont=fontName;
    [self.txtField setFont:[UIFont fontWithName:fontName size:14]];
}

/////////create scroll for color
-(void)createScrollforColor:(NSArray*)colorArray{

    int xOffset= 2;
    int tag =0;
    for (UIColor *color in colorArray) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor=color;
        btn.tag=tag;
        CALayer *layer1 = [btn layer];
        [layer1 setMasksToBounds:YES];
        [layer1 setCornerRadius:7.0];
        [layer1 setBorderWidth:0.0];
        [layer1 setBorderColor:[[UIColor whiteColor] CGColor]];
        
        btn.frame = CGRectMake(xOffset, 5, 60, 55);
        [btn addTarget:self action:@selector(performColorEffect:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorScrollView addSubview:btn];
        xOffset+=70;
        tag++;
    }
    xOffset+=70;
    
    self.colorScrollView.contentSize=CGSizeMake(xOffset, 65);
}
-(void)performColorEffect:(UIButton*)sender{

    UIColor *textColor=[self.colorArray objectAtIndex:[sender tag]];
    txtColor=textColor;
    [self.txtField setTextColor:textColor];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}
- (IBAction)txtSaveAction:(id)sender {
    
    [self.delegate saveTextWith:[self.txtField text] txtFont:txtFont txtColor:txtColor];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtField:nil];
    [self setFontScrollView:nil];
    [self setColorScrollView:nil];
    [super viewDidUnload];
}

@end
