//
//  Cell.m
//  MazeGame
//
//  Created by Winnie Wu on 7/22/13.
//  Copyright (c) 2013 Winnie Wu. All rights reserved.
//

#import "Cell.h"

@implementation Cell

- (id) init
{
    self = [super init];
    if (self)
    {
        NSArray *zeroes = @[@0, @0, @0, @0];
        _borderArray = [[NSArray alloc] initWithArray:zeroes copyItems:YES];
        _wallsArray = [[NSArray alloc] initWithArray:zeroes copyItems:YES];
        _visited = NO;
        _isStart = NO;
        _isEnd = NO;
        
        _northWall = YES;
        _eastWall = YES;
        _southWall = YES;
        _westWall = YES;

        
        
        
    }
    return self;
}

@end