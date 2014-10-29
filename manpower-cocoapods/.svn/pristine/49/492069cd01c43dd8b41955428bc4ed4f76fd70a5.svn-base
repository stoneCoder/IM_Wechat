//
//  SWDatePickView.m
//  manpower
//
//  Created by WangShunzhou on 14-9-15.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "SWDatePickerView.h"
@interface SWDatePickerView()
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIButton *okButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIView *maskView;
@end


@implementation SWDatePickerView

+(SWDatePickerView*)datePickerView{
    return [SWDatePickerView datePickerViewWithDate:nil];
}

+(SWDatePickerView*)datePickerViewWithDate:(NSDate*)date{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SWDatePickerView" owner:self options:nil];
    SWDatePickerView *datePickerView = nil;
    if ([nibs count]) {
        datePickerView = [nibs objectAtIndex:0];
        datePickerView.date = date;
        [datePickerView setupDatePickerView];
        [datePickerView setupMaskView];
    }
    return datePickerView;
}

-(void)setupDatePickerView{
    self.layer.anchorPoint = CGPointMake(0, 0);
    NSDate *initDate = _date ? _date : [NSDate date];
    self.datePicker.date = initDate;
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    [self.datePicker setMaximumDate:[NSDate date]];
    [self.datePicker addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)setupMaskView{
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.maskView.backgroundColor = UIColorFromRGBA(0x000000, 0);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [SWDatePickerView datePickerView];
    return self;
}

-(IBAction)cancelButtonClicked:(id)sender{
    if ([_delegate respondsToSelector:@selector(datePickerView:withDate:cancel:)]) {
        [_delegate datePickerView:self withDate:self.datePicker.date cancel:YES];
    }
    [self dismiss];
}

-(IBAction)okButtonClicked:(id)sender{
    if ([_delegate respondsToSelector:@selector(datePickerView:withDate:cancel:)]) {
        [_delegate datePickerView:self withDate:self.datePicker.date cancel:NO];
    }
    [self dismiss];
}

-(void)dismiss{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.maskView.backgroundColor = UIColorFromRGBA(0x000000, 0);
        weakSelf.layer.position = CGPointMake(0, screenSize.height);
    } completion:^(BOOL finished){
        [weakSelf.maskView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

-(void)showInView:(UIView*)view{
    [view addSubview:self.maskView];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [view addSubview:self];
    self.layer.position = CGPointMake(0, screenSize.height);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.maskView.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        weakSelf.layer.position = CGPointMake(0, view.frame.size.height - weakSelf.frame.size.height-20);
    }];
}

-(void)valueChanged:(id)sender{
    
}

@end
