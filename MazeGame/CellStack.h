//
//  CellStack.h
//  MazeGame
//
//  Created by Winnie Wu on 7/22/13.
//  Copyright (c) 2013 Winnie Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellStack : NSObject
{
    NSMutableArray *stack;
    int count;
}

-(void) push: (id)object;
- (id) pop;
-(void) clear;
@property (nonatomic, readonly) int count;

@end
