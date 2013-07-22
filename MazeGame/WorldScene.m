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
    [mazeGrid buildSimpleMaze];
    
    float xPos = self.view.bounds.size.width / 4;
    float yPos = self.view.bounds.size.height / 2;
    
    
    
    for (NSMutableArray *column in [mazeGrid columns])
    {
        for (Cell *cellInRow in column)
        {
            [self drawCell: cellInRow AtX:xPos atY:yPos];
            yPos -= 50;
        }
        xPos += 50;
    }
    
    // NSLog(@"Cellgrid: %@", [mazeGrid columns]);
    
    
    
}

- (void) drawCell: (Cell *) cell AtX: (float)xPos atY: (float)yPos
{
    SKSpriteNode *tile = [[SKSpriteNode alloc] initWithColor: [SKColor whiteColor] size:CGSizeMake(50,50)];
    tile.position = CGPointMake(xPos, yPos);
    

    [self addChild: tile];

    if ([cell northWall])
        [self drawWall: NORTH atX: xPos atY: yPos];
    if ([cell eastWall])
        [self drawWall: EAST atX: (xPos + 45) atY: yPos];
    if ([cell southWall])
        [self drawWall: SOUTH atX: xPos atY: (yPos - 45)];
    if ([cell westWall])
        [self drawWall: WEST atX: xPos atY: yPos];
    
}

- (void) drawWall: (int) direction atX: (float) xPos atY: (int)yPos
{
    SKSpriteNode *wall;
    
    if (direction == NORTH || direction == SOUTH)
    wall = [[SKSpriteNode alloc] initWithColor: [SKColor blackColor] size:CGSizeMake(50, 5)];
    else
        wall = [[SKSpriteNode alloc] initWithColor: [SKColor blackColor] size:CGSizeMake(5, 50)];

    wall.position = CGPointMake(xPos, yPos);
    

    wall.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild: wall];

}



@end
