//
//  WorkCollectionDelegate.h
//  Picasso
//
//  Created by RENARD Julian on 10/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WorkCollectionDelegate <NSObject>

- (void) workTouchedWithIndex:(NSInteger)index;

@end
