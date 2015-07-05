//
//  MyCollectionViewCell.m
//  testScroll
//
//  Created by EG365 on 14-9-24.
//  Copyright (c) 2014年 benjaminetw. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 4;
        
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        self.imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageview.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageview];
        
    }
    return self;
}

@end
