//
//  AssetCell.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCAsset.h"


@protocol ELCAssetCellDelegate <NSObject>

- (void)cellSelectedOncellIndex:(NSInteger) cellindex index:(NSInteger) index;

@end

@interface ELCAssetCell : UITableViewCell

@property (nonatomic, weak) id<ELCAssetCellDelegate> cellSelectDelegate;

@property (nonatomic, assign) BOOL alignmentLeft;

- (void)setAssets:(NSArray *)assets;

@end
