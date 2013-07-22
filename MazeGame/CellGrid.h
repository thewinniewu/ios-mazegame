//
//  CellGrid.h
//  MazeGame
//
//  Created by Winnie Wu on 7/22/13.
//  Copyright (c) 2013 Winnie Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"

@class Cell;

@interface CellGrid : NSObject

@property (nonatomic, strong) NSMutableArray *columns;
@property int totalCells;
@property Cell *currentCell;
@property int visitedCells;


@end
