//
//  YUTabBarController.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 07/01/2013.
//  Copyright (c) 2013 Yoomee. All rights reserved.
//

#import "YUTabBarController.h"
#import "HomeViewController.h"

@implementation YUTabBarController

-(void)setSelectedViewController:(UIViewController *)selectedViewController{
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    NSLog(@"indexOf:%d",[self.viewControllers indexOfObject:selectedViewController]);
    if (iPad && ([self.viewControllers indexOfObject:selectedViewController] == 0) && (![selectedViewController isKindOfClass:[HomeViewController class]])){
        NSMutableArray *myViewControllers = [[NSMutableArray alloc] initWithArray:self.viewControllers];
        [myViewControllers removeObjectAtIndex:0];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:NULL];
        HomeViewController *homeViewController = (HomeViewController *)[story instantiateViewControllerWithIdentifier:@"HomeViewController"];            
        [myViewControllers insertObject:homeViewController atIndex:0];
        [self setViewControllers:myViewControllers]; 
        selectedViewController = homeViewController;
    }
    [super setSelectedViewController:selectedViewController];
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex{
    NSLog(@"setSelectedIndex");
    [super setSelectedIndex:selectedIndex];
}

@end
