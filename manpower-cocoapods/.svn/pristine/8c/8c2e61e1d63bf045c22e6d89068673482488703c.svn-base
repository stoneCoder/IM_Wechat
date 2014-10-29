//
//  UILabel+TitleLabel_UILabel.m
//  cntianran
//
//  Created by WangShunzhou on 14-5-29.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "IMLabel.h"

@implementation IMLabel

+(UILabel*)initWithString:(NSString*)msgText withColor:(UIColor*)color withBold:(BOOL)bold{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = msgText;
    if (bold) {
        label.font = [UIFont boldSystemFontOfSize:16];
    }else{
        label.font = [UIFont systemFontOfSize:16];
    }
    label.textColor = color;
    [label sizeToFit];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+(UILabel*)labelWithTitle:(NSString*)msgText{
    return [IMLabel initWithString:msgText withColor:[UIColor colorWithWhite:0.1 alpha:1] withBold:YES];
}

+(UILabel*)labelWithSubTitle:(NSString*)msgText{
    return [IMLabel initWithString:msgText withColor:[UIColor colorWithWhite:0.5 alpha:1] withBold:NO];
}

+(UILabel*)labelWithText:(NSString*)msgText{
    return [IMLabel initWithString:msgText withColor:[UIColor colorWithWhite:0.1 alpha:1] withBold:NO];
}
@end
