//
//  UILabel+TitleLabel_UILabel.h
//  cntianran
//
//  Created by WangShunzhou on 14-5-29.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMLabel : NSObject 

+(UILabel*)initWithString:(NSString*)msgText withColor:(UIColor*)color withBold:(BOOL)bold;

+(UILabel*)labelWithTitle:(NSString*)msgText;
+(UILabel*)labelWithSubTitle:(NSString*)msgText;
+(UILabel*)labelWithText:(NSString*)msgText;

@end
