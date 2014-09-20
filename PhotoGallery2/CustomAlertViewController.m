//
//  CustomAlertViewController.m
//  PhotoGallery2
//
//  Created by Andrey Karaban on 10/07/14.
//  Copyright (c) 2014 AkA. All rights reserved.
//

#import "CustomAlertViewController.h"


#define ANIMATION_DURATION  0.25

@interface CustomAlertViewController ()

@end

@implementation CustomAlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:0.75]];
    [_massegeLabel setFrame:CGRectMake(_massegeLabel.frame.origin.x,
                                     _massegeLabel.frame.origin.y,
                                     _massegeLabel.frame.size.width,
                                     _viewMassage.frame.size.height )];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCustomAlertInView:(UIView *)targetView withMessage:(NSString *)message
{
   float width = targetView.frame.size.width;
   float height = targetView.frame.size.height;
    
    
    [self.view setFrame:CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y, width, height)];
    
    [targetView addSubview:self.view];
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [_viewMassage setFrame:CGRectMake(0, 0, _viewMassage.frame.size.width, _viewMassage.frame.size.height)];
    [UIView commitAnimations];
    [_massegeLabel setText:message];
}

- (void)removeCustomAlertFromView
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [_viewMassage setFrame:CGRectMake(0, 0, _viewMassage.frame.size.width, _viewMassage.frame.size.height) ];
    [self.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:ANIMATION_DURATION];
}

-(void)removeCustomAlertFromViewInstantly
{
    [self.view removeFromSuperview];
}

- (void)customAlertCancel
{
    [self.delegate customAlertCancel];
}

@end
