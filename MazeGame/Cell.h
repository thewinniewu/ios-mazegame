//
//  Cell.h
//  MazeGame
//
//  Created by Winnie Wu on 7/22/13.
//  Copyright (c) 2013 Winnie Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject

@property (nonatomic, strong) NSMutableArray *borderArray;
@property (nonatomic, strong) NSMutableArray *wallsArray;

@property int row;
@property int col;

@property BOOL isStart;
@property BOOL isEnd;

@property BOOL northWall;
@property BOOL eastWall;
@property BOOL southWall;
@property BOOL westWall;


@property BOOL visited;

@end
