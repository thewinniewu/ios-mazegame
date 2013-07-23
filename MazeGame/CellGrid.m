//
//  CellGrid.m
//  MazeGame
//
//  Created by Winnie Wu on 7/22/13.
//  Copyright (c) 2013 Winnie Wu. All rights reserved.
//

#import "CellGrid.h"


int const NORTH = 0;
int const EAST = 1;
int const SOUTH = 2;
int const WEST = 3;



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
                [newCell setCol: i];
                [newCell setRow: j];
                [newRow setObject:newCell atIndexedSubscript:j];
                //    NSLog(@"New cell inputed at col %d, row %d! Cell's borders: %@, Cell's walls: %@", i, j, [newCell borderArray], [newCell wallsArray]);
                _totalCells++;
            }
            
            [_columns setObject: newRow atIndexedSubscript: i];
            
        }
    }
    return self;
}


- (void) buildSimpleMaze
{
    Cell *upperLeft = [[[self columns] objectAtIndex: 0] objectAtIndex: 0];
    Cell *lowerLeft = [[[self columns] objectAtIndex: 0] objectAtIndex: 1];
    Cell *upperRight = [[[self columns] objectAtIndex: 1] objectAtIndex: 0];
    Cell *lowerRight = [[[self columns] objectAtIndex: 1] objectAtIndex: 1];
    
    [upperLeft setSouthWall: NO];
    
    [lowerLeft setNorthWall: NO];
    [lowerLeft setEastWall: NO];
    
    [lowerRight setWestWall: NO];
    [lowerRight setNorthWall:NO];
    
    [upperRight setSouthWall: NO];
    
    
    [upperLeft setIsStart: YES];
    [upperRight setIsEnd: YES];
    
    
}


- (id) init
{
    return [self initWithCols:2 withRows:2];
}

- (int) randomDirection: (int) upperLim
{
    return (arc4random() % upperLim);
}

- (void)moveRow:(int *)rowPtr column:(int *)colPtr inDirection:(int)direction
{
    switch (direction)
    {
        case NORTH:
        {
            *rowPtr -= 1;
            break;
        }
        case EAST:
        {
            *colPtr += 1;
            break;
        }
        case SOUTH:
        {
            *rowPtr += 1;
            break;
        }
        case WEST:
        {
            *colPtr -= 1;
            break;
        }
    }
}

- (void) buildMaze
{
    CellStack *cStack = [[CellStack alloc] init];
    [self setCurrentCell: [[[self columns] objectAtIndex: 0] objectAtIndex: 0]];
    
    
    while ([self visitedCells] < [self totalCells])
    {
        NSMutableArray *unvisitedNeighbours = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[[self currentCell] wallsArray] count]; i++)
        {
            if (![[self currentCell] visited])
            {
                int newCol = [[self currentCell] col];
                int newRow = [[self currentCell] row];
                [self moveRow:&newRow column:&newCol inDirection:i];
                [unvisitedNeighbours insertObject: [[[self columns] objectAtIndex:newCol] objectAtIndex: newRow] atIndex:i];
                
                
            }
        }
        
        if ([unvisitedNeighbours count] > 0)
        {
            int newDir = [self randomDirection:4];
            Cell *newCell;
            while (newCell == nil)
            {
                if ([unvisitedNeighbours objectAtIndex:newDir]) {
                    newCell = [unvisitedNeighbours objectAtIndex:newDir];
                    [[newCell wallsArray] replaceObjectAtIndex: (newDir % 4) withObject: @1];
                    [[[self currentCell] wallsArray] replaceObjectAtIndex: newDir withObject: @1];
                    [cStack push: [self currentCell]];
                    [self setCurrentCell: newCell];
                    [self setVisitedCells: [self visitedCells] + 1];
                }                }
        } else {
            [self setCurrentCell: [cStack pop]];
        }

    }
}

@end
