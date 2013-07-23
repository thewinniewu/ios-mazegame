//
//  WorldScene.m
//  MazeGame
//
//  Created by Winnie Wu on 7/22/13.
//  Copyright (c) 2013 Winnie Wu. All rights reserved.
//

#import "WorldScene.h"


static const uint32_t playerCategory  =  0x1 << 0;
static const uint32_t wallsCategory  =  0x1 << 1;
static const uint32_t endCategory  =  0x1 << 2;



@interface WorldScene ()

@property BOOL contentCreated;

@end


@implementation WorldScene

- (id) init
{
    self = [super init];
    if (self)
    {
        self.physicsWorld.gravity = CGPointMake(0,0);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    if ((firstBody.categoryBitMask & endCategory) != 0)
    {
        NSLog(@"you won");
    }
}


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
 //   [mazeGrid buildSimpleMazeTwo];
    [mazeGrid buildMaze];
    
    float xPos = self.view.bounds.size.width / 4;
    float yPos = self.view.bounds.size.height / 2;
    
    SKSpriteNode *player = [self newPlayer];
    player.position = CGPointMake(xPos, yPos);
    

    
    for (NSMutableArray *column in [mazeGrid columns])
    {
        for (Cell *cellInRow in column)
        {
            [self drawCell: cellInRow AtX:xPos atY:yPos];
            yPos -= 50;
        }
        xPos += 50;
        yPos += [column count] * 50;
    }
    
    // NSLog(@"Cellgrid: %@", [mazeGrid columns]);
    
    [self addChild: player];


    
    
    
}

- (void) drawCell: (Cell *) cell AtX: (float)xPos atY: (float)yPos
{
    SKSpriteNode *tile = [[SKSpriteNode alloc] initWithColor: [SKColor whiteColor] size:CGSizeMake(50,50)];
    
    if ([cell isStart])
        tile.color = [SKColor redColor];
    if ([cell isEnd]){
        tile.color = [SKColor greenColor];
        tile.name = @"endTile";
        tile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: tile.size];
        tile.physicsBody.dynamic = NO;
        tile.physicsBody.categoryBitMask = endCategory;

    }
    
    
    tile.position = CGPointMake(xPos, yPos);
    

    [self addChild: tile];

    if ([cell northWall])
        [self drawWall: NORTH atX: xPos atY: (yPos + 25)];
    if ([cell eastWall])
        [self drawWall: EAST atX: (xPos + 25) atY: yPos];
    if ([cell southWall])
        [self drawWall: SOUTH atX: xPos atY: (yPos - 25)];
    if ([cell westWall])
        [self drawWall: WEST atX: (xPos - 25) atY: yPos];
    
}

- (void) drawWall: (int) direction atX: (float) xPos atY: (int)yPos
{
    SKSpriteNode *wall;
    
    if (direction == NORTH || direction == SOUTH)
    wall = [[SKSpriteNode alloc] initWithColor: [SKColor blackColor] size:CGSizeMake(50, 5)];
    else
        wall = [[SKSpriteNode alloc] initWithColor: [SKColor blackColor] size:CGSizeMake(5, 50)];

    wall.position = CGPointMake(xPos, yPos);
    
    wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wall.size];
    wall.physicsBody.dynamic = NO;
    wall.physicsBody.categoryBitMask = wallsCategory;

    wall.name = @"wall";
    [self addChild: wall];

}

- (SKSpriteNode *) newPlayer
{
    SKSpriteNode *player = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(10, 10)];
    
    
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.name = @"player";
    player.physicsBody.dynamic = YES;
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.collisionBitMask = wallsCategory;
    player.physicsBody.contactTestBitMask = endCategory;

    return player;
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    //Grab the touch data.
    UITouch * touch = [touches anyObject];
    SKNode *player = [self childNodeWithName:@"player"];
    CGPoint pos = [touch locationInNode:self];

    if (pos.x < player.position.x)
        self.physicsWorld.gravity = CGPointMake(-10, self.physicsWorld.gravity.y);
    if (pos.x > player.position.x)
        self.physicsWorld.gravity = CGPointMake(10, self.physicsWorld.gravity.y);
    if (pos.y > player.position.y)
        self.physicsWorld.gravity = CGPointMake(self.physicsWorld.gravity.x, 10);
    if (pos.y < player.position.y)
        self.physicsWorld.gravity = CGPointMake(self.physicsWorld.gravity.x, -10);

    
}



@end
