//
//  WorldScene.m
//  MazeGame
//
//  Created by Winnie Wu on 7/22/13.
//  Copyright (c) 2013 Winnie Wu. All rights reserved.
//

#import "WorldScene.h"

@interface WorldScene ()

@property BOOL contentCreated;

@end


@implementation WorldScene

- (void) didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void) createSceneContents
{
    self.backgroundColor = [SKColor lightGrayColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    CellGrid *mazeGrid = [[CellGrid alloc] init];
   // NSLog(@"Cellgrid: %@", [mazeGrid columns]);
}


@end
