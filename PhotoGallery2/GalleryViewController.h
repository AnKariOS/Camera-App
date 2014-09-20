//
//  GalleryViewController.h
//  PhotoGallery2
//
//  Created by Andrey Karaban on 07/07/14.
//  Copyright (c) 2014 AkA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface GalleryViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>



@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *assets;
@property (strong, nonatomic) IBOutlet UIImageView *fullImage;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *galleryBtn;



- (IBAction)gallery:(id)sender;


@end
