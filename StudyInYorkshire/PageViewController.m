//
//  PageViewController.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 05/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "PageViewController.h"
#import "HomeViewController.h"
#import "FavouritesViewController.h"
#import "AppDelegate.h"
#import "Page.h"
#import "ActionButton.h"
#import "SHK.h"
#import <QuartzCore/QuartzCore.h>

@interface PageViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
- (void)configureNavbar;
- (void)configureWebViewAndActionButtons;
- (void)configureWebViewAndActionButtons:(UIWebView *)aWebView;
- (void)refreshButtons;
@end

@implementation PageViewController
@synthesize favouriteButton = _favouriteButton;
@synthesize actionButtons = _actionButtons;
@synthesize webView;

@synthesize page = _page;
@synthesize detailViewController = _detailViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize masterPopoverController = _masterPopoverController;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 1200.0);
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
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    [super viewDidLoad];
    if (!iPad && (_page == nil)) {
        self.page = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{   
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    int yOffset = (iPad ? 264 : 110);
    if(_page.image){
        UIView *imageWrapper = [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, self.view.frame.size.width,yOffset + (iPad ? 76 : 32))];
        [imageWrapper setBackgroundColor:[UIColor whiteColor]];
        [imageWrapper setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((iPad ? 38 : 16), (iPad ? 38 : 16), self.view.frame.size.width - (iPad ? 76 : 32),yOffset)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:_page.image];
        [imageWrapper addSubview:imageView];
        [self.view addSubview:imageWrapper];
        yOffset += yOffset + (iPad ? 68 : 16);
    }
    UIView *actionButtons = [[UIView alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 247, self.view.frame.size.width, (iPad ? 78: 120)))];
    [actionButtons setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    UIView *actionButtonsWrapper = [[UIView alloc] initWithFrame:CGRectIntegral(CGRectMake((iPad ? ((self.view.frame.size.width - 598) / 2)  : 16), 0, (iPad ? 598 : 280), (iPad ? 78: 120)))];
    [actionButtonsWrapper setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    
    UIButton *shareButton = [[ActionButton alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    [shareButton setTitle:@"Share this" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(didPressShareButton:) forControlEvents:UIControlEventTouchUpInside];
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
    [self configureWebViewAndActionButtons:aWebView];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.absoluteString isEqualToString:@"about:blank"] || [request.URL.absoluteString hasPrefix:@"file://"]) {
        return YES;
    } else {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
}

-(void)configureWebViewAndActionButtons{
    [self configureWebViewAndActionButtons:self.webView];
}

-(void)configureWebViewAndActionButtons:(UIWebView *)aWebView{
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    aWebView.scrollView.scrollEnabled = NO; 
    CGRect frame = aWebView.frame;
    frame.size.width = self.view.frame.size.width;   
    frame.size.height = 1;
    aWebView.frame = frame;
    frame.size.height = aWebView.scrollView.contentSize.height + (iPad ? 76 : 32);
    if((frame.size.height + frame.origin.y + self.actionButtons.frame.size.height) < self.view.frame.size.height){
        frame.size.height = self.view.frame.size.height - frame.origin.y - self.actionButtons.frame.size.height - 44;
    }
    aWebView.frame = frame;
    UIScrollView *scrollView = (UIScrollView *)self.view;
    CGSize contentSize = scrollView.contentSize;
    contentSize.height = frame.size.height + frame.origin.y;
    CGRect actionButtonsFrame = self.actionButtons.frame;
    actionButtonsFrame.origin.y = contentSize.height;
    [self.actionButtons setFrame:CGRectIntegral(actionButtonsFrame)];
    [self.actionButtons setHidden:NO];
    contentSize.height += self.actionButtons.frame.size.height;
    [scrollView setContentSize:contentSize];
}

- (void)setPage:(Page *)newPage
{
    [self setPage:newPage hidePopover:YES];
}

- (void)setPage:(Page *)newPage hidePopover:(BOOL)hidePopover
{
    if (_page != newPage) {
        _page = newPage;
        // Update the view.
        UIScrollView *scrollView = (UIScrollView *)self.view;
        [scrollView setContentOffset:CGPointMake(0, -44.0)];
        [self configureView];
        if (hidePopover && (self.masterPopoverController != nil)) {
            [self.masterPopoverController dismissPopoverAnimated:YES];
        }
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
    [self refreshButtons];
    [super viewWillAppear:animated];
    [self.favouriteButton setTitle:_page.favouriteButtonTitle forState:UIControlStateNormal];
    if(self.splitViewController){
        UIViewController *viewController = [[self.splitViewController.viewControllers objectAtIndex:0] topViewController];
        if([viewController isKindOfClass:[FavouritesViewController class]]){
            FavouritesViewController *favouritesViewController = (FavouritesViewController *)viewController;
            [favouritesViewController viewDidAppear:NO];
        }
    }
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
    
    self.navigationItem.title = _page.title;
    
    
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
            
            CGRect rect = CGRectMake(0, 0, 1, 1);
            // Create a 1 by 1 pixel context
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
            [childPage.darkerColor setFill];
            UIRectFill(rect);   // Fill it with your color
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [button setBackgroundImage:image forState:UIControlStateSelected];
            [button setBackgroundImage:image forState:UIControlStateHighlighted];
            
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
            yOffset += yOffset + (iPad ? 76 : 32);
        }
        
        if(self.webView != nil){
            [self.webView removeFromSuperview];
            self.webView = nil;
        }
        
        UIWebView *aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, yOffset, self.view.frame.size.width, 647)];
        [aWebView setDelegate:self];
        [aWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        NSString *path = [NSString stringWithFormat:@"file://%@",[[[[NSBundle mainBundle] pathForResource:@"page" ofType:@"css"] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]];
        self.webView = aWebView;
        [self.view addSubview:self.webView];
        //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.co.uk"]]
        [self.webView loadHTMLString:_page.html baseURL:[NSURL URLWithString:path]];
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

-(void) refreshButtons{
    if(self.detailViewController && self.detailViewController.page){
        for (UIView *subview in self.view.subviews){
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)subview;
                Page *childPage = [_page.sortedChildren objectAtIndex:button.tag];
                [button setSelected:(childPage == self.detailViewController.page)];
            }
        }
    }
}

-(IBAction) didPressPageButton:(id)sender{
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    Page *childPage = [_page.sortedChildren objectAtIndex:[sender tag]];
    if ((childPage.children.count > 0) || !iPad) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:NULL];
        PageViewController *viewController = [story instantiateViewControllerWithIdentifier:@"PageViewController"];
        viewController.page = childPage;
        viewController.detailViewController = _detailViewController;
        if(iPad && ((viewController.detailViewController.page == nil) || (_page.parent == nil)))
            [viewController.detailViewController setPage:[childPage.sortedChildren objectAtIndex:0] hidePopover:NO];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [self.detailViewController setPage:childPage];
        [self refreshButtons];
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
            [favouritesViewController viewWillAppear:NO];
            [favouritesViewController viewDidAppear:NO];
        }
    }
    [self.managedObjectContext save:nil];
}

-(void) didPressShareButton:(id)sender {
    // Create the item to share (in this example, a url)
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.studyyorkshire.com/%@",_page.permalink]];
    SHKItem *item = [SHKItem URL:url title:[NSString stringWithFormat:@"Have you thought about studying in Yorkshire, UK? Here's some information about %@",_page.title] contentType:SHKURLContentTypeWebpage];
    
    item.facebookURLSharePictureURI = @"http://www.studyyorkshire.com/assets/facebook.png";
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    //[actionSheet showInView:self.view];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
        self.navigationController.navigationBarHidden = NO;
    if([self.view.backgroundColor isEqual:[UIColor grayColor]])
        self.view.backgroundColor = [UIColor whiteColor];
    [self.actionButtons setHidden:YES];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.actionButtons setHidden:NO];
    if([self.view.backgroundColor isEqual:[UIColor whiteColor]])
        self.view.backgroundColor = [UIColor grayColor];
    [self configureWebViewAndActionButtons];
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView setScrollEnabled:YES];
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
