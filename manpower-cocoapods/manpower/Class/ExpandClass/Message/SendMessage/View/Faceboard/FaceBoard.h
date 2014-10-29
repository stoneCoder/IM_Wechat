//
//  FaceBoard.h
//  manpower
//
//  Created by WangShunzhou on 14-7-9.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "FaceButton.h"

#import "GrayPageControl.h"


#define FACE_NAME_BEGIN  @"["
#define FACE_NAME_END  @"]"

// 表情转义字符的长度（ /s占2个长度，xxx占3个长度，共5个长度 ）
#define FACE_NAME_LEN   5
@class FaceBoard;

@protocol FaceBoardDelegate <NSObject>

@optional

- (void)textViewDidChange:(UITextView *)textView;

- (void)faceBoard:(FaceBoard*)faceBoard sendButtonClicked:(id)sender;

@end


@interface FaceBoard : UIView<UIScrollViewDelegate>{

    UIScrollView *faceView;

    GrayPageControl *facePageControl;

    NSDictionary *_faceMap;
}


@property (nonatomic, assign) id<FaceBoardDelegate> delegate;


@property (nonatomic, retain) UITextField *inputTextField;

@property (nonatomic, retain) UITextView *inputTextView;


- (void)backFace;


@end
