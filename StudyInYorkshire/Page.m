//
//  Page.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 06/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "Page.h"
#import "Page.h"


@implementation Page

@dynamic text;
@dynamic title;
@dynamic slug;
@dynamic children;
@dynamic parent;

-(NSArray *)sortedChildren {
    NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortNameDescriptor, nil];
    return [self.children sortedArrayUsingDescriptors:sortDescriptors];
}

@end
