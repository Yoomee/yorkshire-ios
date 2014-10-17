//
//  AppDelegate.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 05/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//


//Removed some imports - RMV_SHK
#import "AppDelegate.h"
//#import "SHKConfiguration.h"
//#import "YUShareKitConfigurator.h"
#import "Page.h"
//#import "YUTabBarController.h"
//#import "SHKFacebook.h"
#import "SplashScreenViewController.h"
#import <MessageUI/MessageUI.h>


@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    // Override point for customization after application launch.
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[[UIColor blackColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[UITabBar appearance] setBackgroundImage:img];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearanceWhenContainedIn:[MFMailComposeViewController class], nil] setTintColor:nil
     ];
    
    
    
    
    
//    [[UIBarButtonItem appearance] setTintColor:[UIColor clearColor]];
    
//    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"bar_button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forState:UIControlStateNormal 
//                                          barMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"back_button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    //removed configurator - RMV_SHK
//    DefaultSHKConfigurator *configurator = [[YUShareKitConfigurator alloc] init];
//    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    if(!iPad){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:NULL];
        SplashScreenViewController *splashScreenViewController = (SplashScreenViewController *)[story instantiateViewControllerWithIdentifier:@"SplashScreenViewController"];  
        
        self.window.rootViewController = splashScreenViewController;
    }

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    if(!iPad){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:NULL];
        UITabBarController *tabBarController = (UITabBarController *)[story instantiateViewControllerWithIdentifier:@"TabBarController"];  
        self.window.rootViewController = tabBarController;
    }
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    [tabBarController setSelectedViewController:[tabBarController.viewControllers objectAtIndex:0]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"StudyInYorkshire" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"StudyInYorkshire.sqlite"];    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([fileManager fileExistsAtPath:[storeURL path]]) {
        NSString *dbVersion = [defaults stringForKey:@"dbVersion"];
        if (dbVersion && ([dbVersion isEqualToString:@"1.4"])) {
            NSLog(@"Database up to date");
        } else {
            NSLog(@"Needs upgrading");
            // Load existing database and collect favourites
            NSPersistentStoreCoordinator *existingPSC = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
            [existingPSC addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
            NSManagedObjectContext *existingManagedObjectContext = [[NSManagedObjectContext alloc] init];
            [existingManagedObjectContext setPersistentStoreCoordinator:existingPSC];

            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Page" inManagedObjectContext:existingManagedObjectContext];
            [fetchRequest setEntity:entity];
            [fetchRequest setFetchBatchSize:20];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:existingManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
            [fetchedResultsController performFetch:nil];
            NSMutableArray *favourites = [[NSMutableArray alloc] initWithCapacity:[fetchedResultsController fetchedObjects].count];
            for(Page *page in [fetchedResultsController fetchedObjects]){
                if([page.favourite boolValue]){       
                    [favourites insertObject:page atIndex:0];
                    NSLog(@"Favourite: %@",page.title);
                }
            }
            
            // Remove existing sqlite file and copy in new one
            NSURL *newStoreURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"StudyInYorkshire" ofType:@"sqlite"]];
            [fileManager removeItemAtURL:storeURL error:nil];
            [fileManager copyItemAtPath:[newStoreURL path] toPath:[storeURL path] error:nil];
            
            // Load new database
            NSPersistentStoreCoordinator *newPSC = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
            [newPSC addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
            NSManagedObjectContext *newManagedObjectContext = [[NSManagedObjectContext alloc] init];
            [newManagedObjectContext setPersistentStoreCoordinator:newPSC];
            NSFetchRequest *newFetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *newEntity = [NSEntityDescription entityForName:@"Page" inManagedObjectContext:newManagedObjectContext];
            [newFetchRequest setEntity:newEntity];
            [newFetchRequest setFetchBatchSize:20];
            [newFetchRequest setSortDescriptors:sortDescriptors];
            NSFetchedResultsController *newFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:newManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
            [newFetchedResultsController performFetch:nil];
            
            // Set the favourites
            for(Page *page in [newFetchedResultsController fetchedObjects]){
                for (Page *favouritePage in favourites) {
                    if ([favouritePage.title isEqualToString:page.title]) {
                        page.favourite = favouritePage.favourite;
                        page.favouritedAt = favouritePage.favouritedAt;
                    }
                }
            }
            [newManagedObjectContext save:nil];
            [defaults setObject:@"1.3" forKey:@"dbVersion"];
        }
    } else {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"StudyInYorkshire" ofType:@"sqlite"];
        [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:nil];
        [defaults setObject:@"1.3" forKey:@"dbVersion"];
    }
    [defaults synchronize];

    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)handleOpenURL:(NSURL*)url
{
    //NSString* scheme = [url scheme];
    //NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
    //no longer has function (find a replacement ADM_EDT
//    if ([scheme hasPrefix:prefix])
//        return [SHKFacebook handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 
{
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    return [self handleOpenURL:url];  
}

@end

