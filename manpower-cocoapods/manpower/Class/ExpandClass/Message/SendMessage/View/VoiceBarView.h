//
//  VoiceBarView.h
//  manpower
//
//  Created by WangShunzhou on 14-6-20.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VoiceBarView : UIView

@property(nonatomic, strong) id userInfo;
@property(nonatomic, strong) AVAudioPlayer *player;
@end
