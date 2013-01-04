//
//  YUShareKitConfigurator.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 13/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "YUShareKitConfigurator.h"

@implementation YUShareKitConfigurator

/* 
 App Description 
 ---------------
 These values are used by any service that shows 'shared from XYZ'
 */
- (NSString*)appName {
	return @"100 Day Bible Challenge Artwork";
}

- (NSString*)appURL {
	return @"http://art.100daybiblechallenge.com";
}

- (NSString*)sharersPlistName{
    return @"Sharers.plist";
}

- (NSArray*)defaultFavoriteURLSharers {
    return [NSArray arrayWithObjects:@"SHKFacebook", @"SHKTwitter", @"SHKMail", nil];
}

- (NSNumber*)autoOrderFavoriteSharers {
    return [NSNumber numberWithBool:false];
}

-(NSNumber*)showActionSheetMoreButton{
    return [NSNumber numberWithBool:false];
}

- (Class)SHKShareMenuSubclass {    
    return NSClassFromString(@"ShareMenu");
}

/*
 API Keys
 --------
*/
- (NSString*)facebookAppId {
	return @"179919252144062";
}

- (NSString*)facebookLocalAppId {
	return @"";
}

- (NSString*)twitterConsumerKey {
	return @"9FsUV1IgdzwuGiqzMWy27A";
}

- (NSString*)twitterSecret {
	return @"9ZISX30sdTKtyuW21OcsXPKaELamldm8mxQG4Q8WENc";
}
// You need to set this if using OAuth, see note above (xAuth users can skip it)
- (NSString*)twitterCallbackUrl {
	return @"http://twitter.com";
}

// Enter your app's twitter account if you'd like to ask the user to follow it when logging in. (Only for xAuth)
- (NSString*)twitterUsername {
	return @"";
}

/*
 UI Configuration : Basic
 ------------------------
 These provide controls for basic UI settings.  For more advanced configuration see below.
 */

- (UIColor*)barTintForView:(UIViewController*)vc {    
    
    return [UIColor blackColor];
}

@end
