//
//  Home.m
//  Picasso
//
//  Created by Florian Morel on 04/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Home.h"
#import "DataManager.h"

@implementation Home

/* TODO */
/* This class is the starting point of the app. Thus, it must init the game model, load previously saved data, etc.*/

/*
 	1- Init GameModel by loading saved data or init to zero.
 
 */

- (void)viewDidLoad {
    GameModel *gameModel = [[[DataManager sharedInstance] getGameModel] init];
}

@end
