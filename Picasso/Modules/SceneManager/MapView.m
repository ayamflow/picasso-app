//
//  MapView.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "MapView.h"
#import "MapPathStatus.h"
#import "DataManager.h"
#import "Path1View.h"
#import "Path2View.h"
#import "Path3View.h"
#import "Path4View.h"
#import "Path5View.h"
#import "Path6View.h"

@interface MapView ()

@end

@implementation MapView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initMap];
        [self initPoints];
    }
    return self;
}

- (void)initMap {
    DataManager *dataManager = [DataManager sharedInstance];
    NSInteger currentSceneIndex = [[dataManager getGameModel] currentScene];

    for(int i = 0; i < [dataManager getScenesNumber] - 1; i++) {
        Class PathClass = NSClassFromString([NSString stringWithFormat:@"Path%iView", i + 1]);
        MapPathView *path = (MapPathView *)[[PathClass alloc] initWithFrame:self.frame];
        // i < current -> notstarted

        if(i > currentSceneIndex) path.status = [MapPathStatus PathNotStartedStatus];
        // i > current -> completed
        else if(i < currentSceneIndex) path.status = [MapPathStatus PathCompletedStatus];
        // i == current -> started
        else path.status = [MapPathStatus PathStartedStatus];

        [self addSubview:path];
    }
}

- (void)initPoints {
    DataManager *dataManager = [DataManager sharedInstance];
    NSInteger currentSceneIndex = [dataManager getGameModel].currentScene;

    CGPoint positions[] = {CGPointMake(41, 123), CGPointMake(123, 208), CGPointMake(225, 138), CGPointMake(354, 92), CGPointMake(328, 193), CGPointMake(441, 242), CGPointMake(524, 137)};
    CGFloat pointSize = 25;

    for(int i = 0; i < [dataManager getScenesNumber]; i++) {
        UILabel *point = [[UILabel alloc] initWithFrame:CGRectMake(positions[i].x - pointSize / 2, positions[i].y - pointSize / 2, pointSize, pointSize)];
        point.text = [NSString stringWithFormat:@"%i", i + 1];
        point.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:12];
        point.textAlignment = NSTextAlignmentCenter;
        point.layer.cornerRadius = pointSize / 2;

        if(i <= currentSceneIndex) {
            point.backgroundColor = [UIColor blackColor];
            point.textColor = [UIColor whiteColor];
        }
        else {
            point.backgroundColor = [UIColor whiteColor];
            point.textColor = [UIColor blackColor];
            point.layer.borderColor = [UIColor blackColor].CGColor;
            point.layer.borderWidth = 2;
        }

        [self addSubview:point];
    }
}

@end
