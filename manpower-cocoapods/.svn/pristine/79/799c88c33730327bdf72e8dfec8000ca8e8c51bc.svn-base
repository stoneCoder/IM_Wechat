//
//  IMRecorderMicView.m
//  manpower
//
//  Created by WangShunzhou on 14-6-27.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "IMRecorderMicView.h"

#define MSG_MIC_VIEW_EDGE 151
#define VOLUME_LEVEL 8

@interface IMRecorderMicView(){
    NSMutableArray *cachedMicImageArr;
}
@end

@implementation IMRecorderMicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MSG_MIC_VIEW_EDGE, MSG_MIC_VIEW_EDGE);
        CGSize size = [UIScreen mainScreen].bounds.size;
        self.center = CGPointMake(size.width * 0.5, size.height * 0.5 - 64);
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.55];
        [self initMicView];
        [self initRecycleView];
        self.hidden = YES;
        
        cachedMicImageArr = [NSMutableArray array];
        for (int i=0; i < VOLUME_LEVEL; i++) {
            UIImage *image =  [UIImage imageNamed:[NSString stringWithFormat:@"dialog_BigPhone_%d",i]];
            [cachedMicImageArr addObject:image];
        }
    }

    return self;
}

-(void)initMicView{
    // Wapper
    self.micWarpperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSG_MIC_VIEW_EDGE, MSG_MIC_VIEW_EDGE)];
    self.micWarpperView.backgroundColor = [UIColor clearColor];
    self.micWarpperView.hidden = YES;
    
    // 麦克风
//    self.micIV = [[UIImageView alloc] initWithImage:cachedMicImageArr[0]];
    self.micIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dialog_BigPhone_0"]];
    CGRect frame = self.micIV.frame;
    frame.origin.x = 51;
    frame.origin.y = 25;
    self.micIV.frame = frame;

    // 计时器
    self.micSecLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.micSecLabel.text = @"00:00";
    self.micSecLabel.textColor = [UIColor colorWithRed:1 green:0.5625 blue:0 alpha:1];
    self.micSecLabel.font = [UIFont systemFontOfSize:17];
    self.micSecLabel.backgroundColor = [UIColor clearColor];
    [self.micSecLabel sizeToFit];
    frame = self.micSecLabel.frame;
    frame.origin.x = (MSG_MIC_VIEW_EDGE - frame.size.width) * 0.5;
    frame.origin.y = self.micIV.frame.origin.y + self.micIV.frame.size.height + 8;
    [self.micSecLabel setFrame:frame];
    
    // 提示文本
    self.micTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.micTextLabel.text = ALERT_TEXT_SLIDE_UP_CANCEL;
    self.micTextLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.micTextLabel.font = [UIFont systemFontOfSize:12];
    self.micTextLabel.backgroundColor = [UIColor clearColor];
    [self.micTextLabel sizeToFit];
    frame = self.micTextLabel.frame;
    frame.origin.x = (MSG_MIC_VIEW_EDGE - frame.size.width) * 0.5;
    frame.origin.y = self.micSecLabel.frame.origin.y + self.micSecLabel.frame.size.height + 4;
    [self.micTextLabel setFrame:frame];
    
    [self.micWarpperView addSubview:self.micIV];
    [self.micWarpperView addSubview:self.micSecLabel];
    [self.micWarpperView addSubview:self.micTextLabel];
    [self addSubview:self.micWarpperView];
}

-(void)initRecycleView{
    // Wapper
    self.recycleWarpperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSG_MIC_VIEW_EDGE, MSG_MIC_VIEW_EDGE)];
    self.recycleWarpperView.backgroundColor = [UIColor clearColor];
    self.recycleWarpperView.hidden = YES;
    
    // 麦克风
    self.recycleIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dialog_del"]];
    CGRect frame = self.recycleIV.frame;
    frame.origin.x = 52;
    frame.origin.y = 40;
    self.recycleIV.frame = frame;
    
    // 提示文本
    self.recycleTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.recycleTextLabel.text = ALERT_TEXT_TOUCH_UP_CANCEL;
    self.recycleTextLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.recycleTextLabel.font = [UIFont systemFontOfSize:14];
    self.recycleTextLabel.backgroundColor = [UIColor clearColor];
    [self.recycleTextLabel sizeToFit];
    frame = self.recycleTextLabel.frame;
    frame.origin.x = (MSG_MIC_VIEW_EDGE - frame.size.width) * 0.5;
    frame.origin.y = self.recycleIV.frame.origin.y + self.recycleIV.frame.size.height + 16;
    [self.recycleTextLabel setFrame:frame];
    
    [self.recycleWarpperView addSubview:self.recycleIV];
    [self.recycleWarpperView addSubview:self.recycleTextLabel];
    [self addSubview:self.recycleWarpperView];
}

-(void)switchToMic{
    self.recycleWarpperView.hidden = YES;
    self.micWarpperView.hidden = NO;
    self.hidden = NO;
}

-(void)switchToRecycle{
    self.micWarpperView.hidden = YES;
    self.recycleWarpperView.hidden = NO;
    self.hidden = NO;
}
-(void)clear{
    self.hidden = YES;
    self.micSecLabel.text = @"00:00";
}

-(void)updateVolume:(CGFloat)volume withCurrentTime:(double)currentTime{
    int level = ceil(volume * VOLUME_LEVEL);
    level = level > VOLUME_LEVEL?VOLUME_LEVEL:level;
//    NSString *imageName = [NSString stringWithFormat:@"dialog_BigPhone_%d", level];
//    self.micIV.image = [UIImage imageNamed:imageName];
    self.micIV.image = cachedMicImageArr[level-1];
    DDLogVerbose(@"===========================\n%@",    self.micIV.image);
   
    int second = (int)currentTime;
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    self.micSecLabel.text = [formatter stringFromDate:date];
    
//    self.micSecLabel.text = [NSString stringWithFormat:@"00:0%d",(int)currentTime];
}

@end
