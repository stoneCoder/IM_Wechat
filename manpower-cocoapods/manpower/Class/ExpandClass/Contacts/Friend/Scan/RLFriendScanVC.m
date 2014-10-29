//
//  RLFriendScanVC.m
//  manpower
//
//  Created by hanjin on 14-8-13.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLFriendScanVC.h"
#import "RLMyCodeVC.h"
#import "ZBarSDK.h"
#import "ZBarReaderView.h"
@interface RLFriendScanVC ()<ZBarReaderViewDelegate>
@property (strong,nonatomic) ZBarReaderView * readView;

@end

@implementation RLFriendScanVC
@synthesize readView=_readView;
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
    // Do any additional setup after loading the view from its nib.
    [self setTitleText:@"扫一扫"];
    [self makeNaviLeftButtonVisible:YES];
    
    [self initReadView];
   
}

/**
 *  功能:初始化扫瞄
 */

-(void)initReadView{

    CGRect topViewRect=[UIScreen mainScreen].bounds;
   // topViewRect.size.height-=60+44+20;
    topViewRect.size.height-=iOS7?60:60+20;

    UIView * maskView=[[UIView alloc]initWithFrame:topViewRect];
    maskView.backgroundColor=[UIColor blueColor];
    //[self.view addSubview:maskView];
    
    
    
    _readView=[ZBarReaderView new];
    [_readView setFrame:topViewRect];
    _readView.readerDelegate=self;
    _readView.torchMode=0;
    [self.view addSubview:_readView];
    [_readView start];

}


#pragma mark - ZBarReaderViewDelegate
- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image{
    for (ZBarSymbol * symbol in symbols) {
        NSLog(@"symbols=%@",symbol.data);
        
    }
    if (symbols.filterSymbols) {
        [readerView stop];
        // [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - Action
- (IBAction)toMyCodeVC:(id)sender {
    RLMyCodeVC * myCodeVC=[[RLMyCodeVC alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:myCodeVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
