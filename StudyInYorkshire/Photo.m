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
    if (self.imageUID) {
        NSString *path = [NSString stringWithFormat:@"%@/assets/%@",[[NSBundle mainBundle] resourcePath],self.imageUID];
        return [UIImage imageWithContentsOfFile:path];
    } else {
        return nil;
    }
}

@end
