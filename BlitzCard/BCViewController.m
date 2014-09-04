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
    UILabel *label;
    UIImagePickerController *pickerController;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (void)handlePinchLabel:(UIPinchGestureRecognizer *)recognizer;
- (void)handlePinchImage:(UIPinchGestureRecognizer *)recognizer;
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer;

@property (weak, nonatomic) IBOutlet UIView *ContainerView;
@property(nonatomic, strong) UIButton *tempImageView;
@property(nonatomic, strong) NSMutableArray *fileArray;//
@property(nonatomic, strong) UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UIView *BoundView;
@property (weak, nonatomic) IBOutlet UIImageView *BoundImageView;
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
    self.fileArray=[[NSMutableArray alloc] initWithCapacity:142];
    
    NSString *fileName;
    
    if (IS_IPHONE_5) {
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            
            fileName=@"Instructions5";
        }
        else{
            
            fileName=@"AppBackground-5";
        }
    }
    else{
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            
            fileName=@"Instructions";
        }
        else{
        
            fileName=@"AppBackground";
        }
    }
    
    //////add instruction page on front
    CGRect frame=CGRectMake(0, 0, self.view.frame.size.height, 320);
    
    _tempImageView=[UIButton buttonWithType:UIButtonTypeCustom];
    [_tempImageView setFrame:frame];
    [_tempImageView setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
    [_tempImageView setContentMode:UIViewContentModeScaleToFill];
    //////add action
    [_tempImageView addTarget:self action:@selector(tapTempImageView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_tempImageView];
    
    [self createScrollforThumb:[self loadThumbnailImages]];
}
-(NSArray*)loadThumbnailImages{

    NSMutableArray *array=[NSMutableArray array];
    
        for (int i=0; i<=141; i++) {
            
            UIImage *fileImage=[UIImage imageNamed:[NSString stringWithFormat:@"texture_thumb%i",i]];
            if ([fileImage isKindOfClass:[UIImage class]]) {
                
                [array addObject:fileImage];
            }
            else{
            
                NSLog(@"bad image found--%@\ni--%i",fileImage,i);
            }
            
        }
    
    return array;
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
    
    [self.BoundView setBackgroundColor:[UIColor clearColor]];
    ////create a file name
    NSString *fileName;
    
    if (IS_IPHONE_5)
    {
        fileName=[NSString stringWithFormat:@"texture5-%li",(long)[sender tag]];
    }
    else
    {
        fileName=[NSString stringWithFormat:@"texture%li",(long)[sender tag]];
    }
    
    NSLog(@"file name--%@", fileName);
    //////////check to see if last button pressed
    BOOL Check=[sender tag]==142;
    if (Check)
    {
        [self.BoundImageView setImage:nil];
        [self.BoundView setBackgroundColor:[UIColor clearColor]];
    }
    else{
        
        UIImage *image=[UIImage imageNamed:fileName];
        [self.BoundImageView setImage:image];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([[segue identifier] isEqualToString:@"editTextLabel"]) {
        
        BCEditLabelViewController *bvc=(BCEditLabelViewController*)segue.destinationViewController;
        bvc.delegate=self;
        bvc.textToEdit=currentLabel.text;
        bvc.textToColor=currentLabel.textColor;
        bvc.textToFont=currentLabel.font ;
        
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
    NSLog(@"%d",buttonIndex);
    
    //buttonIndex 2 is for when cancel button is pressed
    if(buttonIndex != 3) {
        
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
                 [self.imagePickerController setAutomaticallyAdjustsScrollViewInsets:YES];
                 
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
                if(buttonIndex==1){
                
                    [self showTextureView:actionSheet];
                }
                if (buttonIndex==2)
                {
                     pickerController = [[UIImagePickerController alloc] init];
                    [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    
                    pickerController.title=@"Background";
                   
//                    Imagepicker.delegate =self;
//                    Imagepicker.allowsEditing = YES;
//                    Imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                    
//                    [self presentViewController:Imagepicker animated:YES completion:NULL];
                    [pickerController setDelegate:self];
                    [pickerController setAllowsEditing:YES];
                    
                    [self presentViewController:pickerController animated:YES completion:nil];
                    
                }
              
            }
            default:
                break;
        }
        
        
        
    }

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //NSLog(@"info = %@", [info description]);
    if (picker == pickerController) {
     UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        self.BoundImageView.image = chosenImage;
        
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
  
    else{
    
    
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
    
        UIImage* newImage = selectedImage;
        
        //if (self.dragImageView==nil) {
            
             if (selectedImage) {// Create Frame till Image Selected
                 
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
         UIPinchGestureRecognizer *pinchGestureLocal = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchImage:)];
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

////handle pinch Label

- (void)handlePinchLabel:(UIPinchGestureRecognizer *)recognizer{

    //recognizer.scale=1;
    
    CGFloat pinchScale = recognizer.scale;
    pinchScale = round(pinchScale * 1000) / 1000.0;
    NSLog(@"%lf",pinchScale);
    if (pinchScale < 1)
    {
        currentLabel.font = [UIFont fontWithName:currentLabel.font.fontName size:(currentLabel.font.pointSize - pinchScale)];
         recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
         [currentLabel sizeToFit];
        recognizer.scale=1;
    }
  else
    {
        currentLabel.font = [UIFont fontWithName:currentLabel.font.fontName size:(currentLabel.font.pointSize + pinchScale)];
         recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
         [currentLabel sizeToFit];
        recognizer.scale=1;
    }
    NSLog(@"Font :%@",label.font);

}
// handel pinch image
- (void)handlePinchImage:(UIPinchGestureRecognizer *)recognizer{
    
    CGFloat pinchScale = recognizer.scale;
    pinchScale = round(pinchScale * 1000) / 1000.0;
    NSLog(@"%lf",pinchScale);
    if (pinchScale < 1)
    {
        recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
        recognizer.scale=1;
    }
    else
    {
        recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
        recognizer.scale=1;
    }
    
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
    
    label=[[UILabel alloc] init];
    [label setFrame:CGRectMake(200, 60, 250, 40)];
    label.text=@"Double Tap to edit";
    label.textColor=[UIColor darkGrayColor];
    label.autoresizesSubviews=YES;
    label.backgroundColor=[UIColor clearColor];
    label.userInteractionEnabled=YES;
    [label sizeToFit];
    [self.BoundView addSubview:label];
    //////add pan getsture on each label
    UIPanGestureRecognizer *panGestureLocal = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLabel:)];
    [label addGestureRecognizer:panGestureLocal];
    
    //////add pinch gesture on label
    UIPinchGestureRecognizer *pinchGestureLocal = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchLabel:)];
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
    
    [self.BoundView setBackgroundColor:nil];
    [self.BoundImageView setImage:nil];
    [[self.BoundView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(IBAction)returned:(UIStoryboardSegue *)segue {
    
    
}
-(void)saveTextWith:(NSString *)text txtFont:(UIFont *)font txtColor:(UIColor *)txtColor{

   [currentLabel setMinimumScaleFactor:MIN_FONT_SIZE];
    [currentLabel setText:text];
    [currentLabel setFont:font];
    [currentLabel setTextColor:txtColor];
    [currentLabel sizeToFit];         // For Adjust the Width of label
    
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
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Solid Color",@"Templates", @"Photo Album",nil];
    actionSheet.tag=102;
    [actionSheet showInView:self.view];
    
    
}
-(void)showTextureView:(id)sender{

    [UIView animateWithDuration:0.5f animations:^{
        
        if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            
            [self.TextureView setFrame:CGRectMake(0, 255-20, self.view.frame.size.width, 65)];
        }
        else
        [self.TextureView setFrame:CGRectMake(0, 255, self.view.frame.size.width, 65)];
        
    }];
}

-(IBAction)dropTextureView:(id)sender{

    [UIView animateWithDuration:0.5f animations:^{
        
        [self.TextureView setFrame:CGRectMake(0, 320, self.view.frame.size.width, 65)];
        
    }];
    
}

- (IBAction)saveAction:(id)sender {
    
    UIView* captureView = self.ContainerView;
    
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
    UIImageWriteToSavedPhotosAlbum(imageToSave ,
                                   self, // send the message to 'self' when calling the callback
                                   @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                   NULL); // you generally won't need a contextInfo here);
    
    [[[UIAlertView alloc] initWithTitle:@"digiBiz Card" message:@"Image saved to photo album" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
}
- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        // Do anything needed to handle the error or display it to the user
    } else {
        // .... do anything you want here to handle
        // .... when the image has been saved in the photo album
    }
}
- (BOOL)prefersStatusBarHidden {
    
    return YES;
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