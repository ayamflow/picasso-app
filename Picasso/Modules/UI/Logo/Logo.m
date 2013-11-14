//
//  Logo.m
//  Picasso
//
//  Created by MOREL Florian on 14/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Logo.h"
#import "Constants.h"

#define kLogoBlockSize 65
#define kBorderWidth 2.5
#define kOpenedGap 10
#define kClosedGap 5

@interface Logo ()

@property (strong, nonatomic) UIImageView *five;
@property (strong, nonatomic) UIImageView *zero;
@property (strong, nonatomic) UIImageView *secondZero;
@property (strong, nonatomic) UIImageView *thirdZero;

@end

@implementation Logo

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
    [self initLogo];
    self.view.frame = CGRectMake(0, 0, 4 * self.five.frame.size.width - 3 * kBorderWidth, self.five.frame.size.height + kOpenedGap * 2);
}

- (void)initLogo {

    self.five = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo5.png"]];
    self.zero = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo0.png"]];
    self.secondZero = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo0.png"]];
    self.thirdZero = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo0.png"]];
    
    NSArray *labels = [NSArray arrayWithObjects:self.five, self.zero, self.secondZero, self.thirdZero, nil];
    
    int i = 0;
    float leftPosition = 0;
    float topPosition = 0;
    for(UIImageView *logoBlock in labels) {
        leftPosition = i > 0 ? i * kLogoBlockSize - kBorderWidth * i : 0;
        topPosition = i % 2 == 0 ? 0 : kClosedGap;
        logoBlock.contentMode = UIViewContentModeCenter;
        logoBlock.frame = CGRectMake(leftPosition, topPosition, kLogoBlockSize, kLogoBlockSize);
        logoBlock.layer.borderColor = [UIColor textColor].CGColor;
        logoBlock.layer.borderWidth = kBorderWidth;
        // Set font
        [self.view addSubview:logoBlock];
        i++;
    }
}

- (void)transitionOpenWithDuration:(CFTimeInterval)duration andDelay:(CFTimeInterval)delay {
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    NSArray *labels = [NSArray arrayWithObjects:self.five, self.zero, self.secondZero, self.thirdZero, nil];
    
    int i = 0;
    for(UIImageView *logoBlock in labels) {
        CABasicAnimation *openTransition = [CABasicAnimation animationWithKeyPath:@"position"];
        openTransition.beginTime = CACurrentMediaTime() + delay;
        CGPoint labelPosition = logoBlock.layer.position;
        labelPosition.y += i % 2 == 0 ? -kClosedGap : kClosedGap;
        openTransition.fillMode = kCAFillModeForwards;
        openTransition.removedOnCompletion = NO;
        openTransition.fromValue = [NSValue valueWithCGPoint:logoBlock.layer.position];
        openTransition.toValue = [NSValue valueWithCGPoint:labelPosition];
        openTransition.delegate = self;
        
        [logoBlock.layer addAnimation:openTransition forKey:@"labelPosition"];
        i++;
    }
    
    [CATransaction commit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
