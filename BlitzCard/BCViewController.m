//
//  BCViewController.m
//  BlitzCard
//
//  Created by Pawan Rai on 7/24/13.
//  Copyright (c) 2013 AppStudioz. All rights reserved.
//

#import "BCViewController.h"
#import "SEDraggable.h"
#import "SEDraggableLocation.h"
#import "BCEditLabelViewController.h"

#define FONT_SIZE 16.0f
#define LABEL_CONTENT_WIDTH 100.0f
#define LABEL_CONTENT_MARGIN 5.0f

#define OBJECT_WIDTH 100.0f
#define OBJECT_HEIGHT 100.0f
#define MARGIN_VERTICAL 5.0f
#define MARGIN_HORIZONTAL 5.0f
#define DRAGGABLE_LOCATION_WIDTH  ((OBJECT_WIDTH  * 3) + (MARGIN_HORIZONTAL * 5))
#define DRAGGABLE_LOCATION_HEIGHT ((OBJECT_HEIGHT * 3) + (MARGIN_VERTICAL   * 5))

@interface BCViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,BCEditLabelDelegate>
{

    CGFloat beginX;
    CGFloat beginY;
    UILabel *currentLabel;
}
/////change background button action
- (IBAction)ChangeBackgroundAction:(UIButton*)sender;

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer;
@property(nonatomic, strong) UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UIView *BoundView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIView *TextureView;
@property (nonatomic, unsafe_unretained, readwrite) SEDraggableLocation *draggableLocation;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) UIImageView *dragImageView;
- (IBAction)addImageAction:(id)sender;
- (IBAction)changeBackground:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)addLabelAction:(id)sender;
@end

@implementation BCViewController
@synthesize draggableLocation = _draggableLocation;
@synthesize currentLabel=currentLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    BCEditLabelViewController *bvc=(BCEditLabelViewController*)segue.destinationViewController;
    bvc.delegate=self;
    bvc.textToEdit=currentLabel.text;
}

//////code for select image and drag functionality///
- (IBAction)addImageAction:(id)sender {
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Album", nil];
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //buttonIndex 2 is for when cancel button is pressed
    if(buttonIndex != 2) {
        
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

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //NSLog(@"info = %@", [info description]);
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
    
        UIImage* newImage = [self imageWithImage:selectedImage scaledToWidth:100];
        
        if (self.dragImageView==nil) {
            
            self.dragImageView=[[UIImageView alloc] initWithFrame:CGRectMake(44, 44, 200, 200)];
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
////pinch
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer{

    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}
///rotate
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer{
    
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}
///drag
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
////drag view delegate methods

/////////////////////////////////////////////////////

- (IBAction)addLabelAction:(id)sender {
    
    UILabel *label=[[UILabel alloc] init];
    [label setFrame:CGRectMake(200, 60, 150, 30)];
    label.text=@"Double Tap to edit";
    label.font=[UIFont fontWithName:@"Halvetica" size:FONT_SIZE];
    label.backgroundColor=[UIColor clearColor];
    label.userInteractionEnabled=YES;
    [self.BoundView addSubview:label];
    //////add pan getsture on each label
    UIPanGestureRecognizer *panGestureLocal = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLabel:)];
    [label addGestureRecognizer:panGestureLocal];
    
    /////////add action on label
    UITapGestureRecognizer *tapGestureLocal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
    tapGestureLocal.numberOfTapsRequired=2;
    [label addGestureRecognizer:tapGestureLocal];
    
    UILongPressGestureRecognizer *pressGestureLocal = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressLabel:)];
    pressGestureLocal.minimumPressDuration=1.0f;
    [label addGestureRecognizer:pressGestureLocal];

}


-(void)finishedSavingTextMessages{
    
    int i=60;
    for (NSString *message in self.stringArray) {
        
        if ([message length]>0) {
            
            UILabel *label=[[UILabel alloc] init];
            [label setFrame:CGRectMake(200, i, 150, 30)];
            label.text=message;
            label.font=[UIFont fontWithName:@"Halvetica" size:FONT_SIZE];
            label.backgroundColor=[UIColor clearColor];
            label.tag=[self.stringArray indexOfObject:message];
            label.userInteractionEnabled=YES;
            [self.BoundView addSubview:label];
            //////add pan getsture on each label
            UIPanGestureRecognizer *panGestureLocal = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLabel:)];
            [label addGestureRecognizer:panGestureLocal];
            
            /////////add action on label
            UITapGestureRecognizer *tapGestureLocal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
            tapGestureLocal.numberOfTapsRequired=2;
            [label addGestureRecognizer:tapGestureLocal];

            i+=40;
        }
    }
}
-(CGSize)calculateSizeOfString:(NSString*)text{

    CGSize constraint = CGSizeMake(LABEL_CONTENT_WIDTH - (LABEL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size;
}
-(IBAction)returned:(UIStoryboardSegue *)segue {
    
    
}
-(void)saveTextWith:(NSString *)text txtFont:(NSString *)fontName txtColor:(UIColor *)txtColor{

    
    [currentLabel setText:text];
    [currentLabel setFont:[UIFont fontWithName:fontName size:FONT_SIZE]];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    [textField removeFromSuperview];
    if ([textField.text length]==0) {
        [currentLabel removeFromSuperview];
    }
    currentLabel.text=textField.text;
    currentLabel.hidden=NO;
    return YES;
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

- (IBAction)ChangeBackgroundAction:(UIButton*)sender {
    
    switch ([sender tag]) {
        case 101:
            
            [self.BoundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture1"]]];
            break;
        case 102:
            [self.BoundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture2"]]];
            break;
        case 103:
            [self.BoundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture3"]]];
            break;
        case 104:
            [self.BoundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture4"]]];
            break;
        case 105:
            [self.BoundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture5"]]];
            break;
        case 106:
            [self.BoundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture6"]]];
            break;
        case 107:
            [self.BoundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture7"]]];
            break;
        default:
            
            break;
    }
    
}

- (IBAction)changeBackground:(id)sender {
    
    [self.ScrollView setContentSize:CGSizeMake(500, 49)];
    [UIView animateWithDuration:0.5f animations:^{
    
        [self.TextureView setFrame:CGRectMake(0, 207, 480, 49)];
    
    }];
}
-(IBAction)DropTextureView:(id)sender{

    [UIView animateWithDuration:0.5f animations:^{
        
        [self.TextureView setFrame:CGRectMake(0, 255, 480, 49)];
        
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
    CGRect cropRect = CGRectMake(0 ,0 ,480 ,320);
    UIGraphicsBeginImageContextWithOptions(cropRect.size, captureView.opaque, 1.0f);
    [screenshot drawInRect:cropRect];
    UIImage * customScreenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /* Save to the photo album */
    UIImageWriteToSavedPhotosAlbum(customScreenShot , nil, nil, nil);
    
    [[[UIAlertView alloc] initWithTitle:@"Blitz Card" message:@"Image saved to photo album" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
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

/*
 #pragma mark MakeImageDragable methods
 - (void) setupDraggableLocations {
 
 // set up the SEDraggableLocations
 CGRect frameArea=CGRectMake(0, 44, 200, 256);
 SEDraggableLocation *draggableLocationArea = [[SEDraggableLocation alloc] initWithFrame:frameArea];
 
 // you always want your SEDraggableLocations to be transparent -- otherwise, SEDraggable
 // objects will sometimes seem to hide behind certain locations while being dragged
 draggableLocationArea.backgroundColor = [UIColor clearColor];
 
 // ... however, we can put clear SEDraggableLocations in front of UIViews
 // that have background images or colors to circumvent this obstacle
 UIView *Wrapper    = [[UIView alloc] initWithFrame: draggableLocationArea.frame];
 Wrapper.backgroundColor    = [UIColor lightGrayColor];
 [self.view addSubview: Wrapper];
 
 [self.view addSubview: draggableLocationArea];
 
 [self configureDraggableLocation: draggableLocationArea];
 self.draggableLocation = draggableLocationArea;
 }
 
 
 
 - (void) configureDraggableLocation:(SEDraggableLocation *)draggableLocation {
 // set the width and height of the objects to be contained in this SEDraggableLocation (for spacing/arrangement purposes)
 draggableLocation.objectWidth = OBJECT_WIDTH;
 draggableLocation.objectHeight = OBJECT_HEIGHT;
 
 // set the bounding margins for this location
 draggableLocation.marginLeft = MARGIN_HORIZONTAL;
 draggableLocation.marginRight = MARGIN_HORIZONTAL;
 draggableLocation.marginTop = MARGIN_VERTICAL;
 draggableLocation.marginBottom = MARGIN_VERTICAL;
 
 // set the margins that should be preserved between auto-arranged objects in this location
 draggableLocation.marginBetweenX = MARGIN_HORIZONTAL;
 draggableLocation.marginBetweenY = MARGIN_VERTICAL;
 
 // set up highlight-on-drag-over behavior
 draggableLocation.highlightColor = [UIColor lightGrayColor].CGColor;
 draggableLocation.highlightOpacity = 0.4f;
 draggableLocation.shouldHighlightOnDragOver = YES;
 
 // you may want to toggle this on/off when certain events occur in your app
 draggableLocation.shouldAcceptDroppedObjects = YES;
 
 // set up auto-arranging behavior
 draggableLocation.shouldKeepObjectsArranged = NO;
 draggableLocation.fillHorizontallyFirst = YES; // NO makes it fill rows first
 draggableLocation.allowRows = YES;
 draggableLocation.allowColumns = YES;
 draggableLocation.shouldAnimateObjectAdjustments = YES; // if this is set to NO, objects will simply appear instantaneously at their new positions
 draggableLocation.animationDuration = 0.5f;
 draggableLocation.animationDelay = 0.0f;
 draggableLocation.animationOptions = UIViewAnimationOptionLayoutSubviews ; // UIViewAnimationOptionBeginFromCurrentState;
 
 draggableLocation.shouldAcceptObjectsSnappingBack = YES;
 }
 - (void) setupDraggableObjects:(UIImage*)image {
 
 UIImageView *draggableImageView = [[UIImageView alloc] initWithImage: image];
 SEDraggable *draggable = [[SEDraggable alloc] initWithImageView: draggableImageView];
 [self configureDraggableObject: draggable];
 
 }
 - (void) configureDraggableObject:(SEDraggable *)draggable {
 draggable.homeLocation = self.draggableLocation;
 [draggable addAllowedDropLocation: self.draggableLocation];
 [self.draggableLocation addDraggableObject:draggable animated:NO];
 }
 */
//////////////////////////////////////////////////////////////////////////////////////////////////

