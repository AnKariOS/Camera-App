//
//  ViewController.m
//  PhotoGallery2
//
//  Created by Andrey Karaban on 07/07/14.
//  Copyright (c) 2014 AkA. All rights reserved.
//

#import "ViewController.h"
#import "GalleryViewController.h"
#import "CustomAlertViewController.h"

#define ANIMATION_DURATION 0.25

@interface ViewController ()


@end

// Setting Private Category to add methods to determine orientation of camera controlls.
@interface UIImagePickerController (private)

- (BOOL)shouldAutorotate;
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;
- (NSUInteger)supportedInterfaceOrientations;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end


@implementation UIImagePickerController (Private)

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    //I tried to make custom alert view - but that is not working for iOS 7
    _customAlert = [[CustomAlertViewController alloc] init];
    [_customAlert setDelegate:self];
    //Setting the Background for main view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"module_bg.png"]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //Starting Alert
    UIAlertView *helloAlert = [[UIAlertView alloc]initWithTitle:@"Welcome to AmazingPhoto App" message:@"Please notice that is preffered for you to use this App just in portrait orientation" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [helloAlert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

//Setting Status Bar style
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


//- (void)alertDisapear
//{
//    [_customAlert showCustomAlertInView:self.view
//                            withMessage:@"This is an alert without buttons.\nThis message will go away in about 3 seconds."];
//    
//    [_customAlert performSelector:@selector(removeCustomAlertFromView) withObject:nil afterDelay:3.0];
//}
//- (void)customAlertCancel
//{
//    [_customAlert removeCustomAlertFromViewInstantly];
//}

#pragma mark - custom Actions

- (IBAction)takePhoto:(id)sender
{
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO))
        return;
    //Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
	imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    // Delegate is self
	imagePicker.delegate = self;
    
    // Allow editing of image ?
	imagePicker.allowsEditing = NO;
    
    // Show image picker
	
    [self presentViewController:imagePicker animated:YES completion:NULL];
    
}


#pragma mark - PickerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// Access the uncropped image from info dictionary
	UIImage *image =  [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
	// Dismiss the camera
	[self dismissViewControllerAnimated:YES completion:NULL];
    
            // Pass the image from camera to method that will email the same
            // A delay is needed so camera view can be dismissed
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
                 
        [self performSelector:@selector(emailImage:) withObject:image afterDelay:01.0];
    
    }
    
    
    if (picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary)
    {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        UIImage *originalImage, *imageToSave;
        if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
        {
            //Assign the original image to originalImage
            originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
            imageToSave = originalImage;
            
            //Add date and time to saving photo
            imageToSave= [self imageWithRenderedDateMetadata:info[UIImagePickerControllerMediaMetadata] onImage:image];
            
            // Save the image to the Camera Roll
             UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil);
        }
    }
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
	// Unable to save the image
    if (error)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:nil cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - Add date/time to image method

- (UIImage *)imageWithRenderedDateMetadata:(NSDictionary*)metadata onImage:(UIImage*)image
{
    if(!image || !metadata)
    {
        return nil;
    }
    NSDictionary *tiffMetaData = metadata[(__bridge id) kCGImagePropertyTIFFDictionary];
    NSString* dateString = tiffMetaData[(__bridge id)kCGImagePropertyTIFFDateTime];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    // Position the date in the bottom right
    NSDictionary* attributes = @{NSFontAttributeName :[UIFont boldSystemFontOfSize:30],
                                 NSStrokeColorAttributeName : [UIColor blackColor],
                                 NSForegroundColorAttributeName : [UIColor yellowColor],
                                 NSStrokeWidthAttributeName : @-2.0};
    
    const CGFloat dateWidth = [dateString sizeWithAttributes:attributes].width;
    const CGFloat dateHeight = [dateString sizeWithAttributes:attributes].height;
    const CGFloat datePadding = 25;
    
    [dateString drawAtPoint:CGPointMake(image.size.width - dateWidth - datePadding, image.size.height - dateHeight - datePadding)
             withAttributes:attributes];
    
    // Get the final image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - imageForEmail

- (void)emailImage:(UIImage *)image
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
	// Set the subject of email
    [picker setSubject:@""];
    
	// Add email addresses
    // Notice three sections: "to" "cc" and "bcc"
	[picker setToRecipients:[NSArray arrayWithObjects:@"", nil]];
	[picker setCcRecipients:[NSArray arrayWithObject:@""]];
	[picker setBccRecipients:[NSArray arrayWithObject:@""]];
    
	// Fill out the email body text
	NSString *emailBody = @"";
    
	// This is not an HTML formatted email
	[picker setMessageBody:emailBody isHTML:NO];
    
    // Create NSData object as PNG image data from camera image
    UIImage *ImgOut = [self scaleAndRotateImage:image];
    NSData *data = UIImagePNGRepresentation(ImgOut);
    
	// Attach image data to the email
	// 'CameraImage.png' is the file name that will be attached to the email
	[picker addAttachmentData:data mimeType:@"image/png" fileName:@""];
	// Show email view
	[self presentViewController:picker animated:YES completion:NULL];

    
}

#pragma mark MFMailComposerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent: {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"E-mail response" message:@"YOUR PHOTO sent by email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            break;
        }
        case MFMailComposeResultFailed:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Physical rotation of Image

- (UIImage *) scaleAndRotateImage: (UIImage *) imageIn

{
    int kMaxResolution = 3264; // Or whatever
    
    CGImageRef        imgRef    = imageIn.CGImage;
    CGFloat           width     = CGImageGetWidth(imgRef);
    CGFloat           height    = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect            bounds    = CGRectMake( 0, 0, width, height );
    
    if ( width > kMaxResolution || height > kMaxResolution )
    {
        CGFloat ratio = width/height;
        
        if (ratio > 1)
        {
            bounds.size.width  = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
        {
            bounds.size.height = kMaxResolution;
            bounds.size.width  = bounds.size.height * ratio;
        }
    }
    
    CGFloat            scaleRatio   = bounds.size.width / width;
    CGSize             imageSize    = CGSizeMake( CGImageGetWidth(imgRef),         CGImageGetHeight(imgRef) );
    UIImageOrientation orient       = imageIn.imageOrientation;
    CGFloat            boundHeight;
    
    switch(orient)
    {
        case UIImageOrientationUp:                                        //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored:                                //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:                                      //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:                              //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored:                              //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft:                                      //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:                             //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:                                     //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise: NSInternalInconsistencyException
                        format: @"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext( bounds.size );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ( orient == UIImageOrientationRight || orient == UIImageOrientationLeft )
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM( context, transform );
    
    CGContextDrawImage( UIGraphicsGetCurrentContext(), CGRectMake( 0, 0, width, height ), imgRef );
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return( imageCopy );
}

@end
