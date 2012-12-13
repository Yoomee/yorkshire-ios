//
//  ActionButton.m
//  StudyInYorkshire
//
//  Created by Matthew Atkins on 12/12/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "ActionButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation ActionButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.titleLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:19.0];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.layer.bounds;
            
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                                (id)[UIColor colorWithWhite:0.4f alpha:0.5f].CGColor,
                                nil];
        
        gradientLayer.locations = [NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:0.0f],
                                   [NSNumber numberWithFloat:1.0f],
                                   nil];
        
        gradientLayer.cornerRadius = self.layer.cornerRadius;
        [self.layer insertSublayer:gradientLayer atIndex:0];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateHighlighted];
        [self setClipsToBounds:YES];
        self.layer.cornerRadius = 4.0f;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.3].CGColor;
    }
    
    return self;
}

@end