//
//  UINavigationControllerPicasso.h
//  Picasso
//
//  Created by Hellopath on 19/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationController (Picasso)

- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end