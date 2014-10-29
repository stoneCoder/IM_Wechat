//
//  RLBaseVC.h
//  manpower
//
//  Created by hanjin on 14-6-4.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface RLBaseVC : UIViewController

/**
 *  功能:设置导航栏个性化标题
 */
- (void)setTitleText:(NSString *)aTitleText;


/**
 *  功能:显示左按钮
 *  aVisible:是否显示按钮
 */
- (void)makeNaviLeftButtonVisible:(BOOL)aVisible;

/**
 *  功能:设置返回按钮个性化标题
 */
-(void)setReturnBtnTitle:(NSString *)aTitle BadgeNumber:(int)aNumber;

/**
 *  功能:是否显示返回按钮
 */
-(void)hideReturnBtn;


/**
 *  设置右按钮
 *
 *  @param title  按钮标题
 *  @param target 响应点击事件的对象
 *  @param sel    Selector
 *
 *  @return 右按钮的自定义Button
 */
-(UIButton*)setRightBarButtonWithTitle:(NSString*)title withTarget:(id)target withSelector:(SEL)sel;

/**
 *  功能:显示hud
 */
- (void)showHUD;

/**
 *  功能:显示字符串hud
 */
- (void)showHUD:(NSString *)aMessage;
- (void)showHUD:(NSString *)aMessage animated:(BOOL)animated;

/**
 *  功能:显示字符串hud几秒钟时间
 */
- (void)showStringHUD:(NSString *)aMessage second:(int)aSecond;

/**
 *  功能:隐藏hud
 */
- (void)hideHUD;
- (void)hideHUD:(BOOL)animated;
- (void)hideAllHUD;

/**
 *  功能:接口请求失败
 */
-(void)failureHideHUD;
@end
