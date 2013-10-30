//
//  Timeline.m
//  Picasso
//
//  Created by Florian Morel on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Timeline.h"
#import "DataManager.h"

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
    int scenesNumber = [dataManager getScenesNumber];
    
    self.scenes = [[NSMutableArray alloc] initWithCapacity:scenesNumber];
    NSString *path = [[NSBundle mainBundle] pathForResource: @"timeline-button" ofType: @"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];

    int spaceBetweenScenes = 20;
    
    for(int i = 0; i < scenesNumber; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchEnded:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(i * spaceBetweenScenes, 0, image.size.width, image.size.height)];
        [button setTag:i];
        [self.view addSubview:button];
        [self.scenes addObject:button];
    }
    
    [self.view setClipsToBounds:YES];
    [self.view setFrame:CGRectMake(0, 0, scenesNumber * (image.size.width + spaceBetweenScenes), image.size.height)];
//    [self.view setFrame:CGRectMake(0, 0, 0.4, 250)];
    [self.view setBackgroundColor:[UIColor redColor]];
    
    NSLog(@"Size: %fx%f", scenesNumber * (image.size.width + spaceBetweenScenes), image.size.height);
//    NSLog(@"Size: %fx%f", self.view.frame.size.width, self.view.frame.size.height);
}

-(void)touchEnded:(id)sender {
    NSLog(@"[Timeline] Touch #%i", [sender tag]);
//    [self.delegate showSceneWithNumber:[sender tag]];
}

@end
