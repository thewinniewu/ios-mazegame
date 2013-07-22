//
//  Cell.h
//  MazeGame
//
//  Created by Winnie Wu on 7/22/13.
//  Copyright (c) 2013 Winnie Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject

@property (nonatomic, strong) NSArray *borderArray;
@property (nonatomic, strong) NSArray *wallsArray;

@property BOOL visited;

@end
