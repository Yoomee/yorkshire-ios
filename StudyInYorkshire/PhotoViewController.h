//
//  PhotoViewController.h
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 05/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NimbusCore.h"
#import "NimbusPhotos.h"

@interface PhotoViewController : UIViewController <NIPhotoAlbumScrollViewDataSource,NIPhotoAlbumScrollViewDelegate>


@property (weak, nonatomic) NIPhotoAlbumScrollView *photoAlbumScrollView;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic) int centerPageIdx;

@end
