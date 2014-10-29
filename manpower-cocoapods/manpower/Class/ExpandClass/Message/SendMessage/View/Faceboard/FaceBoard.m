//
//  FaceBoard.m
//  manpower
//
//  Created by WangShunzhou on 14-7-9.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "FaceBoard.h"


#define FACE_COUNT_ALL  85

#define FACE_COUNT_ROW  3

#define FACE_COUNT_CLU  7

#define FACE_COUNT_PAGE ( FACE_COUNT_ROW * FACE_COUNT_CLU )

#define FACE_ICON_SIZE  44

#define MSG_EMOTION_CN @"emotion_cn"
// Todo 如果要兼容英文系统，把下一行enmotion_cn改为emotion_en，并加入对应plist文件。
#define MSG_EMOTION_EN @"emotion_cn"

@implementation FaceBoard

@synthesize delegate;

@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;

- (id)init {

    self = [super initWithFrame:CGRectMake(0, 0, 320, 216)];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
        if ([[languages objectAtIndex:0] hasPrefix:@"zh"]) {

            _faceMap = [NSDictionary dictionaryWithContentsOfFile:
                         [[NSBundle mainBundle] pathForResource:MSG_EMOTION_CN
                                                         ofType:@"plist"]];
        }
        else {

            _faceMap = [NSDictionary dictionaryWithContentsOfFile:
                         [[NSBundle mainBundle] pathForResource:MSG_EMOTION_EN
                                                         ofType:@"plist"]];
//            DDLogInfo(@"%@",[_faceMap description]);
        }
       
        [[NSUserDefaults standardUserDefaults] setObject:_faceMap forKey:@"FaceMap"];

        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 190)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake((FACE_COUNT_ALL / FACE_COUNT_PAGE + 1) * 320, 190);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        int page = (FACE_COUNT_ALL / FACE_COUNT_PAGE) + 1;
        int totalEmotion = page + FACE_COUNT_ALL;
        int emotionIndex = 1;
        for (int i = 1; i <= totalEmotion; i++) {
            
            //计算每一个表情按钮的坐标和在哪一屏
            CGFloat x = (((i - 1) % FACE_COUNT_PAGE) % FACE_COUNT_CLU) * FACE_ICON_SIZE + 6 + ((i - 1) / FACE_COUNT_PAGE * 320);
            CGFloat y = (((i - 1) % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * FACE_ICON_SIZE + 8;

            if (i % FACE_COUNT_PAGE == 0) {
                [self setupBackspaceButtonWithX:x withY:y];
            }else if (i == totalEmotion){
                int pageIndex = page - 1;
                float x = (FACE_COUNT_CLU - 1) * FACE_ICON_SIZE + 6 + pageIndex * 320;
                float y = (FACE_COUNT_ROW - 1) * FACE_ICON_SIZE + 8;
                [self setupBackspaceButtonWithX:x withY:y];
            }else{
                FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
                faceButton.buttonIndex = emotionIndex;
                
                [faceButton addTarget:self
                               action:@selector(faceButton:)
                     forControlEvents:UIControlEventTouchUpInside];
                
                faceButton.frame = CGRectMake( x, y, FACE_ICON_SIZE, FACE_ICON_SIZE);
                
                [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d", emotionIndex]]
                            forState:UIControlStateNormal];
                
                [faceView addSubview:faceButton];
                emotionIndex++;
            }
        }
        
        //添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(0, 190, 320, 20)];
        
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = FACE_COUNT_ALL / FACE_COUNT_PAGE + 1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
        //删除键
//        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//        [back setTitle:@"删除" forState:UIControlStateNormal];
//        [back setImage:[UIImage imageNamed:@"del_emoji_normal"] forState:UIControlStateNormal];
//        [back setImage:[UIImage imageNamed:@"del_emoji_select"] forState:UIControlStateSelected];
//        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
//        back.frame = CGRectMake(272, 182, 38, 28);
//        [self addSubview:back];
        

        // 画线
        UIImageView* lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 180, 320, 1)];
        lineIV.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [self addSubview:lineIV];
        
        // 发送键
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setImage:[UIImage imageNamed:@"btn_send"] forState:UIControlStateNormal];
        //        [sendButton setBackgroundColor:[UIColor colorWithRed:0.3 green:0.4 blue:1 alpha:1]];
        [sendButton.layer setCornerRadius:1];
        [sendButton setFrame:CGRectMake(260, 180, 60, 36)];
        [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:sendButton];
    }

    return self;
}

-(void)setupBackspaceButtonWithX:(CGFloat)x withY:(CGFloat)y{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:@"删除" forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"btn_del"] forState:UIControlStateNormal];
//    [back setImage:[UIImage imageNamed:@"del_emoji_select"] forState:UIControlStateSelected];
    [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(x+(FACE_ICON_SIZE-28)*0.5, y+(FACE_ICON_SIZE-18)*0.5, 28, 18);
    [faceView addSubview:back];
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [facePageControl setCurrentPage:faceView.contentOffset.x / 320];
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {

    [faceView setContentOffset:CGPointMake(facePageControl.currentPage * 320, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(id)sender {

    NSInteger i = ((FaceButton*)sender).buttonIndex;
    if (self.inputTextField) {
        if (self.inputTextField.text == nil) {
            self.inputTextField.text = @"";
        }
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"%03d", (int)i]]];
                self.inputTextField.text = faceString;
    }

    if (self.inputTextView) {

        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"%03d", (int)i]]];
//        NSLog(@"%@",[NSString stringWithFormat:@"%03d", i]);
//        NSLog(@"%@",[_faceMap objectForKey:[NSString stringWithFormat:@"%03d", i]]);
//        NSLog(@"%@",[_faceMap description]);
        self.inputTextView.text = faceString;

        [delegate textViewDidChange:self.inputTextView];
    }
}

- (void)backFace{
    NSString *inputString;
    inputString = self.inputTextField.text;
    if ( self.inputTextView ) {
        inputString = self.inputTextView.text;
    }

    if ( inputString.length ) {
        NSString *string = nil;
        NSInteger stringLength = inputString.length;
        NSError *error = nil;
        NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:@"\\[[^\\[\\]]+\\]"
                                                                                      options:NSRegularExpressionCaseInsensitive
                                                                                        error:&error];
        if (error) {
            DDLogError(@"%@",error);
            return;
        }

        NSArray *matches = [regularExpression matchesInString:inputString options:0 range:NSMakeRange(0, inputString.length)];
        if ([matches count] && [[inputString substringFromIndex:stringLength-1] isEqualToString:@"]"]) {
            NSTextCheckingResult *match = [matches lastObject];
            NSRange matchRange = [match range];
            string = [inputString stringByReplacingCharactersInRange:matchRange withString:@""];
        } else {
            string = [inputString substringToIndex:stringLength - 1];
        }
        if ( self.inputTextField ) {
            self.inputTextField.text = string;
        }
        if ( self.inputTextView ) {
            self.inputTextView.text = string;
            [delegate textViewDidChange:self.inputTextView];
        }
    }
}

-(IBAction)sendButtonClicked:(id)sender{
//    DDLogVerbose(@"send");
    [delegate faceBoard:self sendButtonClicked:sender];
}

@end
