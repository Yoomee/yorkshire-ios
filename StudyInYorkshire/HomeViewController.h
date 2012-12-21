//
//  HomeViewController.h
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 21/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Page;

@interface HomeViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) Page *page;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)didPressPageButton:(id)sender;
@end
