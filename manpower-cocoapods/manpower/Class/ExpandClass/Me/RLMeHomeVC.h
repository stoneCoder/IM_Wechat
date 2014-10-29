//
//  RLMeHomeVC.h
//  manpower
//
//  Created by hanjin on 14-6-4.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLBaseVC.h"
#import "RLMeInfoCell.h"
#import "RLInfoCell.h"
#import "RLLoginVC.h"


@class XMPPManager;

@interface RLMeHomeVC : RLBaseVC{
    XMPPManager *xmpp;
}

@property (strong,nonatomic) RLMeInfoCell *headViewCell;
@property (strong,nonatomic) RLInfoCell *secondViewCell;
@property (strong,nonatomic) RLInfoCell *thirdViewCell;
@property (strong,nonatomic) UIButton *replaceButton;
@property (strong,nonatomic) IBOutlet UIButton *quitButton;

@end
