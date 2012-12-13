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
@dynamic viewName;
@dynamic imageUID;
@dynamic position;
@dynamic backgroundNumber;
@dynamic headerNumber;
@dynamic latitude;
@dynamic longitude;
@dynamic favourite;
@dynamic colorR;
@dynamic colorG;
@dynamic colorB;
@dynamic children;
@dynamic favouritedAt;
@dynamic parent;

-(BOOL)favourited{
    return [self.favourite boolValue];
}

- (void)setFavourited:(BOOL)newFavourited {
    self.favourite = [NSNumber numberWithBool:newFavourited];
}
-(NSString *)favouriteButtonTitle{
    if (self.favourited){
        return @"Remove from favourites";
    } else {
        return @"Add to favourites";
    }
}

-(BOOL)root{
    return [self.slug isEqualToString:@"mobile-app"];
}

-(NSString *)html{
    NSString *output = [NSString stringWithFormat:@"<html><head><link rel='stylesheet' type='text/css' href='file://%@'></head><body>",[[NSBundle mainBundle] pathForResource:@"page" ofType:@"css"]];
    if (![self.viewName isEqualToString:@"university"]){
        output = [NSString stringWithFormat:@"%@<h1 class='page-title'>%@</h1>",output,self.title];
    }
    return [NSString stringWithFormat:@"%@%@<div class='clearfix'></div></body></html>",output,self.text];
}

-(UIColor *)navigationBarColor{
    if(self.root){
        return [UIColor colorWithWhite:0 alpha:0.0];
    } else {
        return self.color;
    }
}

-(NSArray *)sortedChildren {
    NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortNameDescriptor, nil];
    return [self.children sortedArrayUsingDescriptors:sortDescriptors];
}

-(UIImage *)headerImage{
    if ([self.headerNumber intValue] > 0) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"header_%d.jpg",[self.headerNumber intValue]]];
    } else if (self.parent){
        return self.parent.headerImage;
    }else{
        return [UIImage imageNamed:@"header_1.jpg"];
    }
}

-(UIImage *)image{
    if (self.imageUID) {
        NSString *path = [NSString stringWithFormat:@"%@/assets/%@",[[NSBundle mainBundle] resourcePath],self.imageUID];
        return [UIImage imageWithContentsOfFile:path];
    } else {
        return nil;
    }
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
