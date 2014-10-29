//
//  TopTabView.h
//  manpower
//
//  Created by hanjin on 14-6-4.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopTabViewDelegate <NSObject>
@required
-(void)tabBarSelected:(int)selectIndex;
@end
@interface TopTabView : UIView
@property(assign,nonatomic) id<TopTabViewDelegate> delegate;

@property(nonatomic, strong) UIButton *selectButton;  //当前选中的btn

-(id)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleAry;
@end
