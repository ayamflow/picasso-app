//
//  Timeline.m
//  Picasso
//
//  Created by Florian Morel on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Timeline.h"
#import "DataManager.h"
#import "OrientationUtils.h"

@interface Timeline ()

@property (strong, nonatomic) NSMutableArray *scenes;

@end

@implementation Timeline

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initTimeline];
}

- (id)init {
    if(self = [super init]) {
        [self initTimeline];
    }
    return self;
}

- (void)initTimeline {
    DataManager *dataManager = [DataManager sharedInstance];
    NSInteger scenesNumber = [dataManager getScenesNumber];
    
    self.scenes = [[NSMutableArray alloc] initWithCapacity:scenesNumber];
    NSString *path = [[NSBundle mainBundle] pathForResource: @"timeline-button" ofType: @"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];

    int spaceBetweenScenes = 20;
    CGRect screenSize = [OrientationUtils deviceSize];
    
    for(int i = 0; i < scenesNumber; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchEnded:) forControlEvents:UIControlEventTouchUpInside];
//        [button setFrame:CGRectMake(i * spaceBetweenScenes, 0, image.size.width, image.size.height)];
        [button setFrame:CGRectMake(screenSize.size.width / 2 - (i * spaceBetweenScenes), screenSize.size.height - 30 * 1.5, image.size.width, image.size.height)];
        [button setTag:i];
        [self.view addSubview:button];
        [self.scenes addObject:button];
    }
    
//    [self.view setClipsToBounds:YES];
//    [self.view setFrame:CGRectMake(0, 0, (scenesNumber - 1) * (image.size.width + spaceBetweenScenes), image.size.height)];
    UIButton *button = [self.scenes objectAtIndex:0];
    [self.view setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, (scenesNumber - 1) * (image.size.width + spaceBetweenScenes), image.size.height)];
    [self.view setBackgroundColor:[UIColor redColor]];
    
    NSLog(@"Size: %fx%f", scenesNumber * (image.size.width + spaceBetweenScenes), image.size.height);
//    NSLog(@"Size: %fx%f", self.view.frame.size.width, self.view.frame.size.height);
}

-(void)touchEnded:(id)sender {
    NSLog(@"[Timeline] Touch #%ld", [sender tag]);
//    [self.delegate showSceneWithNumber:[sender tag]];
}

@end
