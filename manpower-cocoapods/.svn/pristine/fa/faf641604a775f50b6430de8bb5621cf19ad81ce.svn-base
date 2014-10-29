//
//  RLBaseTableVC.m
//  manpower
//
//  Created by WangShunzhou on 14-6-6.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLBaseTableVC.h"

@interface RLBaseTableVC ()

@property(nonatomic, assign) CGSize visibleSize;

@end

@implementation RLBaseTableVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.tableView == nil) {
        CGRect frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 108);
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }
    if (iOS7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return 0;};
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
@end


@implementation UITableView (RLBaseTableVC)

-(void)scrollToBottom{
    [self scrollToBottom:YES withVisibleHeight:0];
}

-(void)scrollToBottomWithVisibleHeight:(CGFloat)visibleHeight{
    [self scrollToBottom:YES withVisibleHeight:visibleHeight];
}

-(void)scrollToBottomWithoutAnimation{
    [self scrollToBottom:NO withVisibleHeight:0];
}

-(void)scrollToBottomWithVisibleHeightButAnimation:(CGFloat)visibleHeight{
    [self scrollToBottom:NO withVisibleHeight:visibleHeight];
}

-(void)scrollToBottom:(BOOL)animation withVisibleHeight:(CGFloat)visibleHeight{
    if (visibleHeight == 0) {
        visibleHeight = self.frame.size.height;
    }
    if (self.contentSize.height > visibleHeight)
    {
        CGPoint offset = CGPointMake(0, self.contentSize.height - visibleHeight);
        [self setContentOffset:offset animated:animation];
    }
}
@end
