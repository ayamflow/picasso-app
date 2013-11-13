//
//  MenuButton.m
//  Picasso
//
//  Created by MOREL Florian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "MenuButton.h"
#import "Constants.h"
#import "Menu.h"

@interface MenuButton ()

@property (strong, nonatomic) UIButton *menuButton;
@property (assign, nonatomic) CGPoint position;

@end

@implementation MenuButton

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithExploreMode:(BOOL)isExploreMode andPosition:(CGPoint)position {
    if(self = [super init]) {
        self.wasExploreMode = isExploreMode;
        self.position = position;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self initButton];
}

- (void)initButton {
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *sliderImage = [UIImage imageNamed:@"menuSlider.png"];
    [self.menuButton setImage:sliderImage forState:UIControlStateNormal];
    self.menuButton.frame = CGRectMake(0, 0, sliderImage.size.width * 2, sliderImage.size.height * 2); // Twice as big to be easier to touch
    self.view.frame = CGRectMake(self.position.x, self.position.y, self.menuButton.frame.size.width, self.menuButton.frame.size.height);
    [self.view addSubview:self.menuButton];
    [self.menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showMenu {
    [[NSNotificationCenter defaultCenter] postNotificationName:[MPPEvents MenuShownEvent] object:self];
    [self.parentViewController showMenuWithExploreMode:self.wasExploreMode andSceneMode:self.wasSceneMode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
