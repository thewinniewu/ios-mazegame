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

- (void) buildSimpleMazeTwo
{
    Cell *a1 = [[[self columns] objectAtIndex: 0] objectAtIndex: 0];
    Cell *a2 = [[[self columns] objectAtIndex: 0] objectAtIndex: 1];
    Cell *a3 = [[[self columns] objectAtIndex: 0] objectAtIndex: 2];
    Cell *b1 = [[[self columns] objectAtIndex: 1] objectAtIndex: 0];
    Cell *b2 = [[[self columns] objectAtIndex: 1] objectAtIndex: 1];
    Cell *b3 = [[[self columns] objectAtIndex: 1] objectAtIndex: 2];
    Cell *c1 = [[[self columns] objectAtIndex: 2] objectAtIndex: 0];
    Cell *c2 = [[[self columns] objectAtIndex: 2] objectAtIndex: 1];
    Cell *c3 = [[[self columns] objectAtIndex: 2] objectAtIndex: 2];
   
    [a1 setIsStart: YES];
    [a1 setSouthWall: NO];
    
    [a2 setNorthWall: NO];
    [a2 setSouthWall: NO];
    
    [a3 setNorthWall: NO];
    [a3 setEastWall:NO];
    
    [b3 setWestWall: NO];
    [b3 setEastWall:NO];
    
    [c3 setWestWall: NO];
    [c3 setNorthWall:NO];

    [c2 setSouthWall: NO];
    [c2 setWestWall:NO];
    
    [b2 setEastWall: NO];
    [b2 setNorthWall: NO];
    
    [b1 setSouthWall: NO];
    [b1 setEastWall:NO];
    
    [c1 setWestWall: NO];
    [c1 setIsEnd: YES];
    
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
    return [self initWithCols:3 withRows:3];
}

- (int) randomDirection: (int) upperLim
{
    return (arc4random() % upperLim);
}

- (void)moveRow:(int *)rowPtr column:(int *)colPtr inDirection:(int)direction
{
    if (direction == NORTH)
        *rowPtr -= 1;
    else if (direction == EAST)
        *colPtr += 1;
    else if (direction == SOUTH)
        *rowPtr += 1;
    else if (direction == WEST)
        *colPtr -= 1;
    else
        NSLog(@"error, not a valid direction from moveRow");
    
    
}

- (void) buildMaze
{
    CellStack *cStack = [[CellStack alloc] init];
    
    [self setCurrentCell: [[[self columns] objectAtIndex: 0] objectAtIndex: 0]];
    
    while ([self visitedCells] < [self totalCells])
    {
        NSMutableArray *neighbours = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[[self currentCell] wallsArray] count]; i++)
        {
            int newCol = [[self currentCell] col];
            int newRow = [[self currentCell] row];
            [self moveRow:&newRow column:&newCol inDirection:i];
            [neighbours insertObject: [[[self columns] objectAtIndex:newCol] objectAtIndex: newRow] atIndex:i];
            
        }
        
        NSMutableArray *unvisitedNeighbours = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [neighbours count]; i++)
        {
            if (![[unvisitedNeighbours objectAtIndex:i] visited])
                [unvisitedNeighbours addObject: [unvisitedNeighbours objectAtIndex: i]];
        }
        
        if ([unvisitedNeighbours count] > 0)
        {
            int newDir = [self randomDirection:4];
            Cell *newCell;
            while (newCell == nil)
            {
                if (![[neighbours objectAtIndex:newDir] visited]) {
                    newCell = [neighbours objectAtIndex:newDir];
                    [[newCell wallsArray] replaceObjectAtIndex: (newDir % 4) withObject: @1];
                    [[[self currentCell] wallsArray] replaceObjectAtIndex: newDir withObject: @1];
                    [[self currentCell] setVisited: YES];
                    [cStack push: [self currentCell]];
                    [self setCurrentCell: newCell];
                    [self setVisitedCells: [self visitedCells] + 1];
                }
            }
        } else {
            [self setCurrentCell: [cStack pop]];
        }
        
    }
    
    for (int col = 0; col < [[self columns] count]; col ++)
    {
        for (int row = 0; row < [[[self columns] objectAtIndex: col] count]; row ++)
        {
            Cell *cell = [[[self columns] objectAtIndex: col] objectAtIndex: row];
            [self setWalls: cell];
        }
    }
        
         
         }

- (void) setWalls: (Cell *) cell
{
    if ([[[cell borderArray] objectAtIndex: 0]  isEqual: @1] || [[[cell wallsArray] objectAtIndex: 0]  isEqual: @1])
        [cell setNorthWall: NO];
    if ([[[cell borderArray] objectAtIndex: 1]  isEqual: @1] || [[[cell wallsArray] objectAtIndex: 1]  isEqual: @1])
        [cell setEastWall: NO];
    if ([[[cell borderArray] objectAtIndex: 2]  isEqual: @1] || [[[cell wallsArray] objectAtIndex: 2]  isEqual: @1])
        [cell setSouthWall: NO];
    if ([[[cell borderArray] objectAtIndex: 3]  isEqual: @1] || [[[cell wallsArray] objectAtIndex: 3]  isEqual: @1])
        [cell setWestWall: NO];
}

@end
