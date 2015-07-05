//
//  MyLayout.h
//  testScroll
//
//  Created by EG365 on 14-9-24.
//  Copyright (c) 2014年 benjaminetw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WaterFlayoutDelegate <UICollectionViewDelegate>

@required
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section;

@end

@interface MyLayout : UICollectionViewLayout
{
    float x;
    float leftY;
    float rightY;
    float YY;
}

@property float itemWidth;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;

@property (nonatomic, weak) id<WaterFlayoutDelegate>delegate;

@property (nonatomic, strong) NSMutableArray* allItemAttributes;

@property (nonatomic, assign) UIEdgeInsets sectionInset;

@property (nonatomic, assign) BOOL orientation;



@end
