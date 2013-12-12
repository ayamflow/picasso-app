//
//  InfosPanel.m
//  Picasso
//
//  Created by MOREL Florian on 27/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "InfosPanel.h"
#import "OrientationUtils.h"
#import "UIViewPicasso.h"
#import "Colors.h"
#import "TextUtils.h"

#define kLineHeight 15

@interface InfosPanel ()

@end

@implementation InfosPanel

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTransportLabels];
    [self initPhoneButton];
}

- (void)initTransportLabels {
    
    [self createTransportLabelWithLabel:self.busLabel];
    [self createTransportLabelWithLabel:self.metroLabel1];
    [self createTransportLabelWithLabel:self.metroLabel8];
    [self createTransportLabelWithLabel:self.metroLabel8bis];
    
    self.line1.layer.cornerRadius = self.line1.frame.size.width / 2;
    self.line1.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    self.line8.layer.cornerRadius = self.line8.frame.size.width / 2;
    self.line8.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    self.line8bis.layer.cornerRadius = self.line8bis.frame.size.width / 2;
    self.line8bis.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
}

- (void)createTransportLabelWithLabel:(UILabel *)label {
    label.layer.cornerRadius = label.frame.size.width / 2;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.layer.borderWidth = 1;
}

- (void)initPhoneButton {
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) { // Only iPhone can make calls
        [self.phoneButton addTarget:self action:@selector(callMuseum) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)callMuseum {
    @try {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://0142712521"]];
    }
    @catch (NSException *exception) {
        NSLog(@"Calling is not supported by this device");
    }
    @finally {
        NSLog(@"Calling is not supported by this device");
    }
}

@end
