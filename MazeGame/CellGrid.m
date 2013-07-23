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

// must set init below to be initWithCols: 3 withRows: 3 to run this
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

// must set init below to be initWithCols: 2 withRows: 2 to run this
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
    return [self initWithCols:12 withRows:15];
}

- (int) randomDirection: (int) upperLim
{
    return (arc4random() % upperLim);
}

- (void)moveRow:(int *)rowPtr column:(int *)colPtr inDirection:(int)direction
{
    if (direction == NORTH && *rowPtr > 0)
        *rowPtr -= 1;
    else if (direction == EAST && (*colPtr + 1) < [[self columns] count])
        *colPtr += 1;
    else if (direction == SOUTH && (*rowPtr + 1) < [[[self columns] objectAtIndex: 0] count])
        *rowPtr += 1;
    else if (direction == WEST && *colPtr > 0)
        *colPtr -= 1;
    else
        NSLog(@"not a valid direction from moveRow, colPtr/rowPtr unchanged");
    
    
}

- (NSMutableArray *) findAllNeighbours: (Cell *) cell
{
    NSMutableArray *neighbours = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[cell wallsArray] count]; i++)
    {
        int newCol = [cell col];
        int newRow = [cell row];
        [self moveRow:&newRow column:&newCol inDirection:i];
        [neighbours addObject: [[[self columns] objectAtIndex:newCol] objectAtIndex: newRow]];
        
    }
    return neighbours;
    
}

- (NSMutableArray *) findUnvisitedNeighbours: (NSMutableArray *) neighbours
{
    NSMutableArray *unvisitedNeighbours = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [neighbours count]; i++)
    {
        if (![[neighbours objectAtIndex:i] visited])
            [unvisitedNeighbours addObject: [neighbours objectAtIndex: i]];
    }
    return unvisitedNeighbours;
}


- (void) buildMaze
{
    CellStack *cStack = [[CellStack alloc] init];
    
    [self setCurrentCell: [[[self columns] objectAtIndex: 0] objectAtIndex: 0]];
    [[self currentCell] setIsStart: YES];
    
    
    NSLog(@"Current cell: %@", [self currentCell]);
    NSLog(@"Total cells: %d", [self totalCells]);
    
    while ([self visitedCells] < [self totalCells])
    {
        [[self currentCell] setVisited: YES];

        NSMutableArray *neighbours = [self findAllNeighbours: [self currentCell]];
        
        NSMutableArray *unvisitedNeighbours = [self findUnvisitedNeighbours: neighbours];
        
        if ([unvisitedNeighbours count] > 0)
        {
            Cell *newCell = nil;
            while (newCell == nil)
            {
                int newDir = [self randomDirection:4];
                if (![[neighbours objectAtIndex:newDir] visited]) {
                    
                    newCell = [neighbours objectAtIndex:newDir];
                    
                    if (newDir == NORTH) {
                        [[self currentCell] setNorthWall: NO];
                        [newCell setSouthWall: NO];
                    } else if (newDir == EAST) {
                        [[self currentCell] setEastWall: NO];
                        [newCell setWestWall: NO];
                    } else if (newDir == SOUTH) {
                        [[self currentCell] setSouthWall: NO];
                        [newCell setNorthWall: NO];
                    } else {
                        [[self currentCell] setWestWall: NO];
                        [newCell setEastWall: NO];
                    }
                    
                    [cStack push: [self currentCell]];
                    [self setCurrentCell: newCell];
                    if ([[self currentCell] isEqual: [[[self columns] lastObject] lastObject]])
                        [[self currentCell] setIsEnd: YES];
                    [self setVisitedCells: [self visitedCells] + 1];
                }
            }
        } else {
            [self setCurrentCell: [cStack pop]];
        }
        
    }

}


@end
