//
//  RegisterVC.h
//  manpower
//
//  Created by WangShunzhou on 14-6-4.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLBaseVC.h"
#import "IMAlert.h"
#import "RLPassWordVC.h"

@interface RLRegisterVC : RLBaseVC

@property(nonatomic, assign) NSInteger type;    //0:注册; 1:忘记密码;

@end
