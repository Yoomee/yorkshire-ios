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

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) Page *parent;
@end

@interface Page (CoreDataGeneratedAccessors)

-(NSArray *)sortedChildren;

- (void)addChildrenObject:(Page *)value;
- (void)removeChildrenObject:(Page *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
