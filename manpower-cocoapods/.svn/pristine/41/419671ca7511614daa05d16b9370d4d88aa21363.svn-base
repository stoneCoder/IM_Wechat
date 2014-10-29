//
//  RLMyInfoHeaderView.h
//  manpower
//
//  Created by WangShunzhou on 14-9-12.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBActionSheet.h"

@interface RLMyInfoHeaderView : UIView<IBActionSheetDelegate>
@property(nonatomic, assign) IBOutlet UILabel *subtitleLabel;
@property(nonatomic, assign) IBOutlet UIImageView *backgroundIV;
@property(nonatomic, assign) IBOutlet UIImageView *photoIV;
@property(nonatomic, assign) IBOutlet UITextField *titleTextField;

+ (RLMyInfoHeaderView*)headerView;
+ (RLMyInfoHeaderView*)headerViewWithTitle:(NSString*)title withSubtitle:(NSString*)subtitle;
+ (RLMyInfoHeaderView*)headerViewWithViewController:(UIViewController*)viewController;
+ (RLMyInfoHeaderView*)headerViewWithViewController:(UIViewController *)viewController
                                withPhotoChangeable:(BOOL)photoChangeable
                           withBackgroundChangeable:(BOOL)backgroundChangeable
                                 withNameChangeable:(BOOL)nameChangeable
                                          withTitle:(NSString*)title
                                       withSubtitle:(NSString*)subtitle;
@end
