//
//  RLGroupInfoHeaderView.h
//  manpower
//
//  Created by WangShunzhou on 14-9-12.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBActionSheet.h"
@class RLGroupVO;
@class RLRoom;

@interface RLGroupInfoHeaderView : UIView<IBActionSheetDelegate>
@property(nonatomic, assign) IBOutlet UILabel *subtitleLabel;
@property(nonatomic, assign) IBOutlet UIImageView *backgroundIV;
@property(nonatomic, assign) IBOutlet UIImageView *photoIV;
@property(nonatomic, assign) IBOutlet UITextField *titleTextField;
@property(nonatomic, strong) RLGroupVO *group;
@property(nonatomic, strong) RLRoom *room;


+ (RLGroupInfoHeaderView*)headerView;
+ (RLGroupInfoHeaderView*)headerViewWithViewController:(UIViewController*)viewController;
+ (RLGroupInfoHeaderView*)headerViewWithViewController:(UIViewController *)viewController
                                withPhotoChangeable:(BOOL)photoChangeable
                           withBackgroundChangeable:(BOOL)backgroundChangeable
                                 withNameChangeable:(BOOL)nameChangeable;
@end
