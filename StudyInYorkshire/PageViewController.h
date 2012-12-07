//
//  PageViewController.h
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 05/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@class Page;

@interface PageViewController : UIViewController <NSFetchedResultsControllerDelegate, UIWebViewDelegate>

@property (nonatomic, strong) Page *page;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)didPressPageButton:(id)sender;
-(IBAction)didPressBackButton:(id)sender;

@end
