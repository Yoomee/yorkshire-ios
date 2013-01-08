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

@interface PageViewController : UIViewController <NSFetchedResultsControllerDelegate, UIWebViewDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) PageViewController *detailViewController;

@property (nonatomic, strong) Page *page;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)didPressPageButton:(id)sender;
-(IBAction)didPressBackButton:(id)sender;

- (void)setPage:(Page *)newPage hidePopover:(BOOL)hidePopove;

@property (weak, nonatomic) UIButton *favouriteButton;
@property (weak, nonatomic) UIWebView *webView;
@property (weak, nonatomic) UIView *actionButtons;

@end
