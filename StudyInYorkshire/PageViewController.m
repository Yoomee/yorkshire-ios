//
//  PageViewController.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 05/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "PageViewController.h"
#import "FavouritesViewController.h"
#import "AppDelegate.h"
#import "Page.h"
#import "ActionButton.h"
#import <QuartzCore/QuartzCore.h>

@interface PageViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
- (void)configureNavbar;
@end

@implementation PageViewController
@synthesize favouriteButton = _favouriteButton;
@synthesize actionButtons = _actionButtons;

@synthesize page = _page;
@synthesize detailViewController = _detailViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize masterPopoverController = _masterPopoverController;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}
- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{   
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    aWebView.scrollView.scrollEnabled = NO;    // Property available in iOS 5.0 and later 
    CGRect frame = aWebView.frame;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = 1;
    aWebView.frame = frame;
    frame.size.height = aWebView.scrollView.contentSize.height + (iPad ? 38 : 16);
    if((frame.size.height + frame.origin.y + self.actionButtons.frame.size.height - 44) < self.view.frame.size.height){
        frame.size.height = self.view.frame.size.height - frame.origin.y - self.actionButtons.frame.size.height - 44;
    }
    aWebView.frame = frame;       // Set the scrollView contentHeight back to the frame itself.
    UIScrollView *scrollView = (UIScrollView *)self.view;
    CGSize contentSize = scrollView.contentSize;
    contentSize.height = frame.size.height + frame.origin.y;
    CGRect actionButtonsFrame = self.actionButtons.frame;
    actionButtonsFrame.origin.y = contentSize.height;
    [self.actionButtons setFrame:actionButtonsFrame];
    [self.actionButtons setHidden:NO];
    contentSize.height += self.actionButtons.frame.size.height;
    [scrollView setContentSize:contentSize];
}

- (void)setPage:(Page *)newPage
{
    if (_page != newPage) {
        _page = newPage;
        // Update the view.
        UIScrollView *scrollView = (UIScrollView *)self.view;
        [scrollView setContentOffset:CGPointMake(0, 0)];
        [self configureView];
    }
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }    
}

- (void)viewDidUnload
{
    [self setFavouriteButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configureNavbar];
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
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Page" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(slug = %@)", @"mobile-app"];
    [fetchRequest setPredicate:predicate];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
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

- (void)handleSwipe:(UIGestureRecognizer*)recognizer {
    [self.masterPopoverController presentPopoverFromBarButtonItem:self.navigationItem.backBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)configureView
{
    if (_page == nil) {
        self.page = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    } else{
        self.navigationItem.title = _page.title;
    }
    [self configureNavbar];
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    if(iPad){
        if(_detailViewController == nil){
            self.detailViewController = (PageViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
            self.splitViewController.delegate = self.detailViewController;
        }
        for(id object in self.view.subviews){
            UIView *subview = (UIView *)object;
            [subview removeFromSuperview];
        }
        UISwipeGestureRecognizer* swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeGestureRecognizer];
    }
    
    UIFont *titleFont = [UIFont fontWithName:@"Palatino-Bold" size:21.0];
    
    if([_page.children count] > 0){
        UIScrollView *scrollView = (UIScrollView *)self.view;
        __block float offset = 16;
        NSUInteger count = 0;
        for(id object in _page.sortedChildren){
            Page *childPage = object;
            float xOffset = 20 + (23 * [Page offsetForIndex:count]);
            NSString *title = childPage.title;
            CGSize constrainedSize = [title sizeWithFont:titleFont constrainedToSize:CGSizeMake(200, 99999999) lineBreakMode:UILineBreakModeWordWrap];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, offset, constrainedSize.width + 30, constrainedSize.height + 12)];
            [button setBackgroundColor:childPage.color];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
            [button.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
            [button.titleLabel setNumberOfLines:0];
            [button.titleLabel setTextAlignment:UITextAlignmentCenter];
            [button.titleLabel setFont:titleFont];
            [button setTitle:childPage.title forState:UIControlStateNormal];
            [button setTag:count];
            [button addTarget:self action:@selector(didPressPageButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button.layer.masksToBounds = NO;
            button.layer.shadowColor = [UIColor blackColor].CGColor;
            button.layer.shadowOpacity = 0.5;
            button.layer.shadowRadius = 10;
            button.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
            
            
            [self.view addSubview:button];
            offset += button.frame.size.height + 20;
            count ++;
        };
        CGSize contentSize = scrollView.contentSize;
        contentSize.height = offset;
        [scrollView setContentSize:contentSize];
        [scrollView setBackgroundColor:_page.backgroundColor];
    } else {
        [self.view setBackgroundColor:[UIColor colorWithWhite:0.200 alpha:1.000]];
        float yOffset = (iPad ? 264 : 110);
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,yOffset)];
        [headerImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [headerImageView setContentMode:UIViewContentModeScaleAspectFill];
        [headerImageView setImage:_page.headerImage];
        [self.view addSubview:headerImageView];
        if(_page.image){
            UIView *imageWrapper = [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, self.view.frame.size.width,yOffset + (iPad ? 76 : 32))];
            [imageWrapper setBackgroundColor:[UIColor whiteColor]];
            [imageWrapper setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((iPad ? 38 : 16), (iPad ? 38 : 16), self.view.frame.size.width - (iPad ? 76 : 32),yOffset)];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView setImage:_page.image];
            [imageWrapper addSubview:imageView];
            [self.view addSubview:imageWrapper];
            yOffset += yOffset + (iPad ? 76 : 32);
        }
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, yOffset, self.view.frame.size.width, 647)];
        [webView setDelegate:self];
        [webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [webView loadHTMLString:_page.html baseURL:nil];
        [self.view addSubview:webView];
        
        UIView *actionButtons = [[UIView alloc] initWithFrame:CGRectMake(0, 247, self.view.frame.size.width, (iPad ? 78: 120))];
        [actionButtons setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

        UIView *actionButtonsWrapper = [[UIView alloc] initWithFrame:CGRectMake((iPad ? ((self.view.frame.size.width - 598) / 2)  : 16), 0, (iPad ? 598 : 280), (iPad ? 78: 120))];
        [actionButtonsWrapper setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        
        UIButton *shareButton = [[ActionButton alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
        [shareButton setTitle:@"Share this" forState:UIControlStateNormal];
        [shareButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [actionButtonsWrapper addSubview:shareButton];
        
        UIButton *favouriteButton = [[ActionButton alloc] initWithFrame:CGRectMake((iPad ? 318: 0), (iPad ? 0 : 60), 280, 40)];
        [favouriteButton setTitle:_page.favouriteButtonTitle forState:UIControlStateNormal];
        [favouriteButton addTarget:self action:@selector(didPressFavouriteButton:) forControlEvents:UIControlEventTouchUpInside];

        self.favouriteButton = favouriteButton;
        [actionButtonsWrapper addSubview:favouriteButton];
        [actionButtons addSubview:actionButtonsWrapper];
        [actionButtons setBackgroundColor:[UIColor whiteColor]];
        [actionButtons setHidden:YES];
        [self.view addSubview:actionButtons];
        
        self.actionButtons = actionButtons;
    }
}

-(void)configureNavbar{
    UIFont *titleFont = [UIFont fontWithName:@"Palatino-Bold" size:21.0];
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [_page.navigationBarColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setBarStyle:UIBarStyleBlackTranslucent];
    [navBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleFont,UITextAttributeFont, [UIColor colorWithWhite:0 alpha:0], UITextAttributeTextShadowColor,nil]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    if (_page.root){
        [self.navigationController setNavigationBarHidden:YES];
    }else {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

-(IBAction) didPressPageButton:(id)sender{
    Page *childPage = [_page.sortedChildren objectAtIndex:[sender tag]];
    if ((childPage.children.count > 0) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:NULL];
        PageViewController *viewController = [story instantiateViewControllerWithIdentifier:@"PageViewController"];
        viewController.page = childPage;
        viewController.detailViewController = _detailViewController;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [self.detailViewController setPage:childPage];
    }

}
-(IBAction) didPressBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) didPressFavouriteButton:(id)sender {
    _page.favourited = !_page.favourited;
    _page.favouritedAt = [NSDate date];
    [self.favouriteButton setTitle:_page.favouriteButtonTitle forState:UIControlStateNormal];
    if (self.managedObjectContext == nil) 
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    if(self.splitViewController){
        UIViewController *viewController = [[self.splitViewController.viewControllers objectAtIndex:0] topViewController];
        if([viewController isKindOfClass:[FavouritesViewController class]]){
            FavouritesViewController *favouritesViewController = (FavouritesViewController *)viewController;
            favouritesViewController.fetchedResultsController = nil;
            [favouritesViewController.tableView reloadData];
        }
    }
    [self.managedObjectContext save:nil];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
        self.navigationController.navigationBarHidden = NO;
    [self.actionButtons setHidden:YES];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self configureView];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Menu", @"Menu");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
