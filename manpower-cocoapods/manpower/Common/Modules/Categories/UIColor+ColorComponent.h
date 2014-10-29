//
//  UIColor+ColorComponent.h
//  manpower
//
//  Created by WangShunzhou on 14-9-29.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorComponent)
-(BOOL)isLightColor;
-(void)getRGBComponents:(CGFloat [3])components;
@end
