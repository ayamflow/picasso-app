//
//  MapView.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "MapView.h"
#import "Events.h"
#import "MapPathStatus.h"
#import "DataManager.h"
#import "TiledMapView.h"
#import "Path1View.h"
#import "Path4View.h"
#import "Path5View.h"
#import "Path6View.h"

#define kTopOffset 60

@interface MapView ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *cityLabels;
@property (strong, nonatomic) NSArray *paths;

@end

@implementation MapView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initTiledMap];
        [self initLabels];
        [self initPath];
        [self initPoints];
    }
    return self;
}

- (void)initTiledMap {
    TiledMapView *tiledMap = [[TiledMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 2)];
    tiledMap.directoryPath = [[[NSBundle mainBundle] pathForResource:@"x1y1@2x" ofType:@".png"] stringByReplacingOccurrencesOfString:@"x1y1@2x.png" withString:@""];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:tiledMap];
    self.scrollView.contentSize = tiledMap.frame.size;
    self.scrollView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    self.scrollView.delegate = self;
}


- (void)initLabels {
    NSMutableArray *labels = [NSMutableArray arrayWithCapacity:7];
    NSArray *cities = [NSArray arrayWithObjects:@"Malaga", @"La Corogne", @"Barcelone", @"Paris", @"Dinard", @"Boisloup", @"Moujin", nil];
    CGPoint positions[] = {CGPointMake(175, 552), CGPointMake(167, 360), CGPointMake(312, 440), CGPointMake(391, 165), CGPointMake(297, 154), CGPointMake(396, 329), CGPointMake(423, 377)};

    CGSize labelSize = CGSizeMake(80, 15);
    for(int i = 0; i < [cities count]; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(positions[i].x - labelSize.width / 2, positions[i].y - labelSize.height / 2, labelSize.width, labelSize.height)];
        label.font = [UIFont fontWithName:@"BrandonGrotesque-Regular" size:12];
        label.textColor = [UIColor blackColor];
        label.text = [[cities objectAtIndex:i] uppercaseString];
        label.textAlignment = NSTextAlignmentCenter;
        [labels addObject:label];
        [self.scrollView addSubview:label];
    }

    self.cityLabels = [NSArray arrayWithArray:labels];

}

- (void)initPath {
    DataManager *dataManager = [DataManager sharedInstance];
    NSInteger currentSceneIndex = [[dataManager getGameModel] currentScene];

    NSArray *pathClasses = [NSArray arrayWithObjects:[Path1View class], [Path4View class], [Path5View class], [Path6View class], nil];
    NSMutableArray *paths = [NSMutableArray arrayWithCapacity:[pathClasses count]];
    
    int i = 0;
    for(Class PathClass in pathClasses) {
        
        MapPathView *path = (MapPathView *)[[PathClass alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
        // i < current -> notstarted

        if(i > currentSceneIndex) path.status = [MapPathStatus PathNotStartedStatus];
        // i > current -> completed
        else if(i < currentSceneIndex) path.status = [MapPathStatus PathCompletedStatus];
        // i == current -> started
        else path.status = [MapPathStatus PathStartedStatus];

        i++;
        [paths addObject:path];
        [self.scrollView addSubview:path];
    }
    
    self.paths = [NSArray arrayWithArray:paths];
}

- (void)initPoints {
    DataManager *dataManager = [DataManager sharedInstance];
    NSInteger currentSceneIndex = [dataManager getGameModel].currentScene;

    CGPoint positions[] = {CGPointMake(174, 524), CGPointMake(385, 215), CGPointMake(387, 191), CGPointMake(364, 185), CGPointMake(306, 179), CGPointMake(396, 350), CGPointMake(423, 354)};
    CGFloat pointSize = 25;

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

        point.tag = i;
        [point addTarget:self action:@selector(sceneTouched:) forControlEvents:UIControlEventTouchUpInside];
        [scenes addObject:point];
        [self.scrollView addSubview:point];
    }
    self.scenes = [NSArray arrayWithArray:scenes];
}

- (void)sceneTouched:(id)sender {
    UILabel *scene = (UILabel *)sender;
    [self.scrollView scrollRectToVisible:CGRectMake(0, scene.frame.origin.y - self.frame.size.height / 2, self.frame.size.width, self.frame.size.height) animated:YES];
    
    CATransform3D zoom = CATransform3DScale(CATransform3DIdentity, 1.3, 1.3, 1.0);
    CATransform3D skew = CATransform3DRotate(zoom, 0.3, 1.0, 1.0, 0);
    [UIView animateWithDuration:0.6 animations:^{
        self.scrollView.layer.transform = skew;
        for(MapPathView *path in self.paths) {
            path.alpha = 0;
        }
        for(int i = 0; i < [self.scenes count]; i++) {
            [[self.scenes objectAtIndex:i] setAlpha:0];
            [[self.cityLabels objectAtIndex:i] setAlpha:0];
        }
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[MPPEvents ShowSceneChooserLandscapeEvent] object:nil];
    }];
}

- (void)showDetails {
    [UIView animateWithDuration:0.6 animations:^{
        self.scrollView.layer.transform = CATransform3DIdentity;
        for(MapPathView *path in self.paths) {
            path.alpha = 1;
        }
        for(int i = 0; i < [self.scenes count]; i++) {
            [[self.scenes objectAtIndex:i] setAlpha:1];
            [[self.cityLabels objectAtIndex:i] setAlpha:1];
        }
    }];
}

// UIScrollView protocol

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self toggleLabelsVisibility];

    UILabel *label = [self.cityLabels objectAtIndex:0];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate) [self toggleLabelsVisibility];
}

- (void)toggleLabelsVisibility {
    // Show/hide cityLabels
    for(int i = 0; i < [self.cityLabels count]; i++) {
        UILabel *label = [self.cityLabels objectAtIndex:i];
        [self updateLabel:label visibilityWithOffset:self.scrollView.contentOffset.y];

        UILabel *scene = [self.scenes objectAtIndex:i];
        [self updateLabel:scene visibilityWithOffset:self.scrollView.contentOffset.y];
    }

}

- (void)updateLabel:(UILabel *)label visibilityWithOffset:(CGFloat)offset {
    if(label.enabled && (label.frame.origin.y - offset <= kTopOffset || label.frame.origin.y - offset > self.frame.size.height - kTopOffset )) {
        label.enabled = NO;
//        [UIView animateWithDuration:0.3 animations:^{
//            label.alpha = 0;
//        } completion:^(BOOL finished) {
            label.hidden = YES;
//        }];
    }
    else if(!label.enabled && label.frame.origin.y - offset > kTopOffset && label.frame.origin.y - offset <= self.frame.size.height - kTopOffset) {
        label.hidden = NO;
//        [UIView animateWithDuration:0.3 animations:^{
            label.enabled = YES;
//            label.alpha = 1;
//        }];
    }
}

@end
