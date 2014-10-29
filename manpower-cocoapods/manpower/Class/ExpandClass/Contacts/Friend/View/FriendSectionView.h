//
//  FriendSectionView.h
//  manpower
//
//  Created by hanjin on 14-6-23.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionInfoModel.h"
@class FriendSectionView;
@protocol FriendSectionViewDelegate <NSObject>
@optional
-(void)longTuchInSecionView:(FriendSectionView *)aSectionView;
@required
-(void)clickSectionView:(int)index;
@end
@interface FriendSectionView : UITableViewHeaderFooterView<UIGestureRecognizerDelegate>
@property (strong,nonatomic) UILabel *  groupLab;
@property (strong,nonatomic) UILabel * numInfoLab;
@property (assign,nonatomic) id<FriendSectionViewDelegate> delegate;
@property (assign,nonatomic) int index;
@property (strong,nonatomic) UIImageView * sectionImageView;
@property (assign,nonatomic) BOOL isSelected;
@property (strong,nonatomic) SectionInfoModel * model;
-(void)loadViewWithName:(NSString *)aName numInfo:(NSString *)info;

-(void)loadViewWithSectionModel:(SectionInfoModel *)aModel numInfo:(NSString *)info;
@end
