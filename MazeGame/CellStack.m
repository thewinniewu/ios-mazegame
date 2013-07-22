//
//  CellStack.m
//  MazeGame
//
//  Created by Winnie Wu on 7/22/13.
//  Copyright (c) 2013 Winnie Wu. All rights reserved.
//

#import "CellStack.h"

@implementation CellStack

- (id) init
{
    self = [super init];
    if (self)
    {
        stack = [[NSMutableArray alloc] init];
        count = 0;
    }
    return self;
}



@end
