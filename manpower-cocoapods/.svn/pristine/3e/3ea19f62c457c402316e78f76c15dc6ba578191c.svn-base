//
//  SWDatePickView.h
//  manpower
//
//  Created by WangShunzhou on 14-9-15.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWDatePickerView;

@protocol SWDatePickerViewDelegate <NSObject>

-(void)datePickerView:(SWDatePickerView *)datePickerView withDate:(NSDate*)date cancel:(BOOL)cancel;

@end

@interface SWDatePickerView : UIView

@property (nonatomic,assign) id<SWDatePickerViewDelegate>delegate;
@property (nonatomic,strong) NSDate *date;

+(SWDatePickerView*)datePickerView;
+(SWDatePickerView*)datePickerViewWithDate:(NSDate*)date;
-(void)showInView:(UIView*)view;

@end