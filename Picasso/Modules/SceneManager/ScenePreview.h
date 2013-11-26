//
//  ScenePreview.h
//  Picasso
//
//  Created by MOREL Florian on 25/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneModel.h"

@interface ScenePreview : UIViewController

- (id)initWithModel:(SceneModel *)model;
- (void)resetButtonColor;

@end
