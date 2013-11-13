//
//  TransitionUtil.m
//  Picasso
//
//  Created by MOREL Florian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "TransitionUtil.h"

@implementation TransitionUtil

+ (CABasicAnimation *)transitionForKey:(NSString *)key from:(float)from to:(float)to duration:(float)duration delay:(float)delay delegate:(id)delegate ease:(NSString *)ease {
    CABasicAnimation *transition = [CABasicAnimation animationWithKeyPath:key];
    transition.duration = duration;
    transition.fromValue = [NSNumber numberWithDouble:from];
    transition.toValue = [NSNumber numberWithDouble:to];
    transition.delegate = delegate;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:ease];
    transition.beginTime = CACurrentMediaTime() + delay;
    
    return transition;
}

+ (CABasicAnimation *)transitionForKey:(NSString *)key duration:(float)duration delegate:(id)delegate ease:(NSString *)ease {
    CABasicAnimation *transition = [CABasicAnimation animationWithKeyPath:key];
    transition.duration = duration;
    transition.delegate = delegate;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:ease];
    
    return transition;
}

@end
