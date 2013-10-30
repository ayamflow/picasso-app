//
//  MenuViewController.m
//  Picasso
//
//  Created by MOREL Florian on 30/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Menu.h"
#import "OrientationUtils.h"
#import "Timeline.h"

#define BUTTON_HEIGHT 30

@interface Menu ()

@property (strong, nonatomic) UIImageView *logo;
@property (strong, nonatomic) UIButton *exploreButton;
@property (strong, nonatomic) UIButton *galleryButton;
@property (strong, nonatomic) UIButton *museumButton;
@property (strong, nonatomic) Timeline *timeline;
@property (strong, nonatomic) UIColor *textColor;

@end

@implementation Menu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.textColor = [UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1.0];
    
    [self initLogo];
    [self initButtons];
    [self initTimeline];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0]];
}

- (void)initLogo {
    CGRect screenSize = [OrientationUtils deviceSize];
    NSString *path = [[NSBundle mainBundle] pathForResource: @"logo" ofType: @"png"];
    UIImage *logoImage = [UIImage imageWithContentsOfFile:path];
    self.logo = [[UIImageView alloc] initWithImage:logoImage];
    [self.logo setCenter:CGPointMake(screenSize.size.width / 2, self.logo.frame.size.height)];
    [self.view addSubview:self.logo];
}

- (void)initButtons {
    CGRect screenSize = [OrientationUtils deviceSize];
    
    self.exploreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.exploreButton setTitle:@"Explorer" forState:UIControlStateNormal];
    [self.exploreButton setBackgroundColor:[UIColor clearColor]];
    [self.exploreButton setTitleColor:self.textColor forState:UIControlStateNormal];
    [self.exploreButton setFrame:CGRectMake(0, 0, screenSize.size.width / 2, BUTTON_HEIGHT)];
    [self.exploreButton setCenter:CGPointMake(screenSize.size.width / 2, self.logo.center.y + BUTTON_HEIGHT * 2)];
    [self.view addSubview:self.exploreButton];
    
    self.galleryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.galleryButton setTitle:@"Galerie" forState:UIControlStateNormal];
    [self.galleryButton setBackgroundColor:[UIColor clearColor]];
    [self.galleryButton setTitleColor:self.textColor forState:UIControlStateNormal];
    [self.galleryButton setFrame:CGRectMake(0, 0, screenSize.size.width / 2, BUTTON_HEIGHT)];
    [self.galleryButton setCenter:CGPointMake(screenSize.size.width / 2, self.exploreButton.center.y + BUTTON_HEIGHT * 1.2)];
    [self.view addSubview:self.galleryButton];
    
    self.museumButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.museumButton setTitle:@"Infos pratiques" forState:UIControlStateNormal];
    [self.museumButton setBackgroundColor:[UIColor clearColor]];
    [self.museumButton setTitleColor:self.textColor forState:UIControlStateNormal];
    [self.museumButton setFrame:CGRectMake(0, 0, screenSize.size.width / 2, BUTTON_HEIGHT)];
    [self.museumButton setCenter:CGPointMake(screenSize.size.width / 2, self.galleryButton.center.y + BUTTON_HEIGHT * 1.2)];
    [self.view addSubview:self.museumButton];
}

- (void)initTimeline {
    CGRect screenSize = [OrientationUtils deviceSize];
    
    self.timeline = [[Timeline alloc] init];
    [self.timeline.view setCenter:CGPointMake(screenSize.size.width / 2, screenSize.size.height - BUTTON_HEIGHT * 1.5)];
    [self.view addSubview:self.timeline.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
