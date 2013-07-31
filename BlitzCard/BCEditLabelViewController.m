//
//  BCEditLabelViewController.m
//  BlitzCard
//
//  Created by Pawan Rai on 7/26/13.
//  Copyright (c) 2013 AppStudioz. All rights reserved.
//

#import "BCEditLabelViewController.h"
#import <QuartzCore/QuartzCore.h>

#define FONT_SIZE 16.0f
@interface BCEditLabelViewController () <UITextFieldDelegate>
{

    UIColor *txtColor;
    UIFont *txtFont;
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
    [self.colorArray addObject:[UIColor whiteColor]];
    [self.colorArray addObject:[UIColor cyanColor]];
    [self.colorArray addObject:[UIColor yellowColor]];
    [self.colorArray addObject:[UIColor magentaColor]];
    [self.colorArray addObject:[UIColor purpleColor]];
    [self.colorArray addObject:[UIColor brownColor]];
    [self.colorArray addObject:[UIColor colorWithRed:1.000 green:1.000 blue:0.927 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.948 green:0.844 blue:0.644 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.951 green:0.955 blue:0.831 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.781 green:0.649 blue:0.477 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithWhite:0.701 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.713 green:0.632 blue:0.497 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.000 green:0.000 blue:0.426 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.046 green:0.217 blue:0.550 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.000 green:0.000 blue:0.758 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.049 green:0.395 blue:0.998 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.051 green:0.431 blue:0.426 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.441 green:1.000 blue:0.793 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.118 green:0.485 blue:0.103 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.427 green:0.435 blue:0.021 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.704 green:1.000 blue:0.044 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.441 green:1.000 blue:0.039 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.996 green:0.819 blue:0.044 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.816 green:0.587 blue:0.103 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.990 green:0.411 blue:0.250 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.966 green:0.413 blue:0.374 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.973 green:0.000 blue:0.700 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.990 green:0.335 blue:0.999 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.750 green:0.449 blue:0.530 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.845 green:0.608 blue:0.999 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.647 green:0.392 blue:0.829 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.438 green:0.117 blue:0.398 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.421 green:0.000 blue:0.013 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.226 green:0.000 blue:0.434 alpha:1.000]];
    [self.colorArray addObject:[UIColor colorWithRed:0.820 green:0.000 blue:0.182 alpha:1.000]];
    
    UIFont *font1=[UIFont fontWithName:@"10CentSoviet" size:FONT_SIZE];
    UIFont *font2=[UIFont fontWithName:@"18 Holes BRK" size:FONT_SIZE];
    UIFont *font3=[UIFont fontWithName:@"20th Centenary Faux" size:FONT_SIZE];
    UIFont *font4=[UIFont fontWithName:@"36 days ago BRK" size:FONT_SIZE];
    UIFont *font5=[UIFont fontWithName:@"36 days ago Thick BRK" size:FONT_SIZE];
    UIFont *font6=[UIFont fontWithName:@"256 Bytes" size:FONT_SIZE];
    UIFont *font7=[UIFont fontWithName:@"A Cut Above The Rest" size:FONT_SIZE];
    UIFont *font8=[UIFont fontWithName:@"A780-Deco" size:FONT_SIZE];
    UIFont *font9=[UIFont fontWithName:@"Abilene" size:FONT_SIZE];
    UIFont *font10=[UIFont fontWithName:@"Achilles" size:FONT_SIZE];
    UIFont *font11=[UIFont fontWithName:@"Achilles Italic" size:FONT_SIZE];
    UIFont *font12=[UIFont fontWithName:@"Action Is JL" size:FONT_SIZE];
    UIFont *font13=[UIFont fontWithName:@"Action Is, Shaded JL" size:FONT_SIZE];
    UIFont *font14=[UIFont fontWithName:@"Adriator" size:FONT_SIZE];
    UIFont *font18=[UIFont fontWithName:@"Allstar" size:FONT_SIZE];
    UIFont *font19=[UIFont fontWithName:@"Ambrosia MF" size:FONT_SIZE];
    UIFont *font20=[UIFont fontWithName:@"Americana Dreams Condensed" size:FONT_SIZE];
    
    UIFont *font21=[UIFont fontWithName:@"Americana Dreams CondUpright" size:FONT_SIZE];
    UIFont *font22=[UIFont fontWithName:@"Angelic War" size:FONT_SIZE];
    UIFont *font23=[UIFont fontWithName:@"AnnabelScript" size:FONT_SIZE];
    UIFont *font24=[UIFont fontWithName:@"Aristotle Punk" size:FONT_SIZE];
    UIFont *font25=[UIFont fontWithName:@"Asenine" size:FONT_SIZE];
    UIFont *font26=[UIFont fontWithName:@"Ataxia BRK" size:FONT_SIZE];
    UIFont *font27=[UIFont fontWithName:@"Ataxia Outline BRK" size:FONT_SIZE];
    UIFont *font28=[UIFont fontWithName:@"Avondale Cond" size:FONT_SIZE];
    UIFont *font30=[UIFont fontWithName:@"Baby Jeepers" size:FONT_SIZE];
    UIFont *font31=[UIFont fontWithName:@"Ballad-Script" size:FONT_SIZE];
    UIFont *font33=[UIFont fontWithName:@"Beethoven" size:FONT_SIZE];
    UIFont *font34=[UIFont fontWithName:@"Beta Block" size:FONT_SIZE];
    UIFont *font35=[UIFont fontWithName:@"Betsy Flanagan" size:FONT_SIZE];
    UIFont *font36=[UIFont fontWithName:@"Betty Noir" size:FONT_SIZE];
    UIFont *font38=[UIFont fontWithName:@"Retro Rock Poster" size:FONT_SIZE];
    UIFont *font39=[UIFont fontWithName:@"Rustick_Capitals" size:FONT_SIZE];
    UIFont *font40=[UIFont fontWithName:@"Salmon" size:FONT_SIZE];
    UIFont *font41=[UIFont fontWithName:@"Savannah" size:FONT_SIZE];
    UIFont *font42=[UIFont fontWithName:@"Scretch" size:FONT_SIZE];
    UIFont *font43=[UIFont fontWithName:@"Serfin" size:FONT_SIZE];
    UIFont *font48=[UIFont fontWithName:@"SF Baroquesque Condensed" size:FONT_SIZE];
    UIFont *font50=[UIFont fontWithName:@"SF Baroquesque Extended" size:FONT_SIZE];
    UIFont *font53=[UIFont fontWithName:@"SF Tattle Tales Outline" size:FONT_SIZE];
    UIFont *font57=[UIFont fontWithName:@"SF Telegraphic Light" size:FONT_SIZE];
        
    [self.fontArray addObject:font1];
    [self.fontArray addObject:font2];
    [self.fontArray addObject:font3];
    [self.fontArray addObject:font4];
    [self.fontArray addObject:font5];
    [self.fontArray addObject:font6];
    [self.fontArray addObject:font7];
    [self.fontArray addObject:font8];
    [self.fontArray addObject:font9];
    [self.fontArray addObject:font10];
    [self.fontArray addObject:font11];
    [self.fontArray addObject:font12];
    [self.fontArray addObject:font13];
    [self.fontArray addObject:font14];
    [self.fontArray addObject:font18];
    [self.fontArray addObject:font19];
    [self.fontArray addObject:font20];
    [self.fontArray addObject:font21];
    [self.fontArray addObject:font22];
    [self.fontArray addObject:font23];
    [self.fontArray addObject:font24];
    [self.fontArray addObject:font25];
    [self.fontArray addObject:font26];
    [self.fontArray addObject:font27];
    [self.fontArray addObject:font28];
    [self.fontArray addObject:font30];
    [self.fontArray addObject:font31];
    [self.fontArray addObject:font33];
    [self.fontArray addObject:font34];
    [self.fontArray addObject:font35];
    [self.fontArray addObject:font36];
    [self.fontArray addObject:font38];
    [self.fontArray addObject:font39];
    [self.fontArray addObject:font40];
    [self.fontArray addObject:font41];
    [self.fontArray addObject:font42];
    [self.fontArray addObject:font43];
    [self.fontArray addObject:font48];
    [self.fontArray addObject:font50];
    [self.fontArray addObject:font53];
    [self.fontArray addObject:font57];
    
    
    ////add default system fonts
//    for(NSString* family in [UIFont familyNames]) {
//        for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
//            
//            //NSLog(@"  %@", name);
//            [self.fontArray addObject:name];
//            
//        }
//    }

    
    /////add custom fonts here
    
    [self createScrollforFont:self.fontArray];
    [self createScrollforColor:self.colorArray];
    
}
-(void)createScrollforFont:(NSArray*)fontArray{

    int xOffset= 2;
    int tag =0;
    for (UIFont *font in fontArray) {
        
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor=[UIColor blackColor];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(xOffset+2, 65, 60, 35)];
            lbl.font=[UIFont systemFontOfSize:12];
            lbl.lineBreakMode=UILineBreakModeWordWrap;
            lbl.text=[font fontName];
            lbl.numberOfLines=0;
            lbl.backgroundColor=[UIColor clearColor];
            lbl.textColor=[UIColor whiteColor];
            lbl.textAlignment=UITextAlignmentCenter;
            [btn setTitle:@"AaBb" forState:UIControlStateNormal];
            btn.titleLabel.font=font;
            btn.tag=tag;
            CALayer *layer1 = [btn layer];
            [layer1 setMasksToBounds:YES];
            [layer1 setCornerRadius:7.0];
            [layer1 setBorderWidth:2.0f];
            [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
            
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

    UIFont *font=[self.fontArray objectAtIndex:[sender tag]];
    txtFont=font;
    [self.txtField setFont:font];
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
        [layer1 setBorderWidth:1.0];
        [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
        
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
//    /////inverse the text field background color
//    const CGFloat *componentColors = CGColorGetComponents(textColor.CGColor);
//    
//    UIColor *revColor = [[UIColor alloc] initWithRed:(1.0 - componentColors[0])
//                                               green:(1.0 - componentColors[1])
//                                                blue:(1.0 - componentColors[2])
//                                               alpha:componentColors[3]];
//    [self.txtField setBackgroundColor:revColor];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 40) ? NO : YES;
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
