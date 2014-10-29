//
//  IMRecorder.h
//  manpower
//
//  Created by WangShunzhou on 14-6-16.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface IMRecorder : AVAudioRecorder
@property (nonatomic, copy) NSString* wavTmpFilePath;
@property (nonatomic, copy) NSString* amrTmpFilePath;
@property (nonatomic, copy) NSString* wavFilePath;
@property (nonatomic, copy) NSString* amrFilePath;

@end
