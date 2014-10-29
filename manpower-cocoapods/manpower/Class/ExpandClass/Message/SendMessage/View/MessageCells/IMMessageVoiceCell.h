//
//  IMMessageVoiceCell.h
//  manpower
//
//  Created by WangShunzhou on 14-6-19.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "IMMessageBaseCell.h"
#import "VoiceBarView.h"
#import <AVFoundation/AVFoundation.h>

#import "ZMMessage.h"
@interface IMMessageVoiceCell : IMMessageBaseCell<AVAudioPlayerDelegate>{
}

@property(nonatomic, strong) UIImageView *hornIV;
@property(nonatomic, strong) VoiceBarView *voiceBarIV;
@property(nonatomic, strong) UILabel *secondLabel;
@property(nonatomic, strong) UIImageView *unreadIV;

-(void)configureWithMessage:(ZMMessage*)message withMyPhoto:(UIImage*)myPhoto withFriendPhoto:(UIImage*)friendPhoto withIndexPath:(NSIndexPath*)indexPath;
@end
