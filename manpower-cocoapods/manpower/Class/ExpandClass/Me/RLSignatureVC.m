//
//  RLSignatureVC.m
//  manpower
//
//  Created by WangShunzhou on 14-9-15.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLSignatureVC.h"
#import "RLMyInfo.h"

@interface RLSignatureVC ()<UITextViewDelegate>
@property(nonatomic, strong) NSString *placeholder;
@property(nonatomic) NSInteger maxLength;

@property (nonatomic) IBOutlet UITextView *textView;
@property(nonatomic, assign) IBOutlet UILabel *remainTextLabel;
@property(nonatomic, assign) IBOutlet UILabel *placeholderLabel;
@end

@implementation RLSignatureVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.placeholder = @"点此输入个性签名";
        self.maxLength = 30;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setReturnBtnTitle:@"返回" BadgeNumber:0];
    self.textView.layer.borderColor = [UIColorFromRGB(0x999999) CGColor];
    self.textView.layer.borderWidth = 0.5;
    self.textView.delegate = self;
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1) {
        self.textView.contentInset = UIEdgeInsetsMake(0, -3, 0, -3);
    }
    
    self.placeholderLabel.text = self.placeholder;
    RLMyInfo *myInfo = [RLMyInfo sharedRLMyInfo];
    if (myInfo.signature.length) {
        self.textView.text = myInfo.signature;
    }
    self.remainTextLabel.text = [NSString stringWithFormat:@"%d", self.maxLength - self.textView.text.length];


    __block UIButton *rightButton = [self setRightBarButtonWithTitle:@"完成" withTarget:self withSelector:@selector(doneClicked:)];
    @weakify(self);
    [self.textView.rac_textSignal subscribeNext:^(NSString *newString){
        @strongify(self);
        // 剩余字符
        self.remainTextLabel.text = [NSString stringWithFormat:@"%d", self.maxLength - self.textView.text.length];
    }];
    
    // 显示placeholder
    RAC(self.placeholderLabel, hidden) = [RACSignal combineLatest:@[self.textView.rac_textSignal] reduce:^(NSString *newString){
        return @(newString.length != 0);
//        return @NO;
    }];
    
    RAC(rightButton, enabled) = [RACSignal combineLatest:@[self.textView.rac_textSignal] reduce:^(NSString *newString){
        return @(newString.length <= _maxLength);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneClicked:(id)sender{
    if (self.textView.text.length > self.maxLength) {
        return;
    }
    RLMyInfo *myInfo = [RLMyInfo sharedRLMyInfo];
    myInfo.signature = self.textView.text;
    @weakify(self);
    [myInfo updateInfoWithSuccess:^(id json){
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:NULL];
    
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
////    if (temp.length > self.maxLength) {
////        textView.text = [temp substringToIndex:self.maxLength];
////        return NO;
////    }
//    self.remainTextLabel.text = [NSString stringWithFormat:@"%d", self.maxLength - temp.length];
//
//    return YES;
//}

@end
