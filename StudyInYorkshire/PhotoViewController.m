//
//  SecondViewController.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 05/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "PhotoViewController.h"
#import "AppDelegate.h"
#import "Photo.h"
#import "CaptionedPhotoView.h"

@implementation PhotoViewController
@synthesize photoAlbumScrollView = _photoAlbumScrollView;
@synthesize photos = _photos;
@synthesize centerPageIdx;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setPhotoAlbumScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if(_photoAlbumScrollView == nil){
        NIPhotoAlbumScrollView *photoAlbumScrollView = [[NIPhotoAlbumScrollView alloc] initWithFrame:self.view.bounds];
        photoAlbumScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [photoAlbumScrollView setDataSource:self];
        [photoAlbumScrollView setDelegate:self];
        [self.view addSubview:photoAlbumScrollView];
        [photoAlbumScrollView reloadData];
        self.photoAlbumScrollView = photoAlbumScrollView;
    }
    [_photoAlbumScrollView setCenterPageIndex:centerPageIdx];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark NIPhotoAlbumScrollViewDataSource


- (NSInteger)numberOfPagesInPagingScrollView:(NIPhotoAlbumScrollView *)photoScrollView {
    return [self.photos count];
}


- (UIImage *)photoAlbumScrollView: (NIPhotoAlbumScrollView *)photoAlbumScrollView
                     photoAtIndex: (NSInteger)photoIndex
                        photoSize: (NIPhotoScrollViewPhotoSize *)photoSize
                        isLoading: (BOOL *)isLoading
          originalPhotoDimensions: (CGSize *)originalPhotoDimensions {
    *photoSize = NIPhotoScrollViewPhotoSizeThumbnail;
    Photo *photo = [self.photos objectAtIndex:photoIndex];
    return photo.image;
}

- (UIView<NIPagingScrollViewPage>*)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex {
    UIView<NIPagingScrollViewPage>* pageView = nil;
    NSString* reuseIdentifier = @"photo";
    pageView = [pagingScrollView dequeueReusablePageWithIdentifier:reuseIdentifier];
    if (nil == pageView) {
        pageView = [[CaptionedPhotoView alloc] init];
        pageView.reuseIdentifier = reuseIdentifier;
    }
    Photo *photo = [self.photos objectAtIndex:pageIndex];
    CaptionedPhotoView* captionedView = (CaptionedPhotoView *)pageView;
    if(photo.caption)
    captionedView.caption = photo.caption;
    return pageView;
}
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self.photoAlbumScrollView setHidden:YES];
}
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.photoAlbumScrollView reloadData];
    [self.photoAlbumScrollView setHidden:NO];
}

@end
