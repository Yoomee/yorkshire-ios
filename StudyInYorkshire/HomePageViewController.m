//
//  HomePageViewController.m
//  StudyInYorkshire
//
//  Created by Adam on 17/10/2014.
//  Copyright (c) 2014 Yoomee. All rights reserved.
//

#import "HomePageViewController.h"
#import "Page.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didPressTourButton:(UIButton *)sender
{
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    Page *tourPage = [self page:self.page fetchChildPageWithTitle:@"Tour de Yorkshire"];
    
    //once page is set...
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:NULL];
    PageViewController *viewController = [story instantiateViewControllerWithIdentifier:@"PageViewController"];
    viewController.page = tourPage;
    //viewController.detailViewController = _detailViewController;
    if(iPad && ((viewController.detailViewController.page == nil) || (self.page.parent == nil)))
        [viewController.detailViewController setPage:[tourPage.sortedChildren objectAtIndex:0] hidePopover:NO];
    [self.navigationController pushViewController:viewController animated:YES];
    
//    [self.detailViewController setPage:tourPage];
//    [self refreshButtons];
}





// HELPER FUNCTION
// Recursive look into the page's sortedChildren to find a page with a certain title
-(Page *)page:(Page *)page fetchChildPageWithTitle:(NSString *)title
{
    Page *childPage = nil;
    Page *foundPage = nil;
    
    for ( childPage in page.sortedChildren)
    {
        if([childPage.title isEqualToString:title])
            return childPage;
        
        if([childPage.sortedChildren count] > 0 )
        {
            foundPage = [self page:childPage fetchChildPageWithTitle:title];
            
            if(foundPage != nil)
            {
                return foundPage;
            }
        }
    }
    return nil;
}

@end
