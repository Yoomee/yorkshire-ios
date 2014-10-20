//
//  SecondViewController.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 05/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoViewController.h"
#import "AppDelegate.h"
#import "Photo.h"

@implementation PhotosViewController
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    int photoIdx = 0;
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    for (id object in [self.fetchedResultsController fetchedObjects]){
        Photo *photo = (Photo *)object;
        
        UIButton *imageButton = [[UIButton alloc] init];
        if(iPad)
            imageButton.frame = CGRectMake(0,0,100,100);
        else
            imageButton.frame = CGRectMake(2 + ((photoIdx % 4) * 79), 2 + ((photoIdx / 4) * 79), 79, 79);
        imageButton.tag = photoIdx + 1;
        [imageButton addTarget:self action:@selector(didPressImageButton:) forControlEvents:UIControlEventTouchUpInside];
        CGRect imageFrame = iPad ? CGRectMake(0, 0,100, 100) : CGRectMake(2, 2,75, 75);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setAutoresizingMask: UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [imageView setClipsToBounds:YES];
        [imageView setImage:photo.thumb];
        [imageButton addSubview:imageView];
        [self.view addSubview:imageButton];
        photoIdx++;
    }
    UIScrollView *scrollView = (UIScrollView *)self.view;
    CGSize contentSize = scrollView.contentSize;
    contentSize.height = ((int)((((float)photoIdx)/4) + 0.5) * 79) + 4;
    [scrollView setContentSize:contentSize];
    
    self.navigationController.navigationBarHidden = YES;
}

-(void) layoutTilesForInterfaceOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated{
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    if(iPad){
        UIScrollView *scrollView = (UIScrollView *)self.view;
        int cols;
        float tileSize, padding, screenWidth, screenHeight, offsetCenterY;
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            cols = 4;
            tileSize = 185;
            padding = 6;
            screenWidth = 768;
            screenHeight = 1024;
            offsetCenterY = scrollView.contentOffset.y * (3928.0/2126.0);
        } else {
            cols = 6;
            tileSize = 165;
            padding = 2;
            screenWidth = 1024;
            screenHeight = 768;
            offsetCenterY = scrollView.contentOffset.y * (2126.0/3928.0);
        }
        
        if(animated){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.2];
            [UIView setAnimationBeginsFromCurrentState:YES];
        }
        int photoIdx = 0;
        for(int i=0;i < scrollView.subviews.count; i++){
            UIView *subView = [scrollView.subviews objectAtIndex:i];
            if(subView.tag != 0){
                CGRect frame = subView.frame;
                frame = CGRectMake(padding + ((photoIdx)%cols)*(tileSize+5), (padding + ((photoIdx)/cols)*(tileSize+5)), tileSize, tileSize);
                [subView setFrame:frame];
                photoIdx++;
            }
        }
        [scrollView setContentSize:CGSizeMake(screenWidth, (tileSize + 5) * (int)round((([[self.fetchedResultsController fetchedObjects] count] + 1.0)/cols)+0.5) + (2*padding))];
        if (animated)
            [scrollView setContentOffset:CGPointMake(0, offsetCenterY) animated:NO];
        if(animated){
            [UIView commitAnimations];
        }
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self layoutTilesForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] animated:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
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

- (void) didPressImageButton:(id) sender{
    [self performSegueWithIdentifier:@"showPhoto" sender:sender];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showPhoto"]){
        PhotoViewController *photoViewController = (PhotoViewController *)segue.destinationViewController;
        [photoViewController setPhotos:[[self fetchedResultsController] fetchedObjects]];
        [photoViewController setCenterPageIdx:[sender tag] - 1.0];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    if (self.managedObjectContext == nil) 
    { 
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}  

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self layoutTilesForInterfaceOrientation:toInterfaceOrientation animated:YES];

}

@end
