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

@dynamic slug;
@dynamic text;
@dynamic title;
@dynamic position;
@dynamic backgroundNumber;
@dynamic colorR;
@dynamic colorG;
@dynamic colorB;
@dynamic children;
@dynamic parent;

-(NSArray *)sortedChildren {
    NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortNameDescriptor, nil];
    return [self.children sortedArrayUsingDescriptors:sortDescriptors];
}

-(UIColor *)color{
    if(self.colorR && self.colorG && self.colorB){
        return [UIColor colorWithRed:[self.colorR floatValue] green:[self.colorG floatValue] blue:[self.colorB floatValue] alpha:1.0];
    } else if (self.parent){
        return self.parent.color;
    } else {
        return [UIColor colorWithRed:0.24 green:0.63 blue:0.63 alpha:1.0];
    }
}

-(UIColor *)backgroundColor{
    NSString *imageName = @"";
    if(self.backgroundNumber == nil){
        imageName = @"background_1.jpg";
    } else {
        imageName = [NSString stringWithFormat:@"background_%d.jpg",[self.backgroundNumber intValue]];
    }
    return [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
}

+(int)offsetForIndex:(NSUInteger)index{
    NSInteger idx = index % 6;
    if (idx == 0) {
        return 1;
    } else if(idx == 1 || idx == 4){
        return 3;
    } else {
        return 2;
    }
}

@end
