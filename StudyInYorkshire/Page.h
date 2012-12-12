//
//  Page.h
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 06/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Page;

@interface Page : NSManagedObject

@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * viewName;
@property (nonatomic, retain) NSString * imageUID;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * backgroundNumber;
@property (nonatomic, retain) NSNumber * headerNumber;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * favourite;
@property (nonatomic, retain) NSNumber * colorR;
@property (nonatomic, retain) NSNumber * colorG;
@property (nonatomic, retain) NSNumber * colorB;
@property (nonatomic, retain) NSDate * favouritedAt;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) Page *parent;
@end

@interface Page (CoreDataGeneratedAccessors)

+(int)offsetForIndex:(NSUInteger)index;

-(NSArray *)sortedChildren;
-(UIColor *)color;
-(UIColor *)backgroundColor;
-(UIColor *)navigationBarColor;
-(UIImage *)headerImage;
-(UIImage *)image;
-(BOOL)root;
-(BOOL)favourited;
- (void)setFavourited:(BOOL)newFavourited;
-(NSString *)favouriteButtonTitle;
-(NSString *)html;

- (void)addChildrenObject:(Page *)value;
- (void)removeChildrenObject:(Page *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
