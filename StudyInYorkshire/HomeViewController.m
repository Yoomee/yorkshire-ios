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
- (void)layoutTilesForInterfaceOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;
@end

@implementation HomeViewController

@synthesize page = _page;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
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
    [self layoutTilesForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] animated:NO];
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
    UIFont *titleFont = [UIFont fontWithName:@"Palatino-Bold" size:32.0];
    if (_page == nil) {
        self.page = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    }
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 250, 126)];
    label.text = @"Study at Universities in Yorkshire, UK";
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = titleFont;
    label.layer.masksToBounds = NO;
    label.layer.shadowColor = [UIColor blackColor].CGColor;
    label.layer.shadowOpacity = 0.5;
    label.layer.shadowRadius = 10;
    label.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    [self.scrollView addSubview:label];
    
    titleFont = [UIFont fontWithName:@"Palatino-Bold" size:21.0];
    NSUInteger count = 0;
    for(id object in _page.sortedChildren){
        Page *childPage = object;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 250, 128)];
        [button addTarget:self action:@selector(didPressPageButton:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = childPage.color;
        button.tag = count;
        button.layer.masksToBounds = NO;
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOpacity = 0.5;
        button.layer.shadowRadius = 10;
        button.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 98, 220, 24)];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = titleFont;
        label.text = childPage.title;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 92)];
        imageView.image = childPage.headerImage;
        [button addSubview:imageView];
        [button addSubview:label];
        [self.scrollView addSubview:button];
        count ++;
    };
    
    UIButton *tourButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 250, 128)];
    tourButton.backgroundColor = [UIColor yellowColor];
    
    [self.scrollView setBackgroundColor:_page.backgroundColor];
}

- (IBAction)didPressTourButton:(UIButton *)sender
{
    Page *tourPage = [self page:self.page fetchChildPageWithTitle:@"Tour de Yorkshire"];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.tabBarController.viewControllers];
    [viewControllers removeObjectAtIndex:0];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:NULL];
    UISplitViewController *splitViewController = [story instantiateViewControllerWithIdentifier:@"SplitViewController"];
    PageViewController *pageViewController = (PageViewController *)[[splitViewController.viewControllers objectAtIndex:0] topViewController];
    pageViewController.page = tourPage.parent;
    [pageViewController didPressPageButton:sender];
    [viewControllers insertObject:splitViewController atIndex:0];
    [self.tabBarController setViewControllers:viewControllers];
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

-(void) layoutTilesForInterfaceOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated{
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    if(iPad){
        int cols;
        float padding;
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            cols = 2;
            padding = 89;
        } else {
            cols = 3;
            padding = 68;
        }
        if(animated){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.8];
            [UIView setAnimationBeginsFromCurrentState:YES];
        }
        int count = 0;
        for(int i=0;i < self.scrollView.subviews.count; i++){
            UIView *subView = [self.scrollView.subviews objectAtIndex:i];
                CGRect frame = subView.frame;
                frame.origin.x = padding + ((count)%cols)*(frame.size.width + padding);
                frame.origin.y = padding + ((count)/cols)*(frame.size.height + padding);
                [subView setFrame:frame];
                count++;
        }
        
        
        if(animated){
            [UIView commitAnimations];
        }
    }
    
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self layoutTilesForInterfaceOrientation:toInterfaceOrientation animated:YES];
    
}


// HELPER FUNCTION
// Recursive look into the page's sortedChildren to find a page with a certain title
-(Page *)page:(Page *)page fetchChildPageWithTitle:(NSString *)title
{
    Page *childPage = nil;
    Page *foundPage = nil;
    
    for ( childPage in page.sortedChildren)
    {
        if([childPage.title isEqualToString:title])
            return childPage;
        
        if([childPage.sortedChildren count] > 0 )
        {
            foundPage = [self page:childPage fetchChildPageWithTitle:title];
            
            if(foundPage != nil)
            {
                return foundPage;
            }
        }
    }
    return nil;
}

@end
