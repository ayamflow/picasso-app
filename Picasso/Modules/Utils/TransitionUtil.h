//
//  TransitionUtil.h
//  Picasso
//
//  Created by MOREL Florian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransitionUtil : NSObject

+ (CABasicAnimation *)transitionForKey:(NSString *)key from:(float)from to:(float)to duration:(float)duration delay:(float)delay delegate:(id)delegate ease:(NSString *)ease;
+ (CABasicAnimation *)transitionForKey:(NSString *)key duration:(float)duration delegate:(id)delegate ease:(NSString *)ease;

@end
