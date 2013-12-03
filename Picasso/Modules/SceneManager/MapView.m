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

    CGPoint positions[] = {CGPointMake(90, 254), CGPointMake(248, 420), CGPointMake(449, 271), CGPointMake(709, 183), CGPointMake(670, 385), CGPointMake(885, 486), CGPointMake(1047, 276)};
    CGFloat pointSize = 50;

    NSMutableArray *scenes = [NSMutableArray arrayWithCapacity:[dataManager getScenesNumber]];
    for(int i = 0; i < [dataManager getScenesNumber]; i++) {
        UIButton *point = [[UIButton alloc] initWithFrame:CGRectMake(positions[i].x - pointSize / 2, positions[i].y - pointSize / 2, pointSize, pointSize)];
        [point setTitle: [NSString stringWithFormat:@"%i", i + 1] forState:UIControlStateNormal];
        point.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:pointSize / 2];
        point.titleLabel.textAlignment = NSTextAlignmentCenter;
        point.layer.cornerRadius = pointSize / 2;
        point.tag = i;

        if(i <= currentSceneIndex) {
            point.backgroundColor = [UIColor blackColor];
            [point setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            point.backgroundColor = [UIColor whiteColor];
            [point setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            point.layer.borderColor = [UIColor blackColor].CGColor;
            point.layer.borderWidth = 2;
        }

        [scenes addObject:point];
        [self addSubview:point];
    }
    self.scenes = [NSArray arrayWithArray:scenes];
}

@end
