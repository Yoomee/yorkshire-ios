//
//  HomePageViewController.h
//  StudyInYorkshire
//
//  Created by Adam on 17/10/2014.
//  Copyright (c) 2014 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"

@interface HomePageViewController : PageViewController


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *tourButton;

- (IBAction)didPressTourButton:(UIButton *)sender;


@end
