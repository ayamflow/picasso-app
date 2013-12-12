//
//  TextUtils.h
//  Picasso
//
//  Created by MOREL Florian on 12/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextUtils : NSObject

+ (NSMutableAttributedString *) getString:(NSString *)text withKerning:(CGFloat)kerning;
+ (NSMutableAttributedString *) getKernedString:(NSString *)text;

@end
