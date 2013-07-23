//
//  CellGrid.h
//  MazeGame
//
//  Created by Winnie Wu on 7/22/13.
//  Copyright (c) 2013 Winnie Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"
#import "CellStack.h"

@class Cell;

@interface CellGrid : NSObject

extern const int NORTH;
extern const int EAST;
extern const int SOUTH;
extern const int WEST;


@property (nonatomic, strong) NSMutableArray *columns;
@property int totalCells;
@property Cell *currentCell;
@property int visitedCells;

- (void) buildMaze;
- (void) buildSimpleMaze;
-(void) buildSimpleMazeTwo;


@end
