//
//  MapViewController.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 11/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "MapViewController.h"
#import "PageViewController.h"
#import "AppDelegate.h"
#import "Page.h"

@implementation MapViewController
@synthesize mapView;
@synthesize universities =_universities;
@synthesize annotations = _annotations;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

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
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 53.653;
    coordinate.longitude = -0.986;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 120000, 120000);
    [mapView setRegion:region animated:NO];
        
    Page *universitiesPage = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    self.universities = universitiesPage.sortedChildren;
    self.annotations = [[NSMutableArray alloc] initWithCapacity:[self.universities count]];

    __block int pageIdx = 0;
    for(id object in self.universities){
        Page *university = object;
        CLLocationCoordinate2D uniCoord;
        uniCoord.latitude = [university.latitude floatValue];
        uniCoord.longitude = [university.longitude floatValue];
        MKPointAnnotation *uniPoint = [[MKPointAnnotation alloc] init];
        uniPoint.coordinate = uniCoord;
        uniPoint.title = university.title;
        [mapView addAnnotation:uniPoint]; 
        [self.annotations addObject:uniPoint];
        pageIdx++;
    };
    
}


- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(slug = %@)", @"universities"];
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

#pragma mark - Map View Delegate
- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [aMapView dequeueReusableAnnotationViewWithIdentifier:@"university"];
    if(!annotationView) {   
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"university"];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    annotationView.tag = [self.annotations indexOfObject:annotation];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    return annotationView;
}

-(void)mapView:(MKMapView *)aMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"showUniversity" sender:view];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showUniversity"]){
        MKAnnotationView *annotationView = (MKAnnotationView *)sender;
        CLLocationCoordinate2D coordinate = [annotationView.annotation coordinate];
        PageViewController *pageViewController = segue.destinationViewController;
        for (Page* university in self.universities)
        {
            if(([university.latitude floatValue] == coordinate.latitude)&& ([university.longitude floatValue] == coordinate.longitude)){
                pageViewController.page = university;
                break;
            }
        }
    }
}

@end
