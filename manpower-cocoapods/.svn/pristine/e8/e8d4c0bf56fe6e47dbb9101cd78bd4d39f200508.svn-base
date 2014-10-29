//
//  SendBox.h
//  manpower
//
//  Created by WangShunzhou on 14-6-9.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//
#define SEND_BOX_TOP_VIEW_HEIGHT 51
#define SEND_BOX_FULL_VIEW_HEIGHT 172
#define WINDOW_HEIGHT [[[UIApplication sharedApplication] delegate] window].frame.size.height
#define SEND_BOX_SUPER_CONTENT_VIEW_HEIGHT WINDOW_HEIGHT - 64


#define SEND_BOX_TOP_VIEW_FRAME CGRectMake(0, SEND_BOX_SUPER_CONTENT_VIEW_HEIGHT - SEND_BOX_TOP_VIEW_HEIGHT, 320, SEND_BOX_TOP_VIEW_HEIGHT)
#define SEND_BOX_FULL_VIEW_FRAME CGRectMake(0, SEND_BOX_SUPER_CONTENT_VIEW_HEIGHT - SEND_BOX_FULL_VIEW_HEIGHT, 320, SEND_BOX_FULL_VIEW_HEIGHT)


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class XMPPManager;
@class SendBox;
@class XMPPJID;
@class RLSendMessageVC;
@class IMRecorder;
@class IMRecorderMicView;
@class FaceBoard;

@protocol SendBoxDelegate <NSObject>
@optional
-(void)sendBox:(SendBox*)sendBox MessageDidSent:(NSString*)message;
-(void)keyboardWillShow:(SendBox*)sendBox;
-(void)keyboardWillBeHidden:(SendBox*)sendBox;
-(void)detailViewWillShow:(SendBox*)sendBox;
-(void)detailViewWillHide:(SendBox *)sendBox animated:(BOOL)animated;

@end

@interface SendBox : UIView<UITextFieldDelegate,
                            UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate,
                            AVAudioRecorderDelegate,
                            AVAudioPlayerDelegate>{
    XMPPManager *xmpp;
//    AVAudioRecorder *recorder;
    IMRecorder *recorder;
    AVAudioPlayer *player;
    NSTimer *recorderSpy;
//    NSTimeInterval timeInterval;
}
@property(assign, nonatomic)IBOutlet UITextField *textField;  //文字 文本框
@property(assign, nonatomic)IBOutlet UIButton *addButton;   //加号按键
@property(assign, nonatomic)IBOutlet UIButton *toggleButton;    // 语音/文字切换按键
@property(assign, nonatomic)IBOutlet UIButton *soundButton; // 按住说话 按键
@property(assign, nonatomic)IBOutlet UIButton *micButton; // 麦克风 按键
@property(assign, nonatomic)IBOutlet UIButton *keyboardButton; // 键盘 按键（右边，与麦克风按键重叠）
@property(assign, nonatomic)IBOutlet UIButton *keyboardButton2; // 键盘 按键（左边，与表情按键重叠）
@property(assign, nonatomic)IBOutlet UIButton *emotionButton; // 表情 按键

@property(assign, nonatomic)IBOutlet UIView *topView;
@property(assign, nonatomic)IBOutlet UIView *bottomView;

@property(assign, nonatomic)IBOutlet UIButton *cameraButton;
@property(assign, nonatomic)IBOutlet UIButton *photoButton;
@property(assign, nonatomic)IBOutlet UIButton *locationButton;

@property(strong, nonatomic) XMPPJID *friendJID;
@property(assign, nonatomic) id<SendBoxDelegate> delegate;
@property(assign, nonatomic) CGRect keyboardFrame;
@property(assign, nonatomic) RLSendMessageVC *sendMessageVC;
@property(strong,nonatomic) IMRecorderMicView *micView;
@property(assign,nonatomic) BOOL shouldMoveToBottom;
@property(strong, nonatomic) FaceBoard *faceBoard;

-(BOOL)onlyTopViewShown;
-(BOOL)onlyActiveTopViewShown;

+(SendBox*)sendBox;
@end

