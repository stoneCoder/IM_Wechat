//
//  RLSignatureVC.h
//  manpower
//
//  Created by WangShunzhou on 14-9-15.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLBaseVC.h"


typedef NS_ENUM(NSInteger, RLGroupInfoType){
    RLGroupInfoTypeDescription,
    RLGroupInfoTypeSubject,
};

@class RLGroupVO;
@class RLRoom;

@interface RLTextViewEditor : RLBaseVC
@property(nonatomic, strong) RLGroupVO * group;
@property(nonatomic, strong) RLRoom * room;

+(RLTextViewEditor*)textViewEditorWithType:(RLGroupInfoType)type withText:(NSString*)text;
@end
