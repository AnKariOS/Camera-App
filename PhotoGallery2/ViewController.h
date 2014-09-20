//
//  ViewController.h
//  PhotoGallery2
//
//  Created by Andrey Karaban on 07/07/14.
//  Copyright (c) 2014 AkA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/CGImageProperties.h>
#import "CustomAlertViewController.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate, CustomAlertViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *galleryBtn;
@property (strong, nonatomic) IBOutlet UIButton *photoBtn;
@property (nonatomic, strong) CustomAlertViewController *customAlert;

- (IBAction)takePhoto:(id)sender;



@end
