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
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    
    for(int i = 0; i < scenesNumber; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchEnded:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
        button.frame = CGRectMake(10 + 15 * i, screenSize.size.height - 60, 15, 15);
        [button setTag:i];
        [self.view addSubview:button];
        [self.scenes addObject:button];
    }
}

-(void)touchEnded:(id)sender
{
    [self.delegate showSceneWithNumber:[sender tag]];
}

@end
