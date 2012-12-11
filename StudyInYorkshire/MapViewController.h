//
//  MapViewController.h
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 11/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <NSFetchedResultsControllerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
