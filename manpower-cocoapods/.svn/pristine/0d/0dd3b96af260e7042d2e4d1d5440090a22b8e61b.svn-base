//
//  RLTBC.h
//  manpower
//
//  Created by hanjin on 14-6-4.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLTBC : UITabBarController
@property(nonatomic, assign) NSInteger lastSelectedIndex;//上次选中的索引值
@property(nonatomic, assign) NSInteger lastDifferentIndex;//上次选中的其他tab的索引值

@property (strong,nonatomic) UILabel * bangLab;
- (void)selectItemAtIndex:(NSInteger)index;

//设置消息badge
-(void)setBadgeNum:(NSString *)aNumStr;

-(NSString *)currentBadgeNum;
@end
