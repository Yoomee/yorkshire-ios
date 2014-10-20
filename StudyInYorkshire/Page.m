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
@dynamic permalink;
@dynamic title;
@dynamic viewName;
@dynamic imageUID;
@dynamic position;
@dynamic backgroundNumber;
@dynamic headerImageUID;
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
    NSString *path = [[[[NSBundle mainBundle] pathForResource:@"page" ofType:@"css"] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
    NSString *pageText = [self.text stringByReplacingOccurrencesOfString:@"<img src=\"/media" withString:[NSString stringWithFormat:@"<img src=\"file://%@/assets/media",path] options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.text.length)];
    return [NSString stringWithFormat:@"%@%@<div class='clearfix'></div></body></html>",output,pageText];
}

-(UIColor *)navigationBarColor{
    if(self.root){
        return [UIColor colorWithWhite:0 alpha:0.0];
    } else {
        return self.color;
    }
}

-(NSArray *)sortedChildren {
    NSSortDescriptor *sortPositionDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortPositionDescriptor, sortNameDescriptor, nil];
    return [self.children sortedArrayUsingDescriptors:sortDescriptors];
}

-(UIImage *)headerImage{
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    if (self.headerImageUID) {
        NSString *path = [[NSString stringWithFormat:@"%@/assets/%@",[[NSBundle mainBundle] resourcePath],self.headerImageUID] stringByDeletingPathExtension];
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

-(UIImage *)image{
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? NO : YES;
    if (self.imageUID) {
        NSString *path = [[NSString stringWithFormat:@"%@/assets/%@",[[NSBundle mainBundle] resourcePath],self.imageUID] stringByDeletingPathExtension];
        if(iPad)
            path = [path stringByAppendingString:@"~ipad"];
        path = [path stringByAppendingString:@".jpg"];
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

-(UIColor *)darkerColor{
    CGFloat r, g, b, a;
    if ([self.color getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
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
