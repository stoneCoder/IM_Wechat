//
//  FriendInfoView.h
//  manpower
//
//  Created by hanjin on 14-6-6.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FriendInfoViewDelegate <NSObject>
@required
-(void)tuchFriendInfoView;
@end

@interface FriendInfoView : UIView
@property (strong,nonatomic) UIImageView * picImgView;
@property (strong,nonatomic) UILabel * nameLab;
@property(assign,nonatomic) id<FriendInfoViewDelegate> delegate;
-(void)updateView:(NSDictionary *)dic;
@end
