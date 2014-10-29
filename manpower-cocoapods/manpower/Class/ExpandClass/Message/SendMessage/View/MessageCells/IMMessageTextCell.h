//
//  IMMessageTextCell.h
//  manpower
//
//  Created by WangShunzhou on 14-6-19.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "IMMessageBaseCell.h"
@class TextMessageView;

@interface IMMessageTextCell : IMMessageBaseCell

@property(nonatomic, strong) IBOutlet UILabel *txtLabel;
@property(nonatomic, strong) IBOutlet TextMessageView *msgView;

-(void)configureWithMessage:(ZMMessage*)message withMyPhoto:(UIImage*)myPhoto withFriendPhoto:(UIImage*)friendPhoto withIndexPath:(NSIndexPath*)indexPath;
@end
