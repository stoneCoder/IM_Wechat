//
//  RLGroupChatVC.h
//  manpower
//
//  Created by hanjin on 14-6-6.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "RLBaseVC.h"
#import "RLGroupVO.h"
#import "SendBox.h"
#import "XMPPRoomMessageMemoryStorageObject.h"
@interface RLGroupChatVC : RLBaseVC<SendBoxDelegate>

@property (strong,nonatomic) RLGroupVO * groupVO;
@property (strong, nonatomic) SendBox *sendBox;
@property (strong, nonatomic) XMPPRoomMessageMemoryStorageObject *xmppRoomMessageMemoryStorageObject;
@end
