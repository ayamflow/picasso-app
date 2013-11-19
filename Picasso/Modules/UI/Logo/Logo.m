//
//  Logo.m
//  Picasso
//
//  Created by MOREL Florian on 14/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Logo.h"
#import "Colors.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLogo];
    self.view.frame = CGRectMake(0, 0, 4 * self.five.frame.size.width - 3 * kBorderWidth, self.five.frame.size.height + kOpenedGap * 2);
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
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
        [self.view addSubview:logoBlock];
        i++;
    }
}

- (void)transitionOpenWithDuration:(CFTimeInterval)duration andDelay:(CFTimeInterval)delay {
    NSArray *labels = [NSArray arrayWithObjects:self.five, self.zero, self.secondZero, self.thirdZero, nil];
    
    int i = 0;
    for(UIImageView *logoBlock in labels) {
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGPoint labelPosition = logoBlock.layer.position;
            labelPosition.y += i % 2 == 0 ? -kClosedGap : kClosedGap;
            logoBlock.layer.position = labelPosition;
        } completion:^(BOOL finished) {
            
        }];
        i++;
    }
}

@end
