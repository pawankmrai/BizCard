//
//  BCViewController.m
//  BlitzCard
//
//  Created by Pawan Rai on 7/24/13.
//  Copyright (c) 2013 AppStudioz. All rights reserved.
//

#import "BCViewController.h"
#import "BCEditLabelViewController.h"
#import "ColorViewController.h"

#define MIN_FONT_SIZE 12.0f
#define FONT_SIZE 16.0f


@interface BCViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,BCEditLabelDelegate,BSColorSelectionDelegate>
{

    CGFloat beginX;
    CGFloat beginY;
    UILabel *currentLabel;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer;

@property(nonatomic, strong) UIButton *tempImageView;
@property(nonatomic, strong) NSMutableArray *fileArray;
@property(nonatomic, strong) NSMutableArray *thumbArray;
@property(nonatomic, strong) UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UIView *BoundView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIView *TextureView;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) UIImageView *dragImageView;
- (IBAction)addImageAction:(id)sender;
- (IBAction)changeBackground:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)addLabelAction:(id)sender;
- (IBAction)clearCanvasAction:(id)sender;

@end

@implementation BCViewController
@synthesize currentLabel=currentLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    self.fileArray=[[NSMutableArray alloc] init];
    self.thumbArray=[[NSMutableArray alloc] init];
    
    //////add instruction page on front
    CGRect frame=CGRectMake(0, 20, 480, 320);
    _tempImageView=[UIButton buttonWithType:UIButtonTypeCustom];
    [_tempImageView setFrame:frame];
    [_tempImageView setImage:[UIImage imageNamed:@"AppBackground"] forState:UIControlStateNormal];
    //////add action
    [_tempImageView addTarget:self action:@selector(tapTempImageView:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_tempImageView];    
    
    //////add all texture files file
    for (int i=1; i<=78; i++) {
        
        UIImage *fileImage=[UIImage imageNamed:[NSString stringWithFormat:@"texture%i",i]];
        [self.fileArray addObject:fileImage];
    }
    
    //////add all texture files file
    for (int i=1; i<=78; i++) {
        
        UIImage *thumbImage=[UIImage imageNamed:[NSString stringWithFormat:@"texture_thumb%i",i]];
        [self.thumbArray addObject:thumbImage];
    }
    [self createScrollforThumb:self.thumbArray];
}
-(void)tapTempImageView:(UIButton*)recognizer{

    [recognizer removeFromSuperview];
    
}
-(void)createScrollforThumb:(NSArray*)thumbArray{
    
        int xOffset= 2;
        int tag =0;
        for (UIImage *image in thumbArray) {
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:image forState:UIControlStateNormal];
            btn.tag=tag;
            CALayer *layer1 = [btn layer];
            [layer1 setMasksToBounds:YES];
            [layer1 setCornerRadius:7.0];
            [layer1 setBorderWidth:1.0];
            [layer1 setBorderColor:[[UIColor blackColor] CGColor]];
            
            btn.frame = CGRectMake(xOffset, 5, 60, 55);
            [btn addTarget:self action:@selector(performTextureEffect:) forControlEvents:UIControlEventTouchUpInside];
            [self.ScrollView addSubview:btn];
            xOffset+=70;
            tag++;
        }
    
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(xOffset, 5, 60, 55)];
        [btn setTitle:@"None" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.461 green:0.544 blue:0.664 alpha:1.000] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTag:tag];
        [btn addTarget:self action:@selector(performTextureEffect:) forControlEvents:UIControlEventTouchUpInside];
        [self.ScrollView addSubview:btn];
        xOffset+=70;
        self.ScrollView.contentSize=CGSizeMake(xOffset, 65);
}
-(void)performTextureEffect:(UIButton*)sender{
    
    BOOL Check=[sender tag]==[self.fileArray count];
    if (Check) {
        
        [self.BoundView setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        UIImage *image=[self.fileArray objectAtIndex:[sender tag]];
    
        [self.BoundView setBackgroundColor:[UIColor colorWithPatternImage:image]];
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([[segue identifier] isEqualToString:@"editTextLabel"]) {
        
        BCEditLabelViewController *bvc=(BCEditLabelViewController*)segue.destinationViewController;
        bvc.delegate=self;
        bvc.textToEdit=currentLabel.text;
    }
   
}

///////BSColorSelectionDelegate function
-(void)finishWithColorSelection:(UIColor *)selectedColor{

    [self.BoundView setBackgroundColor:selectedColor];
    
}
//////code for select image and drag functionality///
- (IBAction)addImageAction:(id)sender {
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Album", nil];
    actionSheet.tag=101;
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    //buttonIndex 2 is for when cancel button is pressed
    if(buttonIndex != 2) {
        
        switch (actionSheet.tag) {
            case 101:
             {
               
                if (!self.imagePickerController) {
                    
                    self.imagePickerController = [[UIImagePickerController alloc] init];
                }
                
                if(buttonIndex == 1) {
                    
                    [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    
                } else {
                    
                    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                    {
                        [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                    }
                    else
                    {
                        [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    }
                    
                }
                
                [self.imagePickerController setDelegate:self];
                [self.imagePickerController setAllowsEditing:YES];
                
                [self presentViewController:self.imagePickerController animated:YES completion:nil];
              }
                
                break;
                
            case 102:
            {
            
                if (buttonIndex==0) {
                    
                    //NSLog(@"open color wheel");
                    [self dropTextureView:actionSheet];
                    
                    ColorViewController *cvc=[[ColorViewController alloc] init];
                    cvc.delegate=self;
                    [self presentViewController:cvc animated:YES completion:nil];
                }
                else{
                
                    [self showTextureView:actionSheet];
                }
                
            }
                
                
            default:
                break;
        }
    }

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //NSLog(@"info = %@", [info description]);
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
    
        UIImage* newImage = selectedImage;
        
        if (self.dragImageView==nil) {
            
            self.dragImageView=[[UIImageView alloc] initWithFrame:CGRectMake(44, 44, 200, 200)];
            [self.dragImageView setBackgroundColor:[UIColor clearColor]];
        }
        
        [_dragImageView setImage:newImage];
        _dragImageView.userInteractionEnabled=YES;
        [self.BoundView addSubview:_dragImageView];
        //////drag image
        UIPanGestureRecognizer *panGestureLocal = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImageView:)];
        [_dragImageView addGestureRecognizer:panGestureLocal];
        
        ////pinch image
         UIPinchGestureRecognizer *pinchGestureLocal = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [_dragImageView addGestureRecognizer:pinchGestureLocal];
        
        ////rotate
        UIRotationGestureRecognizer *rotateGestureLocal = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
        [_dragImageView addGestureRecognizer:rotateGestureLocal];
        
        UILongPressGestureRecognizer *pressGestureLocal = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressImage:)];
        pressGestureLocal.minimumPressDuration=2.0f;
        [_dragImageView addGestureRecognizer:pressGestureLocal];
        
        //[panGestureLocal requireGestureRecognizerToFail:pinchGestureLocal];
        //[pinchGestureLocal requireGestureRecognizerToFail:rotateGestureLocal];
        
    }];
}
-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
////handle pinch
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer{

    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}
///handle rotate
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer{
    
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}
///handle drag
-(void)moveImageView:(UIPanGestureRecognizer *)recognizer
{
    
    [self.view bringSubviewToFront:[recognizer view]];
    CGPoint newCenter = [recognizer translationInView:self.view];
	if([recognizer state] == UIGestureRecognizerStateBegan)
    {
		beginX = recognizer.view.center.x;
		beginY = recognizer.view.center.y;
    }
    newCenter = CGPointMake(beginX + newCenter.x, beginY + newCenter.y);
    [recognizer.view setCenter:newCenter];
    
}
-(void)pressImage:(UILongPressGestureRecognizer*)recognizer{
    
    UIImageView *imageView=(UIImageView*)[recognizer view];
    [imageView removeFromSuperview];
    
}
////drag view delegate methods

/////////////////////////////////////////////////////

- (IBAction)addLabelAction:(id)sender {
    
    UILabel *label=[[UILabel alloc] init];
    [label setFrame:CGRectMake(200, 60, 200, 30)];
    label.text=@"Double Tap to edit";
    label.textColor=[UIColor darkGrayColor];
    label.backgroundColor=[UIColor clearColor];
    label.userInteractionEnabled=YES;
    [self.BoundView addSubview:label];
    //////add pan getsture on each label
    UIPanGestureRecognizer *panGestureLocal = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLabel:)];
    [label addGestureRecognizer:panGestureLocal];
    
    //////add pinch gesture on label
    UIPinchGestureRecognizer *pinchGestureLocal = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [label addGestureRecognizer:pinchGestureLocal];
    /////////add action on label
    UITapGestureRecognizer *tapGestureLocal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
    tapGestureLocal.numberOfTapsRequired=2;
    [label addGestureRecognizer:tapGestureLocal];
    
    UILongPressGestureRecognizer *pressGestureLocal = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressLabel:)];
    pressGestureLocal.minimumPressDuration=1.0f;
    [label addGestureRecognizer:pressGestureLocal];
    
    ///////making easy to pan the text label
    //[panGestureLocal requireGestureRecognizerToFail:pinchGestureLocal];
}

- (IBAction)clearCanvasAction:(id)sender {
    
    [self.BoundView setBackgroundColor:[UIColor whiteColor]];
    [[self.BoundView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(IBAction)returned:(UIStoryboardSegue *)segue {
    
    
}
-(void)saveTextWith:(NSString *)text txtFont:(UIFont *)font txtColor:(UIColor *)txtColor{

    [currentLabel setMinimumScaleFactor:MIN_FONT_SIZE];
    [currentLabel setText:text];
    [currentLabel setFont:font];
    [currentLabel setTextColor:txtColor];
    
}
-(void)pressLabel:(UILongPressGestureRecognizer*)recognizer{

    currentLabel=(UILabel*)[recognizer view];
    [currentLabel removeFromSuperview];
    
}
-(void)tapLabel:(UITapGestureRecognizer*)recognizer{
    
    currentLabel=(UILabel*)[recognizer view];
    
    [self performSegueWithIdentifier:@"editTextLabel" sender:recognizer];
}

//////make label dragable
-(void)moveLabel:(UIPanGestureRecognizer *)recognizer
{
    [self.view bringSubviewToFront:[recognizer view]];
    CGPoint newCenter = [recognizer translationInView:self.view];
	if([recognizer state] == UIGestureRecognizerStateBegan)
    {
		beginX = recognizer.view.center.x;
		beginY = recognizer.view.center.y;
    }
    newCenter = CGPointMake(beginX + newCenter.x, beginY + newCenter.y);
    [recognizer.view setCenter:newCenter];
}
///////////changing back ground of the screen


- (IBAction)changeBackground:(id)sender {
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Solid Color",@"Templates", nil];
    actionSheet.tag=102;
    [actionSheet showInView:self.view];
    
    
}
-(void)showTextureView:(id)sender{

    [UIView animateWithDuration:0.5f animations:^{
        
        
        [self.TextureView setFrame:CGRectMake(0, 255, self.view.frame.size.width, 65)];
        
    }];
}

-(IBAction)dropTextureView:(id)sender{

    [UIView animateWithDuration:0.5f animations:^{
        
        [self.TextureView setFrame:CGRectMake(0, 320, self.view.frame.size.width, 65)];
        
    }];
    
}

- (IBAction)saveAction:(id)sender {
    
    UIView* captureView = self.BoundView;
    
    /* Capture the screen shoot at native resolution */
    UIGraphicsBeginImageContextWithOptions(captureView.bounds.size, captureView.opaque, 0.0);
    [captureView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /* Render the screen shot at custom resolution */
    CGRect cropRect = self.view.frame;
    UIGraphicsBeginImageContextWithOptions(cropRect.size, captureView.opaque, 1.0f);
    [screenshot drawInRect:cropRect];
    UIImage * customScreenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *imageToSave =[UIImage imageWithCGImage:[customScreenShot CGImage]
                        scale:1.0
                  orientation: UIImageOrientationUp];
    
    /* Save to the photo album */
    UIImageWriteToSavedPhotosAlbum(imageToSave , nil, nil, nil);
    
    [[[UIAlertView alloc] initWithTitle:@"digiBiz Card" message:@"Image saved to photo album" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setBoundView:nil];
    [self setScrollView:nil];
    [self setTextureView:nil];
    [super viewDidUnload];
}
@end