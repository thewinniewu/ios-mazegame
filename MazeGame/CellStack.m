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
        _count = 0;
    }
    return self;
}

- (void) push:(id)object
{
    [stack addObject:object];
    _count = [stack count];
}

- (id) pop
{
    id object = nil;
    if ([stack count] > 0)
    {
        object = [stack lastObject];
        [stack removeObject: [stack lastObject]];
        _count = [stack count];
    }
    return object;
}

-(void) clear
{
    [stack removeAllObjects];
    _count = 0;
}

@end
