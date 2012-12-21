//
//  HomeViewController.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 21/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "HomeViewController.h"
#import "PageViewController.h"
#import "AppDelegate.h"
#import "Page.h"
#import <QuartzCore/QuartzCore.h>

@interface HomeViewController ()
- (void)configureView;
@end

@implementation HomeViewController

@synthesize page = _page;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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

- (void)configureView
{
    UIFont *titleFont = [UIFont fontWithName:@"Palatino-Bold" size:21.0];
    if (_page == nil) {
        self.page = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    }
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
    [self.view setBackgroundColor:_page.backgroundColor];
}

-(IBAction) didPressPageButton:(id)sender{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.tabBarController.viewControllers];
    [viewControllers removeObjectAtIndex:0];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:NULL];
    UISplitViewController *splitViewController = [story instantiateViewControllerWithIdentifier:@"SplitViewController"];
    PageViewController *pageViewController = (PageViewController *)[[splitViewController.viewControllers objectAtIndex:0] topViewController];
    pageViewController.page = _page;
    [pageViewController didPressPageButton:sender];
    [viewControllers insertObject:splitViewController atIndex:0];
    [self.tabBarController setViewControllers:viewControllers];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}

@end
