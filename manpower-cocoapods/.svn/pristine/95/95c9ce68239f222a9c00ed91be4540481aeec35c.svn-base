//
//  TextMessageView.h
//  manpower
//
//  Created by WangShunzhou on 14-7-9.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//


#import <UIKit/UIKit.h>


#define KFacialSizeWidth    20
#define KFacialSizeHeight   20
#define KCharacterWidth     8
#define VIEW_LINE_HEIGHT    20
#define VIEW_LEFT           0
#define VIEW_RIGHT          5
#define VIEW_TOP            0
#define VIEW_WIDTH_MAX      MSG_CONTENT_MAX_WIDTH - MSG_TEXT_MARGIN_H * 2 - MSG_BUBBLE_LENGTH

@interface TextMessageView : UIView {
    CGFloat upX;
    CGFloat upY;
    CGFloat lastPlusSize;
    CGFloat viewWidth;
    CGFloat viewHeight;
    BOOL isLineReturn;
}

@property (nonatomic, strong) NSMutableArray *data;

- (void)showMessage:(NSArray *)message;


@end
