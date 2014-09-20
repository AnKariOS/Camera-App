//
//  CustomAlertViewController.h
//  PhotoGallery2
//
//  Created by Andrey Karaban on 10/07/14.
//  Copyright (c) 2014 AkA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAlertViewControllerDelegate

- (void)customAlertCancel;

@end


@interface CustomAlertViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *viewMassage;
@property (weak, nonatomic) IBOutlet UILabel *massegeLabel;
@property (nonatomic, retain) id<CustomAlertViewControllerDelegate>delegate;

-(void)showCustomAlertInView:(UIView *)targetView withMessage:(NSString *)message;
-(void)removeCustomAlertFromView;
-(void)removeCustomAlertFromViewInstantly;


@end
