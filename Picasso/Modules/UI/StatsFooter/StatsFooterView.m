//
//  StatsFooterView.m
//  Picasso
//
//  Created by MOREL Florian on 11/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "StatsFooterView.h"
#import "DataManager.h"
#import "UIViewPicasso.h"
#import "OrientationUtils.h"

@interface StatsFooterView ()

@end

@implementation StatsFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initStats];
    }
    return self;
}

- (void)initStats {
    UIImageView *chapterIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scenesNumber.png"]];
    [self addSubview:chapterIcon];
    UILabel *chapterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width / 4, 20)];
    chapterLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:12];
    chapterLabel.textColor = [UIColor blackColor];
    chapterLabel.text = [[NSString stringWithFormat:@"%li / %li chapitres", [[[DataManager sharedInstance] getGameModel] lastUnlockedScene] + 1, [[DataManager sharedInstance] getScenesNumber]] uppercaseString];
    [chapterLabel sizeToFit];
    [self addSubview:chapterLabel];
    
    UIImageView *workIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"worksNumber.png"]];
    [self addSubview:workIcon];
    UILabel *worksLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width / 4, 20)];
    worksLabel.font = chapterLabel.font;
    worksLabel.textColor = [UIColor blackColor];
    worksLabel.text = [[NSString stringWithFormat:@"%i / %i oeuvres", [[[DataManager sharedInstance] getGameModel] lastUnlockedWork], [[DataManager sharedInstance] getWorksNumber]] uppercaseString];
    [worksLabel sizeToFit];
    [self addSubview:worksLabel];
    
    if(self.bounds.size.width < [OrientationUtils nativeDeviceSize].size.height) {
        CGFloat tempWidth = chapterIcon.frame.size.width * 1.5 + chapterLabel.frame.size.width;
        [chapterLabel moveTo:CGPointMake(70, self.bounds.size.height - chapterLabel.frame.size.height * 2)];
        [chapterIcon moveTo:CGPointMake(40, chapterLabel.frame.origin.y - 2)];
        
        tempWidth = workIcon.frame.size.width * 1.5 + worksLabel.frame.size.width;
        [worksLabel moveTo:CGPointMake(self.bounds.size.width - 40 - worksLabel.frame.size.width, self.bounds.size.height - worksLabel.frame.size.height * 2)];
        [workIcon moveTo:CGPointMake(worksLabel.frame.origin.x - workIcon.frame.size.width - 10, worksLabel.frame.origin.y - 2)];
    }
    else {
        CGFloat tempWidth = chapterIcon.frame.size.width * 1.5 + chapterLabel.frame.size.width;
        [chapterLabel moveTo:CGPointMake(self.bounds.size.width / 3 - tempWidth / 2, self.bounds.size.height - chapterLabel.frame.size.height * 2)];
        [chapterIcon moveTo:CGPointMake(chapterLabel.frame.origin.x - chapterIcon.frame.size.width * 1.5, chapterLabel.frame.origin.y - 2)];
        
        tempWidth = workIcon.frame.size.width * 1.5 + worksLabel.frame.size.width;
        [worksLabel moveTo:CGPointMake(self.bounds.size.width * 2 / 3 - tempWidth / 2, self.bounds.size.height - worksLabel.frame.size.height * 2)];
        [workIcon moveTo:CGPointMake(worksLabel.frame.origin.x - workIcon.frame.size.width * 1.5, worksLabel.frame.origin.y - 2)];
    }
}

@end
