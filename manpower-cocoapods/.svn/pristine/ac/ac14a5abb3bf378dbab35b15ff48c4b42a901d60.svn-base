//
//  IMMessageImageCell.h
//  manpower
//
//  Created by WangShunzhou on 14-6-19.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "IMMessageBaseCell.h"
#import "SWImageView.h"

@interface IMMessageImageCell : IMMessageBaseCell<IMMessageDelegate>{
    NSMutableDictionary *cachedImageDic;
}
@property(nonatomic, strong) NSMutableDictionary *cachedImageDic;
@property(nonatomic, strong) SWImageView *imgView;
@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) UIActivityIndicatorView* activity;
@property(nonatomic, strong) UILabel* percentLabel;

-(void)configureWithMessage:(ZMMessage*)message withMyPhoto:(UIImage*)myPhoto withFriendPhoto:(UIImage*)friendPhoto withIndexPath:(NSIndexPath*)indexPath;
@end
