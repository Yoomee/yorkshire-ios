//
//  FavouritesViewController.h
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 12/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PageViewController.h"

@interface FavouritesViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) PageViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) UILabel *noFavouritesLabel;

@end
