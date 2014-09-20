//
//  PhotoCell.m
//  PhotoGallery2
//
//  Created by Andrey Karaban on 07/07/14.
//  Copyright (c) 2014 AkA. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell ()


// 1
@property(nonatomic, weak) IBOutlet UIImageView *photoImageView;
@end

@implementation PhotoCell
- (void) setAsset:(ALAsset *)asset
{
    // 2
    _asset = asset;
    self.photoImageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
}



@end