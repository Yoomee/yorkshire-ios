//
//  FavouritesViewController.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 12/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "FavouritesViewController.h"
#import "NoFavouritesViewController.h"
#import "AppDelegate.h"
#import "PageViewController.h"
#import "Page.h"

@implementation FavouritesViewController
@synthesize detailViewController = _detailViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize noFavouritesLabel = _noFavouritesLabel;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 1024.0);
    }
    [super awakeFromNib];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    if(iPad && (_detailViewController == nil)){
        self.detailViewController = (PageViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
        if (self.fetchedResultsController.fetchedObjects.count > 0) {
            self.detailViewController.page = [self.fetchedResultsController.fetchedObjects objectAtIndex:0];
        }
        [self.detailViewController splitViewController:nil willHideViewController:nil withBarButtonItem:nil forPopoverController:nil];
    }
    self.navigationItem.title = @"Favourites";
    self.view.backgroundColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    self.tableView.separatorColor = [UIColor clearColor];
    
    UILabel *noFavourites = [[UILabel alloc]initWithFrame:self.view.frame];
    noFavourites.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    noFavourites.text = @"You haven't added\nany favourites yet";
    [noFavourites setTextAlignment:UITextAlignmentCenter];
    [noFavourites setNumberOfLines:2];
    [noFavourites setBackgroundColor:[UIColor clearColor]];
    [noFavourites setTextColor:[UIColor whiteColor]];
    [noFavourites setFont:[UIFont systemFontOfSize:18.0f]];
    [self.view addSubview:noFavourites];
    self.noFavouritesLabel = noFavourites;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    [super viewWillAppear:animated];
    if(iPad){
        UIFont *titleFont = [UIFont fontWithName:@"Palatino-Bold" size:21.0];
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,[UIColor blackColor].CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UINavigationBar *navBar = self.navigationController.navigationBar;
        [navBar setBarStyle:UIBarStyleBlackTranslucent];
        [navBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
        [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleFont,UITextAttributeFont, [UIColor colorWithWhite:0 alpha:0], UITextAttributeTextShadowColor,nil]];
    } else {
      [self.navigationController.navigationBar setHidden:YES];
    }
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
    if([[self.fetchedResultsController fetchedObjects] count] == 0){
        [self.noFavouritesLabel setHidden:NO];
    } else {
        [self.noFavouritesLabel setHidden:YES];        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    if(iPad && [[self.fetchedResultsController fetchedObjects] count] == 0){
        NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.tabBarController.viewControllers];
        if(viewControllers.count > 0){
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:NULL];
            NoFavouritesViewController *noFavouritesViewController = [story instantiateViewControllerWithIdentifier:@"NoFavouritesViewController"];
            [viewControllers addObject:noFavouritesViewController];
            [viewControllers removeObjectAtIndex:3];
            [self.tabBarController setViewControllers:viewControllers];
            [self.tabBarController setSelectedViewController:noFavouritesViewController];
        }
    }
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showPage"]){
        PageViewController *pageViewController = segue.destinationViewController;
        Page *page = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        pageViewController.page = page;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Favourite";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Page *page = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = page.title;
    [cell.textLabel setBackgroundColor:page.navigationBarColor];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Palatino-Bold" size:21.0]];
    UIView *bg = [[UIView alloc] initWithFrame:cell.backgroundView.frame];
    [bg setBackgroundColor:page.color];
    cell.backgroundView = bg;
    UIView *selectedBg = [[UIView alloc] initWithFrame:cell.backgroundView.frame];
    [selectedBg setBackgroundColor:page.darkerColor];
    cell.selectedBackgroundView = selectedBg;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    if(iPad){
        Page *page = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        [_detailViewController setPage:page];
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
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(favourite = 1)"];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"favouritedAt" ascending:NO];
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

@end
