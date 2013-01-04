//
//  NoFavouritesViewController.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 03/01/2013.
//  Copyright (c) 2013 Yoomee. All rights reserved.
//

#import "NoFavouritesViewController.h"
#import "FavouritesViewController.h"

@implementation NoFavouritesViewController
@synthesize infoLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.200 alpha:1.000];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    infoLabel.hidden = YES;
}


-(void)viewDidAppear:(BOOL)animated{
    FavouritesViewController *favouritesViewController = [[FavouritesViewController alloc] init];
    if([[[favouritesViewController  fetchedResultsController] fetchedObjects] count] > 0){
        NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.tabBarController.viewControllers];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:NULL];
        UISplitViewController *splitViewController = [story instantiateViewControllerWithIdentifier:@"FavouritesViewController"];
        [viewControllers addObject:splitViewController];
        [viewControllers removeObjectAtIndex:3];
        [self.tabBarController setViewControllers:viewControllers];
    } else {
        infoLabel.hidden = NO;
    }
    [super viewDidAppear:NO];
}

- (void)viewDidUnload
{
    [self setInfoLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
