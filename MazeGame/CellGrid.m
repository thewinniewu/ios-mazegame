//
//  CellGrid.m
//  MazeGame
//
//  Created by Winnie Wu on 7/22/13.
//  Copyright (c) 2013 Winnie Wu. All rights reserved.
//

#import "CellGrid.h"


@implementation CellGrid

- (id) initWithCols: (int) nCols withRows: (int) nRows
{
    self = [super init];
    if (self)
    {
        
        _totalCells = 0;
        _visitedCells = 1;
        _currentCell = nil;
        
        _columns = [[NSMutableArray alloc] init];
        for (int i = 0; i < nCols; i++)
        {
            NSMutableArray *newRow = [[NSMutableArray alloc] init];
            
            for (int j = 0; j < nRows; j++)
            {
                Cell *newCell = [[Cell alloc] init];
                [newRow setObject:newCell atIndexedSubscript:j];
            //    NSLog(@"New cell inputed at col %d, row %d! Cell's borders: %@, Cell's walls: %@", i, j, [newCell borderArray], [newCell wallsArray]);
                _totalCells++;
            }
            
            [_columns setObject: newRow atIndexedSubscript: i];
            
        }
    }
    return self;
}

- (id) init
{
    return [self initWithCols:4 withRows:4];
}

- (void) buildMaze
{
    
}

@end
