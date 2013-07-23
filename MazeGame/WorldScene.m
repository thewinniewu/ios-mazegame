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

int const TILESIZE = 20;
int const PLAYERSIZE = 8;

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
    self.physicsWorld.gravity = CGPointMake(0,0);

    self.backgroundColor = [SKColor lightGrayColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    CellGrid *mazeGrid = [[CellGrid alloc] init];
 //   [mazeGrid buildSimpleMazeTwo];
    [mazeGrid buildMaze];
    
    float xPos = self.view.bounds.size.width * 1 / 6;
    float yPos = self.view.bounds.size.height * 8 / 10;
    
    SKSpriteNode *player = [self newPlayer];
    player.position = CGPointMake(xPos, yPos);
    

    
    for (NSMutableArray *column in [mazeGrid columns])
    {
        for (Cell *cellInRow in column)
        {
            [self drawCell: cellInRow AtX:xPos atY:yPos];
            yPos -= TILESIZE;
        }
        xPos += TILESIZE;
        yPos += [column count] * TILESIZE;
    }
    
    // NSLog(@"Cellgrid: %@", [mazeGrid columns]);
    
    [self addChild: player];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(refresh:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"New Maze" forState:UIControlStateNormal];
    button.frame = CGRectMake(100.0, 20.0, 100.0, 40.0);
    [self.view addSubview:button];


    
    
}

- (void) refresh: (id) sender
{
    [self removeAllChildren];
    [self createSceneContents];
}

- (void) drawCell: (Cell *) cell AtX: (float)xPos atY: (float)yPos
{
    SKSpriteNode *tile = [[SKSpriteNode alloc] initWithColor: [SKColor whiteColor] size:CGSizeMake(TILESIZE,TILESIZE)];
    
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
        [self drawWall: NORTH atX: xPos atY: (yPos + TILESIZE / 2)];
    if ([cell eastWall])
        [self drawWall: EAST atX: (xPos + TILESIZE / 2) atY: yPos];
    if ([cell southWall])
        [self drawWall: SOUTH atX: xPos atY: (yPos - TILESIZE / 2)];
    if ([cell westWall])
        [self drawWall: WEST atX: (xPos - TILESIZE / 2) atY: yPos];
    
}

- (void) drawWall: (int) direction atX: (float) xPos atY: (int)yPos
{
    SKSpriteNode *wall;
    
    if (direction == NORTH || direction == SOUTH)
    wall = [[SKSpriteNode alloc] initWithColor: [SKColor blackColor] size:CGSizeMake(TILESIZE, 2)];
    else
        wall = [[SKSpriteNode alloc] initWithColor: [SKColor blackColor] size:CGSizeMake(2, TILESIZE)];

    wall.position = CGPointMake(xPos, yPos);
    
    wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wall.size];
    wall.physicsBody.dynamic = NO;
    wall.physicsBody.categoryBitMask = wallsCategory;

    wall.name = @"wall";
    [self addChild: wall];

}

- (SKSpriteNode *) newPlayer
{
    SKSpriteNode *player = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(PLAYERSIZE, PLAYERSIZE)];
    
    
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
