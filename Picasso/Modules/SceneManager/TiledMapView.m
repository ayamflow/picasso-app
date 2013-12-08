//
//  TiledMapView.m
//  Picasso
//
//  Created by Florian Morel on 08/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "TiledMapView.h"

@implementation TiledMapView

+ (Class)layerClass {
    return [CATiledLayer class];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGSize tileSize = CGSizeMake(50, 50);

    int firstCol = floorf(CGRectGetMinX(rect) / tileSize.width);
    int lastCol = floorf((CGRectGetMaxX(rect)-1) / tileSize.width);
    int firstRow = floorf(CGRectGetMinY(rect) / tileSize.height);
    int lastRow = floorf((CGRectGetMaxY(rect)-1) / tileSize.height);

    for (int row = firstRow; row <= lastRow; row++) {
        for (int col = firstCol; col <= lastCol; col++) {
            UIImage *tile = [self tileAtCol:col row:row];

            CGRect tileRect = CGRectMake(tileSize.width * col, tileSize.height * row, tileSize.width, tileSize.height);
            tileRect = CGRectIntersection(self.bounds, tileRect);
            [tile drawInRect:tileRect];
        }
    }
}

- (UIImage*)tileAtCol:(int)col row:(int)row
{
    NSString *path = [NSString stringWithFormat:@"%@/x%iy%u.png", self.directoryPath, col + 1, row + 1];
    return [UIImage imageWithContentsOfFile:path];
}

@end
