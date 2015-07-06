//
//  MyLayout.m
//  testScroll
//
//  Created by EG365 on 14-9-24.
//  Copyright (c) 2014年 benjaminetw. All rights reserved.
//

#import "MyLayout.h"

#define ITEM_SIZE 70

@implementation MyLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    self.itemWidth = (self.collectionView.bounds.size.width-24)/2;
    
    self.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    self.delegate = (id<WaterFlayoutDelegate>)self.collectionView.delegate;
    
    CGSize size = self.collectionView.frame.size;
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    _center = CGPointMake(size.width/2.0, size.height/2.0);
    _radius = MIN(size.width, size.height)/2.5;
}

- (CGSize)collectionViewContentSize{
    
    return CGSizeMake(self.collectionView.bounds.size.width, (leftY>rightY?leftY:rightY));
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath  withIndex:(int)index{
    CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    
    CGFloat itemHeight = floorf(itemSize.height *self.itemWidth / itemSize.width);
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    index+=1;
    
    
    if (index%2==0) {
        
        x+=(self.itemWidth+self.sectionInset.left);
        rightY+=self.sectionInset.top;
        attributes.frame = CGRectMake(x, rightY, self.itemWidth, itemHeight);
        rightY+=itemHeight;
        
    }else if(index%2==1){
        
        x=self.sectionInset.left;
        leftY+=self.sectionInset.top;
        attributes.frame = CGRectMake(x, leftY, self.itemWidth, itemHeight);
        leftY+=itemHeight;
        
    }
    
    return attributes;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    x=0;
    leftY=0;
    rightY=0;
    
    NSMutableArray* attributes = [NSMutableArray array];

    for (int i=0 ; i <self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath withIndex:i]];
    }
    return attributes;
}

@end
