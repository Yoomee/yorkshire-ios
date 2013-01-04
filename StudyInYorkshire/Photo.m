//
//  Photo.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 10/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "Photo.h"


@implementation Photo

@dynamic imageUID;
@dynamic position;
@dynamic caption;

-(UIImage *)image{
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    if (self.imageUID) {
        NSString *path = [NSString stringWithFormat:@"%@/assets/%@",[[NSBundle mainBundle] resourcePath],self.imageUID];
        if(iPad)
            path = [path stringByAppendingString:@"~ipad"];
        if([UIScreen mainScreen].scale == 2.0)
            path = [path stringByAppendingString:@"@2x"];
        path = [path stringByAppendingString:@".jpg"];
        return [UIImage imageWithContentsOfFile:path];
    } else {
        return nil;
    }
}

-(UIImage *)thumb{
    if (self.imageUID) {
        NSString *path = [NSString stringWithFormat:@"%@/assets/%@-thumb.jpg",[[NSBundle mainBundle] resourcePath],self.imageUID];
        return [UIImage imageWithContentsOfFile:path];
    } else {
        return nil;
    }
}

@end
