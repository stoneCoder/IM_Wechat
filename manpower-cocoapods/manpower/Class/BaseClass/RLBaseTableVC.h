//
//  RLBaseTableVC.h
//  manpower
//
//  Created by WangShunzhou on 14-6-6.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLBaseVC.h"

@interface RLBaseTableVC : RLBaseVC<UITableViewDataSource, UITableViewDelegate>{}
@property(strong, nonatomic) IBOutlet UITableView *tableView;

@end


@interface UITableView (RLBaseTableVC)
-(void)scrollToBottom;
-(void)scrollToBottomWithoutAnimation;
-(void)scrollToBottomWithVisibleHeight:(CGFloat)visibleHeight;
-(void)scrollToBottomWithVisibleHeightButAnimation:(CGFloat)visibleHeight;
-(void)scrollToBottom:(BOOL)animation withVisibleHeight:(CGFloat)visibleHeight;
@end