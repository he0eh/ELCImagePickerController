//
//  KCMainViewController.m
//  zhoumowan
//
//  Created by 陈贺 on 15/4/12.
//  Copyright (c) 2015年 Yock.L. All rights reserved.
//
#import "ELCBigImageViewController.h"
#import "BIGImageScrollView.h"
#import "ImageHelper.h"
#define IMAGEVIEW_COUNT 3

@interface ELCBigImageViewController ()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    BIGImageScrollView *_leftImageView;
    BIGImageScrollView *_centerImageView;
    BIGImageScrollView *_rightImageView;
    UIButton *selectButton;
}

@end

@implementation ELCBigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加滚动控件
    [self addScrollView];
    //添加图片控件
    [self addImageViews];
    [self reloadImage];
    [self initNavigationItem];
}

-(void)setImageData:(NSMutableArray *)imageData {
    _imageData = imageData;
    if (imageData) {
        self.imageCount = [imageData count];
    }
}

-(void)initNavigationItem {
    if (self.selectDelegate) {
        UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
        [delButton setImage:[UIImage imageNamed:@"icon_img_choice_invert"] forState:UIControlStateSelected];
        [delButton setImage:[UIImage imageNamed:@"icon_img_choice"] forState:UIControlStateNormal];
        [delButton addTarget:self action:@selector(selectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        ELCAsset *elcAsset = self.imageData[self.currentImageIndex];
        delButton.selected = elcAsset.selected;
        selectButton = delButton;
        UIBarButtonItem *delItem = [[UIBarButtonItem alloc] initWithCustomView:delButton];
        self.navigationItem.rightBarButtonItems = @[delItem];
    }
    [self updateTitle];
}

-(void)updateTitle {
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = [NSString stringWithFormat:@"%zd/%zd", self.currentImageIndex + 1, self.imageData.count];
}

-(void)selectButtonPressed:(UIBarButtonItem *)item {
    ELCAsset *elcAsset = self.imageData[self.currentImageIndex];
    elcAsset.selected = !elcAsset.selected;
    selectButton.selected = elcAsset.selected;
    [self.selectDelegate bigImageselectImg:self.currentImageIndex];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
}

#pragma mark 添加控件
-(void)addScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_scrollView];
    //设置代理
    _scrollView.delegate = self;
    //设置contentSize
    _scrollView.contentSize = CGSizeMake(IMAGEVIEW_COUNT * SCREEN_WIDTH, SCREEN_HEIGHT);
    //设置当前显示的位置为中间图片
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    //设置分页
    _scrollView.pagingEnabled = YES;
    //去掉滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
}

#pragma mark 添加图片三个控件
-(void)addImageViews{
    _leftImageView = [[BIGImageScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_leftImageView];
    _centerImageView = [[BIGImageScrollView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _centerImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_centerImageView];
    _rightImageView = [[BIGImageScrollView alloc]initWithFrame:CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_rightImageView];
    
}
#pragma mark 设置默认显示图片
-(void)setDefaultImage{
    //加载默认图片
    _leftImageView.image = [ImageHelper PLACEHOLDER_PIC_COMMON_250];
}

#pragma mark 滚动停止事件
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //重新加载图片
    [self reloadImage];
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
}

#pragma mark 重新加载图片
-(void)reloadImage{
    NSInteger leftImageIndex,rightImageIndex;
    CGPoint offset = [_scrollView contentOffset];
    if (offset.x > SCREEN_WIDTH) { //向右滑动
        _currentImageIndex = (_currentImageIndex + 1) % _imageCount;
    }else if(offset.x < SCREEN_WIDTH){ //向左滑动
        _currentImageIndex = (_currentImageIndex + _imageCount - 1) % _imageCount;
    }
    [self setImageForImageView:_centerImageView ByIndex:self.currentImageIndex];
    ELCAsset *elcAsset = self.imageData[self.currentImageIndex];
    selectButton.selected = elcAsset.selected;
    [self updateTitle];
    //重新设置左右图片
    leftImageIndex=(_currentImageIndex + _imageCount - 1) % self.imageCount;
    rightImageIndex=(_currentImageIndex + 1) % self.imageCount;
    [self setImageForImageView:_leftImageView ByIndex:leftImageIndex];
    [self setImageForImageView:_rightImageView ByIndex:rightImageIndex];
}

-(void)setImageForImageView:(BIGImageScrollView *)imageView ByIndex:(NSInteger) index {
    ELCAsset *elcAsset = self.imageData[index];
    ALAsset *asset = elcAsset.asset;
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    if(assetRep != nil) {
        CGImageRef imgRef = nil;
        UIImageOrientation orientation = UIImageOrientationUp;
        imgRef = [assetRep fullScreenImage];
        UIImage *img = [UIImage imageWithCGImage:imgRef
                                           scale:1.0f
                                     orientation:orientation];
        imageView.imageView.image = img;
    }
}

@end
