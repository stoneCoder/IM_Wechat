//
//  QBAssetsBarButtonItem.m
//  manpower
//
//  Created by WangShunzhou on 14-8-29.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "QBAssetsBarButtonItem.h"
@interface QBAssetsBarButtonItem(){

}
@property(nonatomic, strong) NSString *badge;

@property (nonatomic, strong) UILabel *badgeLabel;
@end

@implementation QBAssetsBarButtonItem


-(void)updateBadge{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    self.badgeLabel.text = _badge;
    self.badgeLabel.textColor = [UIColor whiteColor];
    [self.badgeLabel sizeToFit];
    if (![self.customView.subviews containsObject:_badgeLabel]) {
        [self.customView addSubview:self.badgeLabel];
    }
}
@end
