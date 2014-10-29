//
//  IMRecorderMicView.h
//  manpower
//
//  Created by WangShunzhou on 14-6-27.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMRecorderMicView : UIView
//////////////////////////////////////////////////////////////
// 麦克风界面
//////////////////////////////////////////////////////////////
@property(nonatomic, strong) UIView *micWarpperView;
@property(nonatomic, strong) UIImageView *micIV;
@property(nonatomic, strong) UILabel *micSecLabel;
@property(nonatomic, strong) UILabel *micTextLabel;


//////////////////////////////////////////////////////////////
// 垃圾桶界面
//////////////////////////////////////////////////////////////
@property(nonatomic, strong) UIView *recycleWarpperView;
@property(nonatomic, strong) UIImageView *recycleIV;
@property(nonatomic, strong) UILabel *recycleTextLabel;



-(void)switchToMic;
-(void)switchToRecycle;
-(void)clear;
-(void)updateVolume:(CGFloat)volume withCurrentTime:(double)currentTime;
@end
