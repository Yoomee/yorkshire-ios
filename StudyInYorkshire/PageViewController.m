//
//  PageViewController.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 05/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "PageViewController.h"
#import "AppDelegate.h"
#import "Page.h"
#import <QuartzCore/QuartzCore.h>

@implementation PageViewController
@synthesize favouriteButton = _favouriteButton;
@synthesize actionButtons = _actionButtons;

@synthesize page;
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
    if (page == nil) {
        self.page = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    } else{
        self.navigationItem.title = page.title;
    }
    
    UIFont *titleFont = [UIFont fontWithName:@"Palatino-Bold" size:21.0];

    if([page.children count] > 0){
        UIScrollView *scrollView = (UIScrollView *)self.view;
        __block float offset = 16;
        NSUInteger count = 0;
        for(id object in page.sortedChildren){
            Page *childPage = object;
            if(childPage.favourited){
                NSLog(@"FAVOURITE");
            } else {
                NSLog(@"NOT FAVOURITE");
            }
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
            [self.view addSubview:button];
            offset += button.frame.size.height + 20;
            count ++;
        };
        CGSize contentSize = scrollView.contentSize;
        contentSize.height = offset;
        [scrollView setContentSize:contentSize];
        [scrollView setBackgroundColor:page.backgroundColor];
    } else {
        [self.view setBackgroundColor:[UIColor colorWithWhite:0.200 alpha:1.000]];
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320,110)];
        [headerImageView setImage:page.headerImage];
        [self.view addSubview:headerImageView];
        float yOffset = 110;
        if(page.image){
            UIView *imageWrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 320,140)];
            [imageWrapper setBackgroundColor:[UIColor whiteColor]];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 280,100)];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView setImage:page.image];
            [imageWrapper addSubview:imageView];
            [self.view addSubview:imageWrapper];
            yOffset += 140;
        }
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, yOffset, 320, 257)];
        [webView setDelegate:self];
        [webView loadHTMLString:page.html baseURL:nil];
        [self.view addSubview:webView];
        
        UIView *actionButtons = [[UIView alloc] initWithFrame:CGRectMake(0, 247, 320, 120)];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        shareButton.frame = CGRectMake(20, 0, 280, 40);
        [shareButton setTitle:@"Share this" forState:UIControlStateNormal];
        [shareButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [actionButtons addSubview:shareButton];
        
        UIButton *favouriteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        favouriteButton.frame = CGRectMake(20, 60, 280, 40);
        [favouriteButton setTitle:page.favouriteButtonTitle forState:UIControlStateNormal];
        [favouriteButton addTarget:self action:@selector(didPressFavouriteButton:) forControlEvents:UIControlEventTouchUpInside];
        self.favouriteButton = favouriteButton;
        [actionButtons addSubview:favouriteButton];
        [actionButtons setBackgroundColor:[UIColor whiteColor]];
        [actionButtons setHidden:YES];
        [self.view addSubview:actionButtons];
        self.actionButtons = actionButtons;
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{   
    aWebView.scrollView.scrollEnabled = NO;    // Property available in iOS 5.0 and later 
    CGRect frame = aWebView.frame;
    frame.size.width = 320;
    frame.size.height = 1;
    aWebView.frame = frame;
    frame.size.height = aWebView.scrollView.contentSize.height + 20;
    if((frame.size.height + frame.origin.y) < 367){
        frame.size.height = 367 - frame.origin.y;
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

- (void)viewDidUnload
{
    [self setFavouriteButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    UIFont *titleFont = [UIFont fontWithName:@"Palatino-Bold" size:21.0];
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [page.navigationBarColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setBarStyle:UIBarStyleBlackTranslucent];
    [navBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleFont,UITextAttributeFont, [UIColor colorWithWhite:0 alpha:0], UITextAttributeTextShadowColor,nil]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    if (page.root){
        [self.navigationController setNavigationBarHidden:YES];
    }else {
        [self.navigationController setNavigationBarHidden:NO];
    }
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

-(IBAction) didPressPageButton:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:NULL];
    PageViewController *viewController = [story instantiateViewControllerWithIdentifier:@"PageViewController"];
    Page *childPage = [page.sortedChildren objectAtIndex:[sender tag]];
    viewController.page = childPage;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(IBAction) didPressBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) didPressFavouriteButton:(id)sender {
    page.favourited = !page.favourited;
    page.favouritedAt = [NSDate date];
    [self.favouriteButton setTitle:page.favouriteButtonTitle forState:UIControlStateNormal];
    if (self.managedObjectContext == nil) 
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    [self.managedObjectContext save:nil];
}

@end
