//
//  Photo.h
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 10/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageUID;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSString * caption;

-(UIImage *)image;
-(UIImage *)thumb;

@end
