//
//  ViewController.m
//  LSFlowView
//
//  Created by Sen on 15/7/2.
//  Copyright (c) 2015年 Sen. All rights reserved.
//

#import "ViewController.h"
#import "ImgZoomView.h"
#import "MyCollectionViewCell.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray* testImgArr; //
    UICollectionView* myCollectionView; //
    MyLayout* layout;
    
    CGFloat content_y;
}

- (void)dealloc{
    myCollectionView.delegate = nil;
//    myCollectionView.dataSource = nil;
    layout.delegate = nil;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    myCollectionView.frame = self.view.bounds;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];

    
    //
    self.title = @"瀑布流";
    
    //【简单实现瀑布流】 以原始图片比例大小排列
    //【图片放大缩小】 图片以当前所处位置为初始位置放大至全屏自适应 双击放大缩小
    //【一个问题】 遇到一个摸不着头脑的问题，点击导航栏+号按钮即可知晓问题，还望大神们赐教!
    
    //
    testImgArr = [NSMutableArray array];
    content_y = 0;


    
    //
    layout = [[MyLayout alloc] init];
    layout.delegate = self;
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    myCollectionView.scrollEnabled = YES;
    [self.view addSubview:myCollectionView];
    
    //
    myCollectionView.backgroundColor = [UIColor clearColor];
    [myCollectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
    
    [self getTestInfo];
    
    //nav bar button
//    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(actionOfRefresh)];
//    self.navigationItem.leftBarButtonItem = leftItem;

    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionOfPushNew)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)actionOfRefresh{
    [self getTestInfo];
}
- (void)actionOfPushNew{
    
    UIAlertView* alertv = [[UIAlertView alloc] initWithTitle:@"一个问题" message:@"当push一个新的VC后，将视图滑动到底部然后返回 程序崩溃,不知道是什么原因，还望大神赐教! \n多谢!" delegate:nil cancelButtonTitle:@"让朕看看" otherButtonTitles: nil];
    [alertv show];
    
    //push一个当前VC后将视图滑动到底部然后返回 程序崩溃
    ViewController* vc = [[ViewController alloc] init];
    vc.title = @"一个错误";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getTestInfo{
    
    [testImgArr removeAllObjects];
    
    //取随机14张图片
    NSMutableArray* startArr = [NSMutableArray array];
    for (int i = 1; i<18; i++) {
        //
        NSString* obj = [NSString stringWithFormat:@"%d",i];
        [startArr addObject:obj];
    }
    NSInteger num = 14;
    for (int j = 0; j<num; j++) {
        
        int t = arc4random()%startArr.count;
        
        testImgArr[j] = startArr[t];
        
        startArr[t] = [startArr lastObject];
        [startArr removeLastObject];
        
    }
    [myCollectionView reloadData];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark - UICollectionViewDataSource delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cell_w = (collectionView.bounds.size.width-24)/2;
    
    //图片的高度
    UIImage* itemImg = [UIImage imageNamed:[NSString stringWithFormat:@"test_%@.png",testImgArr[indexPath.row]]];
    CGSize imgSize = itemImg.size;
    
    CGFloat img_h = (imgSize.height*cell_w)/imgSize.width;
    
    return CGSizeMake(cell_w, img_h);
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return testImgArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionViews cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionViews dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    
    CGFloat cell_w = cell.bounds.size.width;
    
    //
    cell.imageview.frame = CGRectMake(0, 0, cell_w, 100);
    
    UIImage* itemImg = [UIImage imageNamed:[NSString stringWithFormat:@"test_%@.png",testImgArr[indexPath.row]]];
    
    CGSize imgSize = itemImg.size;
    CGRect imgRect = CGRectMake(
                                0,
                                0,
                                cell_w,
                                (imgSize.height*cell_w)/imgSize.width);
    
    cell.imageview.image = [self scaleToSize:itemImg size:CGSizeMake(imgRect.size.width, imgRect.size.height)];
    
    cell.imageview.frame = imgRect;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCollectionViewCell* cell = (MyCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.imageview.hidden = YES;
    
    ImgZoomView* zoomV = [[ImgZoomView alloc] initWithFirstFrame:(CGRectMake(cell.frame.origin.x, cell.frame.origin.y-content_y, cell.frame.size.width, cell.frame.size.height))];
    zoomV.currImg = [UIImage imageNamed:[NSString stringWithFormat:@"test_%@.png",testImgArr[indexPath.row]]];
    [zoomV show];
    zoomV.BlockClose = ^(BOOL done){
        
        cell.imageview.hidden = NO;
    };
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    content_y = scrollView.contentOffset.y;
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
