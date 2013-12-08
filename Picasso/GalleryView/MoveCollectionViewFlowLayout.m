//
//  MoveCollectionViewFlowLayout.m
//  Picasso
//
//  Created by Julian on 07/12/2013.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "MoveCollectionViewFlowLayout.h"

@interface MoveCollectionViewFlowLayout ()

@property (nonatomic, strong) NSMutableArray *itemsInVisibleRectArray;
@property (nonatomic, assign) CGFloat latestDelta;

@end

@implementation MoveCollectionViewFlowLayout

-(id)init {
    if (!(self = [super init])) return nil;
    self.itemsInVisibleRectArray = [[NSMutableArray alloc]init];
    return self;
}

-(void)prepareLayout {
    [super prepareLayout];
}

/*
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.dynamicAnimator itemsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}
*/

@end
