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
}

- (id)init {
    // Create an array of images as long as there are scenes
    DataManager *dataManager = [DataManager sharedInstance];
    int scenesNumber = [dataManager getScenesNumber];
    
    self.scenes = [[NSMutableArray alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource: @"timeline-button" ofType: @"png"];
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    
    for(int i = 0; i < scenesNumber; i++) {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        //        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        //        imageView.frame = CGRectMake(10 + imageView.frame.size.width * i, screenSize.size.height - 60, imageView.frame.size.width, imageView.frame.size.height);
        //        imageView.tag = i;
        
        //        imageView.userInteractionEnabled = YES;
        //        [imageView addGestureRecognizer:tapGestureRecognizer];
        
        //        [self.scenes addObject:imageView];
        //        [self.view addSubview:imageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setBackgroundImage:image forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(touchEnded:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
        button.frame = CGRectMake(10 + 15 * i, screenSize.size.height - 60, 15, 15);
        button.tag = i;
        [self.view addSubview:button];
        [self.scenes addObject:button];
    }
    
    return [super init];
}

-(void)touchEnded:(id)sender
{
    NSLog(@"coucou");
//    UITouch *touch = [[event allTouches] anyObject];
//    NSLog(@"Touched image #%i", touch.view.tag);
}
@end
