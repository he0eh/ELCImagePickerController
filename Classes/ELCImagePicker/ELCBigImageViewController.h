//
//  KCMainViewController.h
//  zhoumowan
//
//  Created by 陈贺 on 15/4/12.
//  Copyright (c) 2015年 Yock.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCAsset.h"

@protocol ELCImgSelectDelegate <NSObject>
-(void)bigImageselectImg:(NSInteger)index;
@end


@interface ELCBigImageViewController : UIViewController
@property(nonatomic,assign) NSObject<ELCImgSelectDelegate> *selectDelegate;

@property (nonatomic, strong)NSMutableArray *imageData;//图片数据
@property (nonatomic)NSInteger currentImageIndex;//当前图片索引
@property (nonatomic)NSInteger imageCount;//图片总数


@end
