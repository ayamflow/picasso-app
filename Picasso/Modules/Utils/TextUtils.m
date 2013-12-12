//
//  TextUtils.m
//  Picasso
//
//  Created by MOREL Florian on 12/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "TextUtils.h"

@implementation TextUtils

+ (NSMutableAttributedString *) getString:(NSString *)text withKerning:(CGFloat)kerning {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:kerning] range:NSMakeRange(0, [text length])];
    return attributedString;
}

+ (NSMutableAttributedString *) getKernedString:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:2] range:NSMakeRange(0, [text length])];
    return attributedString;
}

@end