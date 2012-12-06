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

@implementation PageViewController

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
    self.page = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    __block float offset = 20;
    
    for(id object in page.sortedChildren){
        Page *childPage = object;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, offset, 280, 40)];
        [button setBackgroundColor:[UIColor colorWithRed:0.153 green:0.561 blue:0.565 alpha:1.000]];
        [button.titleLabel setFont:[UIFont fontWithName:@"Palatino-Bold" size:21.0]];
        [button setTitle:childPage.title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didPressPageButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        offset += 60;
    };
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    UIViewController *viewController = [story instantiateViewControllerWithIdentifier:@"PageViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
